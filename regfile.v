module regfile (
    input clock,
    input ctrl_writeEnable, ctrl_reset,
    input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB,
    input [31:0] data_writeReg,
    //final proj
    input H1in,H2in,H3in,H4in,
    output [31:0] data_readRegA, data_readRegB,
    //final proj
    output magnet
);
    
    wire [31:0] write_enable_signals;
    wire [31:0] reg_out [31:0];
    wire [31:0] write_enables; 

    // Decoder
    decoder1 write_decoder (
        .sel(ctrl_writeReg),
        .out(write_enable_signals)
    );


//final project >

reg_32b register_instance1 (
    .clock(clock),
    .input_enable(1'b1),
    .clear(ctrl_reset),
    .in(H1in),
    .out(reg_out[1])
);

reg_32b register_instance2 (
    .clock(clock),
    .input_enable(1'b1),
    .clear(ctrl_reset),
    .in(H2in),
    .out(reg_out[2])
);

reg_32b register_instance3 (
    .clock(clock),
    .input_enable(1'b1),
    .clear(ctrl_reset),
    .in(H3in),
    .out(reg_out[3])
);

reg_32b register_instance4 (
    .clock(clock),
    .input_enable(1'b1),
    .clear(ctrl_reset),
    .in(H4in),
    .out(reg_out[4])
);
//final Project^



//main loop 
    genvar i;
    generate
        for (i = 5; i < 32; i = i + 1) begin : register_block  // skip 0
            and and_gate(write_enables[i], write_enable_signals[i], ctrl_writeEnable); 
            reg_32b register_instance (
                .clock(clock),
                .input_enable(write_enables[i]),
                .clear(ctrl_reset),
                .in(data_writeReg),
                .out(reg_out[i])
            );
        end
    endgenerate

    // Register 0 always is at 0
    assign reg_out[0] = 32'b0;

    //final proj
    assign magnet = reg_out[10][0];
    

    // I used mux here because high impedance was being weird
    mux5 mux_A (
        .I0(reg_out[0]), .I1(reg_out[1]), .I2(reg_out[2]), .I3(reg_out[3]),
        .I4(reg_out[4]), .I5(reg_out[5]), .I6(reg_out[6]), .I7(reg_out[7]),
        .I8(reg_out[8]), .I9(reg_out[9]), .I10(reg_out[10]), .I11(reg_out[11]),
        .I12(reg_out[12]), .I13(reg_out[13]), .I14(reg_out[14]), .I15(reg_out[15]),
        .I16(reg_out[16]), .I17(reg_out[17]), .I18(reg_out[18]), .I19(reg_out[19]),
        .I20(reg_out[20]), .I21(reg_out[21]), .I22(reg_out[22]), .I23(reg_out[23]),
        .I24(reg_out[24]), .I25(reg_out[25]), .I26(reg_out[26]), .I27(reg_out[27]),
        .I28(reg_out[28]), .I29(reg_out[29]), .I30(reg_out[30]), .I31(reg_out[31]),
        .sel(ctrl_readRegA),
        .Y(data_readRegA)
    );

    //and again for B
    mux5 mux_B (
        .I0(reg_out[0]), .I1(reg_out[1]), .I2(reg_out[2]), .I3(reg_out[3]),
        .I4(reg_out[4]), .I5(reg_out[5]), .I6(reg_out[6]), .I7(reg_out[7]),
        .I8(reg_out[8]), .I9(reg_out[9]), .I10(reg_out[10]), .I11(reg_out[11]),
        .I12(reg_out[12]), .I13(reg_out[13]), .I14(reg_out[14]), .I15(reg_out[15]),
        .I16(reg_out[16]), .I17(reg_out[17]), .I18(reg_out[18]), .I19(reg_out[19]),
        .I20(reg_out[20]), .I21(reg_out[21]), .I22(reg_out[22]), .I23(reg_out[23]),
        .I24(reg_out[24]), .I25(reg_out[25]), .I26(reg_out[26]), .I27(reg_out[27]),
        .I28(reg_out[28]), .I29(reg_out[29]), .I30(reg_out[30]), .I31(reg_out[31]),
        .sel(ctrl_readRegB),
        .Y(data_readRegB)
    );

endmodule