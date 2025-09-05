module booth_counter(
    input clk,
    output [3:0] count,
    output done
);

    wire [3:0] T_inputs;
    assign T_inputs[0] = 1'b1;
    assign T_inputs[1] = &count[0];
    assign T_inputs[2] = &count[1:0];
    assign T_inputs[3] = &count[2:0];

    genvar i;

    generate
        for(i = 0; i < 4; i = i + 1) begin : tff
            TFF tff_inst(
                .T(T_inputs[i]),
                .clk(clk),
                .Q(count[i])
            );
        end
    endgenerate

    assign done = &count;

endmodule
