module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    input  [31:0] data_operandA, data_operandB;
    input         ctrl_MULT, ctrl_DIV, clock;
    output [31:0] data_result;
    output        data_exception, data_resultRDY;

    wire [31:0] data_result_mult, data_result_div;
    wire        on_mult, data_exception_mult;
    wire        on_div, data_exception_div;

    // Latch for selecting operation
    wire mult;
    edffe_ref op_latch (
         .q(mult),
         .d(ctrl_MULT),
         .clk(clock),
         .en(ctrl_MULT || ctrl_DIV),
         .clr(1'b0)
    );

    mult mult_inst (
         .data_operandA(data_operandA), 
         .data_operandB(data_operandB), 
         .ctrl_MULT(ctrl_MULT),
         .clock(clock), 
         .data_result(data_result_mult), 
         .data_exception(data_exception_mult), 
         .data_resultRDY(on_mult)
    );

    // Instantiate divider
    div div_inst (
         .data_operandA(data_operandA), 
         .data_operandB(data_operandB), 
         .ctrl_DIV(ctrl_DIV),
         .clock(clock), 
         .data_result(data_result_div), 
         .data_exception(data_exception_div), 
         .data_resultRDY(on_div)
    );

    // Select outputs based on latched signal
    assign data_result = mult ? data_result_mult : data_result_div;
    assign data_exception = mult ? data_exception_mult : data_exception_div;
    assign data_resultRDY = mult ? on_mult : on_div;

endmodule
