module reg_32b (
    input clock, input_enable, clear,
    input [31:0] in,
    output [31:0] out
);


    wire [31:0] stored_value; 


    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : reg_array
            edffe_ref dff (.q(stored_value[i]), .d(in[i]), .clk(clock), .en(input_enable), .clr(clear));
        end
    endgenerate

    assign out = stored_value;


endmodule
                                                                                                                                                                                                                                                                