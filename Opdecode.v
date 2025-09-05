module Opdecode(
    input [4:0] opcode,
    output wire isRType,
    output wire isAddi,
    output wire isLw,
    output wire isSw,
    output wire isSetx,
    output wire isJal
);

    assign isRType = (opcode == 5'b00000);
    assign isAddi  = (opcode == 5'b00101);
    assign isLw    = (opcode == 5'b01000);
    assign isSw    = (opcode == 5'b00111);
    assign isSetx  = (opcode == 5'b10101);
    assign isJal   = (opcode == 5'b00011);

endmodule