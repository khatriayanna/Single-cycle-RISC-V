module Main_Decoder(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp);
    input [6:0]Op;
    output RegWrite,ALUSrc,MemWrite,Branch;
    output [1:0] ResultSrc;
    output [1:0]ImmSrc,ALUOp;

    assign RegWrite = (Op == 7'b0000011 ||   // load
                   Op == 7'b0110011 ||   // R-type
                   Op == 7'b0010011)     // ⭐ I-type (addi)
                  ? 1'b1 : 1'b0;
    assign ALUSrc = (Op == 7'b0000011 ||   // load
                 Op == 7'b0010011 ||   // I-type (addi)
                 Op == 7'b0100011)     // ⭐ STORE (sw)
                ? 1'b1 : 1'b0;
    assign MemWrite = (Op == 7'b0100011) ? 1'b1 : 1'b0;
    assign ResultSrc = (Op == 7'b0000011) ? 2'b01 :  // lw
                   2'b00;                        // ALU
    assign Branch   = (Op == 7'b1100011) ? 1'b1 : 1'b0;
    assign ImmSrc =
    (Op == 7'b0100011) ? 2'b01 :   // S-type (store)
    (Op == 7'b1100011) ? 2'b10 :   // B-type (branch)
    2'b00;                         // I-type / default

assign ALUOp =
    (Op == 7'b0110011) ? 2'b10 :   // R-type
    (Op == 7'b1100011) ? 2'b01 :   // Branch (SUB)
    2'b00;                         // Load/Store (ADD)

endmodule