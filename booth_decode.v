module booth_decode (
    input [2:0] booth_bits,
    output [2:0] op
);

    wire sel1, sel2, sel3, sel4;
    wire [2:0] op_mux1, op_mux2, op_mux3, op_mux4;

    assign sel1 = (~booth_bits[2] & ~booth_bits[1] &  booth_bits[0])| (~booth_bits[2] & booth_bits[1] & ~booth_bits[0]); // 001 010
    assign sel2 = (~booth_bits[2] &  booth_bits[1] &  booth_bits[0]); // 011
    assign sel3 = (booth_bits[2] & ~booth_bits[1] &  booth_bits[0]) | (booth_bits[2] &  booth_bits[1] & ~booth_bits[0]); // 101 110
    assign sel4 = (booth_bits[2] & ~booth_bits[1] & ~booth_bits[0]); // 100

    assign op_mux1 = sel1 ? 3'b001 : 3'b000;
    assign op_mux2 = sel2 ? 3'b010 : op_mux1;
    assign op_mux3 = sel3 ? 3'b011 : op_mux2;
    assign op_mux4 = sel4 ? 3'b100 : op_mux3;

    assign op = op_mux4;

endmodule
