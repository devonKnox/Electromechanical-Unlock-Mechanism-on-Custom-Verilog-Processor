module SRA (out, a, shamt);
    input [31:0] a;
    input [4:0] shamt;
    output [31:0] out;
    wire [31:0] w16, w8, w4, w2;
    
    SR16 SR16_inst(.a(a), .on(shamt[4]), .out_shift(w16));
    SR8  SR8_inst (.a(w16), .on(shamt[3]), .out_shift(w8));
    SR4  SR4_inst (.a(w8),  .on(shamt[2]), .out_shift(w4));
    SR2  SR2_inst (.a(w4),  .on(shamt[1]), .out_shift(w2));
    SR1  SR1_inst (.a(w2),  .on(shamt[0]), .out_shift(out));
endmodule

module SR1(a, on, out_shift);
    input [31:0] a;
    input on;
    output [31:0] out_shift;
    wire [31:0] shifted;
    
    assign shifted[31] = a[31];
    assign shifted[30] = a[31];
    assign shifted[29] = a[30];
    assign shifted[28] = a[29];
    assign shifted[27] = a[28];
    assign shifted[26] = a[27];
    assign shifted[25] = a[26];
    assign shifted[24] = a[25];
    assign shifted[23] = a[24];
    assign shifted[22] = a[23];
    assign shifted[21] = a[22];
    assign shifted[20] = a[21];
    assign shifted[19] = a[20];
    assign shifted[18] = a[19];
    assign shifted[17] = a[18];
    assign shifted[16] = a[17];
    assign shifted[15] = a[16];
    assign shifted[14] = a[15];
    assign shifted[13] = a[14];
    assign shifted[12] = a[13];
    assign shifted[11] = a[12];
    assign shifted[10] = a[11];
    assign shifted[9]  = a[10];
    assign shifted[8]  = a[9];
    assign shifted[7]  = a[8];
    assign shifted[6]  = a[7];
    assign shifted[5]  = a[6];
    assign shifted[4]  = a[5];
    assign shifted[3]  = a[4];
    assign shifted[2]  = a[3];
    assign shifted[1]  = a[2];
    assign shifted[0]  = a[1];
    
    mux_2_32b mux_SR1(.out(out_shift), .select(on), .in0(a), .in1(shifted));
endmodule

module SR2(a, on, out_shift);
    input [31:0] a;
    input on;
    output [31:0] out_shift;
    wire [31:0] shifted;
    
    assign shifted[31] = a[31];
    assign shifted[30] = a[31];
    assign shifted[29] = a[31];
    assign shifted[28] = a[30];
    assign shifted[27] = a[29];
    assign shifted[26] = a[28];
    assign shifted[25] = a[27];
    assign shifted[24] = a[26];
    assign shifted[23] = a[25];
    assign shifted[22] = a[24];
    assign shifted[21] = a[23];
    assign shifted[20] = a[22];
    assign shifted[19] = a[21];
    assign shifted[18] = a[20];
    assign shifted[17] = a[19];
    assign shifted[16] = a[18];
    assign shifted[15] = a[17];
    assign shifted[14] = a[16];
    assign shifted[13] = a[15];
    assign shifted[12] = a[14];
    assign shifted[11] = a[13];
    assign shifted[10] = a[12];
    assign shifted[9]  = a[11];
    assign shifted[8]  = a[10];
    assign shifted[7]  = a[9];
    assign shifted[6]  = a[8];
    assign shifted[5]  = a[7];
    assign shifted[4]  = a[6];
    assign shifted[3]  = a[5];
    assign shifted[2]  = a[4];
    assign shifted[1]  = a[3];
    assign shifted[0]  = a[2];
    
    mux_2_32b mux_SR2(.out(out_shift), .select(on), .in0(a), .in1(shifted));
endmodule

