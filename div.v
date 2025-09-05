module div(
    clock,
    data_operandA,
    data_operandB, 
    ctrl_DIV,
    data_result,   
    data_exception,
    data_resultRDY
);
    input         clock;
    input  [31:0] data_operandA, data_operandB;
    input         ctrl_DIV;
    output [31:0] data_result;
    output        data_exception, data_resultRDY;

    // Divide-by-zero?
    comparator_32bit comp(.a(data_operandB), .b(32'b0), .equal(data_exception));

    // Absolute value
    wire [31:0] dividend_abs, divisor_abs, data_operandA_neg, data_operandB_neg;
    wire dummy;
    CLA negate_A(.sum(data_operandA_neg), .c32(dummy), .a(~data_operandA), .b(32'b0), .c0(1'b1));
    CLA negate_B(.sum(data_operandB_neg), .c32(dummy), .a(~data_operandB), .b(32'b0), .c0(1'b1));

    assign dividend_abs = data_operandA[31] ? (data_operandA_neg) : data_operandA;
    assign divisor_abs  = data_operandB[31] ? (data_operandB_neg) : data_operandB;

    // Sign fix
    wire quotient_negative;
    assign quotient_negative = data_operandA[31] ^ data_operandB[31];

    // Busy when division operation
    wire [31:0] Q, next_Q;
    wire [32:0] A, next_A;
    wire [5:0]  count, next_count;
    wire busy, next_busy;

    // When count equals 32, done
    wire count_is_32;
    assign count_is_32 = count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0];

    // Busy latch sets busy on until count = 32
    assign next_busy = ctrl_DIV ? 1'b1 : (busy & ~count_is_32);
    dffe_ref busy_reg(.q(busy), .d(next_busy), .clk(clock), .en(1'b1), .clr(1'b0));

    // Counter update
    wire [31:0] cla_sum;        
    wire        c32_unused;     
    wire [5:0]  count_plus_one;

    CLA add_count (
        .sum (cla_sum),
        .c32 (c32_unused),
        .a   ({26'b0, count}),   
        .b   (32'd1),  
        .c0  (1'b0)
    );

    assign count_plus_one = cla_sum[5:0];
    wire[5:0] count_help;
    assign count_help = busy ? count_plus_one : count;
    assign next_count = ctrl_DIV ? 6'b0 : count_help;
    genvar i;
    generate
      for(i = 0; i < 6; i = i + 1) begin: count_reg
          dffe_ref count_reg(.q(count[i]), .d(next_count[i]), .clk(clock), .en(1'b1), .clr(1'b0));
      end
    endgenerate

    // Update
    wire [32:0] shifted;
    assign shifted = {A[31:0], Q[31]};

    wire [31:0] sub_out;
    wire sub_c;
    SUB sub_inst(.out(sub_out), .c32(sub_c), .a(shifted[31:0]), .b(divisor_abs));
    
    wire [31:0] add_sum;
    wire add_c;
    CLA cla_inst(.sum(add_sum), .c32(add_c), .a(shifted[31:0]), .b(divisor_abs), .c0(1'b0));
    
    // New accumulator
    wire [32:0] A_arith;
    assign A_arith = A[32] ? {add_sum[31], add_sum} : {~sub_c, sub_out};

    // New quotient bit
    wire new_bit;
    assign new_bit = ~A_arith[32];

    // Update Q and A
    assign next_Q = ctrl_DIV ? dividend_abs : ((Q << 1) | new_bit);
    assign next_A = ctrl_DIV ? 33'b0 : A_arith;

    // Instantiate registers for Q and A
    generate
      for(i = 0; i < 32; i = i + 1) begin: Q_regs
          dffe_ref Q_reg(.q(Q[i]), .d(next_Q[i]), .clk(clock), .en(1'b1), .clr(1'b0));
      end
    endgenerate
    generate
      for(i = 0; i < 33; i = i + 1) begin: A_regs
          dffe_ref A_reg(.q(A[i]), .d(next_A[i]), .clk(clock), .en(1'b1), .clr(1'b0));
      end
    endgenerate

    assign data_resultRDY = busy & count_is_32;
    
    // Apply sign correction
    wire [31:0] final_quotient, Q_neg;
    CLA negate_Q(.sum(Q_neg), .c32(dummy), .a(~Q), .b(32'b0), .c0(1'b1));
    assign final_quotient = quotient_negative ? (Q_neg) : Q;
    // Make output zero if divide by zero
    assign data_result = data_exception ? 32'b0 : final_quotient;

endmodule
