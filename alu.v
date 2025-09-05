module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, isGreaterThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, isGreaterThan, overflow;

    // add your code here:
    wire[31:0] ADD_out, SUB_out, AND_out, OR_out, SLL_out, SRA_out;
    wire ADD_ovf, SUB_ovf;
    wire c32_add, c32_sub;

    CLA ADD(
        .a(data_operandA),
        .b(data_operandB),
        .c0(1'b0),
        .sum(ADD_out),
        .c32(c32_add)
    );

    SUB SUBTRACT(
        .a(data_operandA),
        .b(data_operandB),
        .c32(c32_sub),
        .out(SUB_out)
    );

    AND_32 AND_32_out(
        .a(data_operandA),
        .b(data_operandB),
        .out(AND_out)
    );

    OR_32 OR_32_out(
        .a(data_operandA),
        .b(data_operandB),
        .out(OR_out)
    );

    SLL SLL_32_out(
        .a(data_operandA),
        .shamt(ctrl_shiftamt),
        .out_full(SLL_out)
    );

    SRA SRA_32_out(
        .a(data_operandA),
        .shamt(ctrl_shiftamt),
        .out(SRA_out)
    );

    // Information signals

    // isNotEqual
    NOT_0 isNEQ_ctrl(SUB_out, isNotEqual);

    // isLessThan
    wire A_sign, B_sign, Y_sign;
    assign A_sign = data_operandA[31];  // MSB of A
    assign B_sign = data_operandB[31];  // MSB of B
    assign Y_sign = SUB_out[31];        // MSB of A - B (SUB_out)

    // isGreaterThan
    assign isGreaterThan = ~isLessThan & isNotEqual;

    // Mux
    wire[1:0] A_B_signs;
    assign A_B_signs[1] = A_sign;
    assign A_B_signs[0] = B_sign;

    mux_bits_4 isLT_mux(
        .in0(Y_sign), // A[31] == B[31] => Take Y[31] directly
        .in1(1'b0),   // A positive, B negative => A < B is false
        .in2(1'b1),   // A negative, B positive => A < B is true
        .in3(Y_sign), // A[31] == B[31] => Take Y[31] directly
        .select(A_B_signs), // Select based on sign bits
        .out(isLessThan)
    );


    // overflow
    wire data_operandA_31_not, data_operandB_31_not, ADD_out31_not, SUB_out31_not;
    not(data_operandA_31_not, data_operandA[31]);
    not(data_operandB_31_not, data_operandB[31]);
    not(ADD_out31_not, ADD_out[31]);
    not(SUB_out31_not, SUB_out[31]);

    wire ADD_ovf_case1, ADD_ovf_case2;
    and (ADD_ovf_case1, data_operandA_31_not, data_operandB_31_not, ADD_out[31]);  // Overflow: (+) + (+) => (-)
    and (ADD_ovf_case2, data_operandA[31], data_operandB[31], ADD_out31_not);   // Overflow: (-) + (-) => (+)
    or  (ADD_ovf, ADD_ovf_case1, ADD_ovf_case2);  // Final ADD overflow

    wire SUB_ovf_case1, SUB_ovf_case2;
    and (SUB_ovf_case1, data_operandA_31_not, data_operandB[31], SUB_out[31]);  // Overflow: (+) - (-) => (-)
    and (SUB_ovf_case2, data_operandA[31], data_operandB_31_not, SUB_out31_not); // Overflow: (-) - (+) => (+)
    or  (SUB_ovf, SUB_ovf_case1, SUB_ovf_case2);  // Final SUB overflow

    mux_bits OVF_mux(
        .in0(ADD_ovf), 
        .in1(SUB_ovf), 
        .select(ctrl_ALUopcode[0]), 
        .out(overflow)
    ); // Get final overflow


mux_32b MUX (
    .out(data_result),
    .select(ctrl_ALUopcode),
    .in0(ADD_out),
    .in1(SUB_out),
    .in2(AND_out),
    .in3(OR_out),
    .in4(SLL_out),
    .in5(SRA_out),
    .in6(32'b0),
    .in7(32'b0),
    .in8(32'b0),
    .in9(32'b0),
    .in10(32'b0),
    .in11(32'b0),
    .in12(32'b0),
    .in13(32'b0),
    .in14(32'b0),
    .in15(32'b0),
    .in16(32'b0),
    .in17(32'b0),
    .in18(32'b0),
    .in19(32'b0),
    .in20(32'b0),
    .in21(32'b0),
    .in22(32'b0),
    .in23(32'b0),
    .in24(32'b0),
    .in25(32'b0),
    .in26(32'b0),
    .in27(32'b0),
    .in28(32'b0),
    .in29(32'b0),
    .in30(32'b0),
    .in31(32'b0)
); // 32:1 32-bit MUX
 
endmodule