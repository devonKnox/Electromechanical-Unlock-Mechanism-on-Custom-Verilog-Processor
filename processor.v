module processor(
    // Control signals
    clk_100mhz,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clk_100mhz, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    wire flush, decodeJr, decodeBex, multdivInProgress, multdivComplete;
    assign multdivInProgress = 1'b0;
    assign multdivComplete = 1'b0;

    //still not sure which stall i need to be using, right now i stall too much 
    //wire stall = executeLw && (((FD_out[21:17] == DX_out[26:22]) & (FD_out[21:17] != 5'b0) & (decodeRType | decodeAddi | decodeLw | decodeSw | decodeJr)) ||(FD_out[21:17] == DX_out[16:12])& (FD_out[21:17] != 5'b0) & (decodeRType | decodeAddi | decodeLw | decodeSw | decodeJr)|| ((FD_out[16:12] == DX_out[26:22]) &(FD_out[16:12] != 5'b0))); // on Lw Ex Stal
    wire stall = executeLw & (FD_out[31:0] != 0) & (!fetchLw || decodeSw) ; //less fast but lowkey works
    //wire stall = executeLw && (((FD_out[21:17] == DX_out[26:22])& (FD_out[21:17] != 5'b0) & (decodeRType | decodeAddi | decodeLw | decodeSw | decodeJr)) || ((FD_out[16:12] == DX_out[26:22]) && !decodeSw & (FD_out[21:17] != 5'b0) & (decodeRType | decodeAddi | decodeLw | decodeSw | decodeJr)));

    // ================FETCH STAGE=================== //

    // Opcode matching
    wire fetchJump = (q_imem[31:27] == 5'b00001);
    wire fetchJal  = (q_imem[31:27] == 5'b00011);
    wire fetchJr   = (q_imem[31:27] == 5'b00100);
    wire fetchLw   = (q_imem[31:27] == 5'b01000);

    wire[31:0] jumpAddress = decodeJr ? data_readRegB : q_imem[26:0]; 
    wire[31:0] bexData = executeSetx ? DX_out[26:0] : (memorySetx ? XM_out[26:0] : (writeSetx ? MW_out[26:0] : data_readRegB)); 

    wire [31:0] correctAddress =  jumpAddress;
    wire overflowPC, ovfBranchPC, isJump;
    wire [31:0] PC, PCplus, branchPC;

    CLA PC_adder( .a(address_imem), .b(32'b0), .c0(1'b1), .sum(PCplus), .c32(overflowPC)); //increment PC by 1
    wire [31:0] signExtendedDXOut = {{15{DX_out[16]}}, DX_out[16:0]};

    CLA PC_branch_adder(.a(DX_out[63:32]), .b(signExtendedDXOut), .c0(1'b1), .sum(branchPC), .c32(ovfBranchPC)); //in the case of branch, PC= PC+1+DXout
    assign PC = flush ? branchPC : PCplus; //is there a branch? if not then PC just gets incremented by 1
    assign isJump = (fetchJump | fetchJal | decodeJr | (decodeBex && (|bexData))); 
    wire rwHazard = fetchJr && ((q_imem[26:22] == FD_out[26:22] || decodeJal) || (q_imem[26:22] == DX_out[26:22] || executeJal) || (q_imem[26:22] == XM_out[26:22] )); //detect rw hazard
    edffe_ref PCflop[31:0](address_imem, isJump ? correctAddress : PC, !clk_100mhz, !stall &  !rwHazard, reset); //keep track of PC

    wire [31:0] newJal,checkFetchJal;
    assign newJal[31:27] = 5'b00011; 
    assign newJal [26:0] = PC; 

    //pipeline
    wire [63:0] FD_in, FD_out;
    assign FD_in[63:32] = rwHazard ? 32'b0 : address_imem;
    assign FD_in[31:0] = rwHazard ? 32'b0 :(q_imem);
    edffe_ref FD[63:0](FD_out, (decodeJr | flush ) ? 64'b0 : FD_in, !clk_100mhz, !stall, reset);

     // ================DECODE STAGE=================== //

    wire decodeRType, decodeAddi, decodeLw, decodeSw, decodeJal;
    Opdecode decodeDecoder(
        .opcode(FD_out[31:27]), 
        .isRType(decodeRType), 
        .isAddi(decodeAddi), 
        .isLw(decodeLw), 
        .isSw(decodeSw), 
        .isSetx(),  // Not nec
        .isJal(decodeJal)    // Not nec
    );
    assign decodeJr  = (FD_out[31:27] == 5'b00100);
    assign decodeBex  = (FD_out[31:27] == 5'b10110);

    assign ctrl_readRegA = FD_out[21:17]; 
    assign ctrl_readRegB = decodeBex ? 5'b11110 : (decodeRType ? FD_out[16:12] : FD_out[26:22]); //if bex, we are interested in $r30

    //pipeline
    wire [127:0] DX_in, DX_out;
    assign DX_in[127:96] = stall ? 32'b0 : data_readRegA; 
    assign DX_in[95:64]  = stall ? 32'b0 : data_readRegB; 
    assign DX_in[63:32]  = stall ? 32'b0 : FD_out[63:32]; 
    assign DX_in[31:0]   = stall ? 32'b0 : FD_out[31:0]; 
    edffe_ref DX[127:0](DX_out, flush ? 128'b0 : DX_in, !clk_100mhz, !multdivInProgress || multdivComplete, reset);

     // ================EXECUTE STAGE=================== //

    wire executeRType  = (DX_out[31:27] == 5'b00000);
    wire executeAddi   = (DX_out[31:27] == 5'b00101);
    wire executeLw     = (DX_out[31:27] == 5'b01000);
    wire executeSw     = (DX_out[31:27] == 5'b00111);
    wire executeJal    = (DX_out[31:27] == 5'b00011);
    wire executeBne    = (DX_out[31:27] == 5'b00010);
    wire executeBlt    = (DX_out[31:27] == 5'b00110);
    wire executeSetx   = (DX_out[31:27] == 5'b10101);

    // ALU Bypassing
    wire XMRd = memoryRType || memoryAddi || memoryLw || memorySetx;
    wire DXRs = executeRType || executeAddi || executeLw || executeSw || executeBne || executeBlt;
    wire MWRd = writeRType || writeAddi || writeLw || writeSetx;

    // Input A bypass
    wire ALUNE, ALUGT, ALUOverflow,multdivOverflow;

    wire [4:0] rs,rd;
    assign rs = DX_out[21:17];
    assign rd = DX_out[26:22];

    wire WXBypassA = (MWRd && DXRs && (MW_out[26:22] ==DX_out[21:17]) && !(MW_out[26:22]==5'b0)) || (writeJal && (rs == 5'b11111));
    wire MXBypassA = (XMRd && DXRs && (XM_out[26:22]== DX_out[21:17]) && !(XM_out[26:22]==5'b0)) || (memoryJal && (rs == 5'b11111));
    wire [31:0] ALUOperandA, ALUOperandB, ALUOut, ALUOperandBEx,correctALUOperandB,signedImmediate,multdivOut,correctALUOperandA;
    assign ALUOperandA = (MXBypassA ? XM_out[95:64] : (WXBypassA ? data_writeReg : DX_out[127:96]));
    assign correctALUOperandA = memoryJal && ((rs==5'b11111) || executeBne & rd==5'b11111)  ? (MW_in[26:0]) : ALUOperandA;

    // In B bypas
    wire[4:0] operandBReg = (executeLw || executeSw || executeBne || executeBlt) ? DX_out[26:22] : DX_out[16:12];

    wire WXBypassB = (MWRd && (executeRType || executeLw || executeSw || executeBlt || executeBne) && (MW_out[26:22] == operandBReg) && (|MW_out[26:22])) || (writeJal && (operandBReg == 5'b11111));
    wire MXBypassB = (XMRd && (executeRType || executeLw || executeSw || executeBlt || executeBne) && (XM_out[26:22] == operandBReg) && (|XM_out[26:22])) || (memoryJal && (operandBReg == 5'b11111));

    assign ALUOperandB = MXBypassB ? (XM_out[95:64]):(WXBypassB ? (data_writeReg):(DX_out[95:64]));
    assign ALUOperandBEx = exOut && (DX_out[16:12] == 5'b11110) ? statusRegDataEx : ALUOperandB; //exception bypass

    wire [4:0] ALUOpcode = executeRType ? DX_out[6:2]: 5'b00000; //just set ALU to add when all we care about is comparisons
    assign signedImmediate = {{15{DX_out[16]}}, DX_out[16:0]};
    assign correctALUOperandB[31:0] = (executeBlt & memoryLw ) ? q_dmem :( executeLw | executeSw | executeAddi ) ? signedImmediate : ALUOperandBEx; //fix later
    wire ALULT;
    alu alu(correctALUOperandA, correctALUOperandB, ALUOpcode , DX_out[11:7], ALUOut, ALUNE, ALULT, ALUGT, ALUOverflow);
    assign flush = ((executeBne && ALUNE) || (executeBlt && !ALUGT && ALUNE)); //if the branch is actually taken we flush

    // Multdiv
    //wire ctrlMULT = (ALUOpcode == 5'b00110) && !multdivInProgress && executeRType;
    //wire ctrlDIV = (ALUOpcode == 5'b00111) && !multdivInProgress && executeRType;
    //edffe_ref multdivLatch(multdivInProgress, ctrlMULT | ctrlDIV, clk_100mhz, ctrlMULT | ctrlDIV | multdivComplete, reset);
    //multdiv multdivModule(ALUOperandA, ALUOperandB, ctrlMULT, ctrlDIV, clk_100mhz, multdivOut, multdivOverflow, multdivComplete);
    //wire [31:0] executeOut = (multdivComplete && multdivInProgress) ? multdivOut : ALUOut;
    wire [31:0] executeOut = ALUOut;
    wire ctrlMULT, ctrlDIV;
    assign ctrlMULT = 1'b0;
    assign ctrlDIV = 1'b0;
    assign multdivOverflow = 1'b0;


    wire [4:0] statusRegDataEx;
    assign statusRegDataEx = ((XM_out[6:2] == 5'b00000) && executeRType) ? 5'b00001 :(executeAddi) ? 5'b00010 :((XM_out[6:2] == 5'b00001) && executeRType) ? 5'b00011 :(ctrlMULT) ? 5'b00100 :(ctrlDIV) ? 5'b00101 :5'b00000;

    // X/M Pipeline 
    wire [127:0] XM_in, XM_out;
    assign XM_in[127:96] = DX_out[63:32];
    assign XM_in[95:64] = executeOut;
    assign XM_in[63:32] = ALUOperandB;
    assign XM_in[31:0] = DX_out[31:0];
    edffe_ref XM[127:0](XM_out, XM_in, !clk_100mhz, !multdivInProgress || multdivComplete, reset);

    ////Exceptions
    wire exIn,exOut;
    assign exIn = (!(ALUOpcode == 5'b00100 || ALUOpcode == 5'b00101)  && (( multdivComplete && multdivInProgress && multdivOverflow) || (ALUOverflow && !multdivInProgress && !(ALUOpcode == 5'b00110 || ALUOpcode == 5'b00111) )));
    edffe_ref XMEX(exOut,exIn,!clk_100mhz,!multdivInProgress || multdivComplete,reset);

     // ================MEMORY STAGE=================== //
    wire memoryRType, memoryAddi, memoryLw, memorySw, memorySetx, memoryJal,exOut2;
    Opdecode memoryDecoder(
        .opcode(XM_out[31:27]), 
        .isRType(memoryRType), 
        .isAddi(memoryAddi), 
        .isLw(memoryLw), 
        .isSw(memorySw), 
        .isSetx(memorySetx), 
        .isJal(memoryJal)
    );
    assign wren = (memorySw == 1'b1);

    //WM bypass
    wire WMBypass = writeLw && memorySw &&  (MW_out[26:22] == XM_out[26:22]) && !(MW_out[26:22]==5'b0);
    assign data = WMBypass || (ctrl_writeReg == 5'b11111) ? data_writeReg : XM_out[63:32]; //jal to a sw
    assign address_dmem = XM_out[95:64];

    //pipeline 
    wire [127:0] MW_in, MW_out;
    assign MW_in[127:96] = XM_out[127:96];
    assign MW_in[95:64] = XM_out[95:64];
    assign MW_in[63:32] = q_dmem;
    assign MW_in[31:0] = XM_out[31:0];
    edffe_ref MW[127:0](MW_out, MW_in, !clk_100mhz, 1'b1, reset);
    edffe_ref MWEX[127:0](exOut2, exOut, !clk_100mhz, 1'b1, reset);

     // ================WRITEBACK STAGE=================== //
    wire writeRType, writeAddi, writeJal, writeSetx, writeLw;
    Opdecode writeDecoder(
        .opcode(MW_out[31:27]), 
        .isRType(writeRType), 
        .isAddi(writeAddi), 
        .isLw(writeLw), 
        .isSw(),        
        .isSetx(writeSetx), 
        .isJal(writeJal)
    );
    assign ctrl_writeEnable = ( writeRType | writeAddi | writeJal | writeSetx | writeLw );
    assign ctrl_writeReg = (writeSetx || exOut2) ? 5'b11110 : (writeJal ? 5'b11111 : MW_out[26:22]); //30 for error, 31 for jal, otherwise just stick to the instruction

    wire writeMult = (MW_out[6:2] == 5'b00110) && (writeRType);
    wire writeDiv = (MW_out[6:2] == 5'b00111) && (writeRType);

    //ERIC
    wire [4:0] statusRegData;
    assign statusRegData = ((MW_out[6:2] == 5'b00000) && writeRType) ? 5'b00001 :(writeAddi) ? 5'b00010 :((MW_out[6:2] == 5'b00001) && writeRType) ? 5'b00011 :(writeMult) ? 5'b00100 :(writeDiv) ? 5'b00101 :5'b00000;
    wire [31:0] data_writeReg1;

    wire B,C,D;
    assign B = writeRType | writeAddi | writeJal;
    assign C = (writeRType | writeAddi);
    assign D = writeSetx;
    assign data_writeReg1 = !B&D | B&!C ? MW_out[26:0] : !B&!D ? MW_out[63:32] :MW_out[95:64]; //i had to play with this logic alot
    assign data_writeReg = exOut2 ? statusRegData : data_writeReg1; //if exception, write the exception code
endmodule