module comparator_32bit(
    input  [31:0] a,
    input  [31:0] b,
    output        equal
);
    wire [31:0] diff;
    assign diff = a ^ b;
    assign equal = ~(|diff);
endmodule
