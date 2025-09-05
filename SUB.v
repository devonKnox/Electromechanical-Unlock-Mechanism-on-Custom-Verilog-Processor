module SUB(out, c32, a, b);
    input[31:0] a,b;
    output[31:0] out;
    output c32;
    wire[31:0] b_not, b_negative, one;

    // Negate b
    not(b_not[31], b[31]);
    not(b_not[30], b[30]);
    not(b_not[29], b[29]);
    not(b_not[28], b[28]);
    not(b_not[27], b[27]);
    not(b_not[26], b[26]);
    not(b_not[25], b[25]);
    not(b_not[24], b[24]);
    not(b_not[23], b[23]); 
    not(b_not[22], b[22]);
    not(b_not[21], b[21]);
    not(b_not[20], b[20]);
    not(b_not[19], b[19]);
    not(b_not[18], b[18]);
    not(b_not[17], b[17]);
    not(b_not[16], b[16]);
    not(b_not[15], b[15]);
    not(b_not[14], b[14]); 
    not(b_not[13], b[13]);
    not(b_not[12], b[12]);
    not(b_not[11], b[11]);
    not(b_not[10], b[10]);
    not(b_not[9], b[9]);
    not(b_not[8], b[8]);
    not(b_not[7], b[7]);
    not(b_not[6], b[6]);
    not(b_not[5], b[5]); 
    not(b_not[4], b[4]);
    not(b_not[3], b[3]);
    not(b_not[2], b[2]);
    not(b_not[1], b[1]);
    not(b_not[0], b[0]);

    // Use CLA with A + (-B)
    CLA a_minus_b(out, c32, a, b_not, 1'b1);
endmodule
