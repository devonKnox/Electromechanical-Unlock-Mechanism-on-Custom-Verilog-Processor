module DFFtri(Q, oe, out);
    input[31:0] Q;
    input oe;
    output[31:0] out;

    assign out = oe ? Q : 32'bz;
endmodule