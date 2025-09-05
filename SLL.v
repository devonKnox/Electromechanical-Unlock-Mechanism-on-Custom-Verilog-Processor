module SLL (out_full, a, shamt);
    input  [31:0] a;
    input  [4:0]  shamt;
    output [31:0] out_full;
    wire   [31:0] w1, w2, w4, w8, w16;
    wire   [31:0] sl16out, sl8out, sl4out, sl2out, sl1out;

    SL16 SL16_out(.in(a), .out(sl16out));
    mux_2_32b mux16(.out(w16), .select(shamt[4]), .in0(a), .in1(sl16out));
    
    SL8 SL8_out(.in(w16), .out(sl8out));
    mux_2_32b mux8(.out(w8), .select(shamt[3]), .in0(w16), .in1(sl8out));

    SL4 SL4_out(.in(w8), .out(sl4out));
    mux_2_32b mux4(.out(w4), .select(shamt[2]), .in0(w8), .in1(sl4out));

    SL2 SL2_out(.in(w4), .out(sl2out));
    mux_2_32b mux2(.out(w2), .select(shamt[1]), .in0(w4), .in1(sl2out));

    SL1 SL1_out(.in(w2), .out(sl1out));
    mux_2_32b mux1(.out(w1), .select(shamt[0]), .in0(w2), .in1(sl1out));

    assign out_full = w1;
endmodule

module mux_2_32b(out, select, in0, in1);
    input         select;
    input  [31:0] in0, in1;
    output [31:0] out;
    assign out = select ? in1 : in0;
endmodule

module SL1(in, out);
    input  [31:0] in;
    output [31:0] out;
    
    assign out[31] = in[30];
    assign out[30] = in[29];
    assign out[29] = in[28];
    assign out[28] = in[27];
    assign out[27] = in[26];
    assign out[26] = in[25];
    assign out[25] = in[24];
    assign out[24] = in[23];
    assign out[23] = in[22];
    assign out[22] = in[21];
    assign out[21] = in[20];
    assign out[20] = in[19];
    assign out[19] = in[18];
    assign out[18] = in[17];
    assign out[17] = in[16];
    assign out[16] = in[15];
    assign out[15] = in[14];
    assign out[14] = in[13];
    assign out[13] = in[12];
    assign out[12] = in[11];
    assign out[11] = in[10];
    assign out[10] = in[9];
    assign out[9]  = in[8];
    assign out[8]  = in[7];
    assign out[7]  = in[6];
    assign out[6]  = in[5];
    assign out[5]  = in[4];
    assign out[4]  = in[3];
    assign out[3]  = in[2];
    assign out[2]  = in[1];
    assign out[1]  = in[0];
    assign out[0]  = 1'b0;
endmodule

module SL2(in, out);
    input  [31:0] in;
    output [31:0] out;
    wire   [31:0] temp;
    
    SL1 s1(.in(in),   .out(temp));
    SL1 s2(.in(temp), .out(out));
endmodule

module SL4(in, out);
    input  [31:0] in;
    output [31:0] out;
    wire   [31:0] temp;
    
    SL2 s1(.in(in),   .out(temp));
    SL2 s2(.in(temp), .out(out));
endmodule

module SL8(in, out);
    input  [31:0] in;
    output [31:0] out;
    wire   [31:0] temp;
    
    SL4 s1(.in(in),   .out(temp));
    SL4 s2(.in(temp), .out(out));
endmodule

module SL16(in, out);
    input  [31:0] in;
    output [31:0] out;
    wire   [31:0] temp;
    
    SL8 s1(.in(in),   .out(temp));
    SL8 s2(.in(temp), .out(out));
endmodule