module SR4(a, on, out_shift);
    input [31:0] a;
    input on;
    output [31:0] out_shift;
    wire [31:0] shifted;
    
    assign shifted[31] = a[31];
    assign shifted[30] = a[31];
    assign shifted[29] = a[31];
    assign shifted[28] = a[31];
    assign shifted[27] = a[31];
    assign shifted[26] = a[30];
    assign shifted[25] = a[29];
    assign shifted[24] = a[28];
    assign shifted[23] = a[27];
    assign shifted[22] = a[26];
    assign shifted[21] = a[25];
    assign shifted[20] = a[24];
    assign shifted[19] = a[23];
    assign shifted[18] = a[22];
    assign shifted[17] = a[21];
    assign shifted[16] = a[20];
    assign shifted[15] = a[19];
    assign shifted[14] = a[18];
    assign shifted[13] = a[17];
    assign shifted[12] = a[16];
    assign shifted[11] = a[15];
    assign shifted[10] = a[14];
    assign shifted[9]  = a[13];
    assign shifted[8]  = a[12];
    assign shifted[7]  = a[11];
    assign shifted[6]  = a[10];
    assign shifted[5]  = a[9];
    assign shifted[4]  = a[8];
    assign shifted[3]  = a[7];
    assign shifted[2]  = a[6];
    assign shifted[1]  = a[5];
    assign shifted[0]  = a[4];
    
    mux_2_32b mux_SR4(.out(out_shift), .select(on), .in0(a), .in1(shifted));
endmodule

module SR8(a, on, out_shift);
    input [31:0] a;
    input on;
    output [31:0] out_shift;
    wire [31:0] shifted;
    
    assign shifted[31] = a[31];
    assign shifted[30] = a[31];
    assign shifted[29] = a[31];
    assign shifted[28] = a[31];
    assign shifted[27] = a[31];
    assign shifted[26] = a[31];
    assign shifted[25] = a[31];
    assign shifted[24] = a[31];
    assign shifted[23] = a[31];
    assign shifted[22] = a[30];
    assign shifted[21] = a[29];
    assign shifted[20] = a[28];
    assign shifted[19] = a[27];
    assign shifted[18] = a[26];
    assign shifted[17] = a[25];
    assign shifted[16] = a[24];
    assign shifted[15] = a[23];
    assign shifted[14] = a[22];
    assign shifted[13] = a[21];
    assign shifted[12] = a[20];
    assign shifted[11] = a[19];
    assign shifted[10] = a[18];
    assign shifted[9]  = a[17];
    assign shifted[8]  = a[16];
    assign shifted[7]  = a[15];
    assign shifted[6]  = a[14];
    assign shifted[5]  = a[13];
    assign shifted[4]  = a[12];
    assign shifted[3]  = a[11];
    assign shifted[2]  = a[10];
    assign shifted[1]  = a[9];
    assign shifted[0]  = a[8];
    
    mux_2_32b mux_SR8(.out(out_shift), .select(on), .in0(a), .in1(shifted));
endmodule

module SR16(a, on, out_shift);
    input [31:0] a;
    input on;
    output [31:0] out_shift;
    wire [31:0] shifted;
    
    assign shifted[31] = a[31];
    assign shifted[30] = a[31];
    assign shifted[29] = a[31];
    assign shifted[28] = a[31];
    assign shifted[27] = a[31];
    assign shifted[26] = a[31];
    assign shifted[25] = a[31];
    assign shifted[24] = a[31];
    assign shifted[23] = a[31];
    assign shifted[22] = a[31];
    assign shifted[21] = a[31];
    assign shifted[20] = a[31];
    assign shifted[19] = a[31];
    assign shifted[18] = a[31];
    assign shifted[17] = a[31];
    assign shifted[16] = a[31];
    assign shifted[15] = a[31];
    assign shifted[14] = a[30];
    assign shifted[13] = a[29];
    assign shifted[12] = a[28];
    assign shifted[11] = a[27];
    assign shifted[10] = a[26];
    assign shifted[9]  = a[25];
    assign shifted[8]  = a[24];
    assign shifted[7]  = a[23];
    assign shifted[6]  = a[22];
    assign shifted[5]  = a[21];
    assign shifted[4]  = a[20];
    assign shifted[3]  = a[19];
    assign shifted[2]  = a[18];
    assign shifted[1]  = a[17];
    assign shifted[0]  = a[16];
    
    mux_2_32b mux_SR16(.out(out_shift), .select(on), .in0(a), .in1(shifted));
endmodule
