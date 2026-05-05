module Control_Unit_Top(
    Op, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch,
    funct3, funct7, ALUControl,
    done   // 🔴 NEW INPUT
);

    input [6:0] Op, funct7;
    input [2:0] funct3;
    input done;   // 🔴 from accelerator

    output RegWrite, ALUSrc, MemWrite, Branch;
    output [1:0] ResultSrc;
    output [1:0] ImmSrc;
    output [2:0] ALUControl;

    wire [1:0] ALUOp;
    wire RegWrite_d, MemWrite_d, ALUSrc_d;
    wire [1:0] ResultSrc_d;

    // ===============================
    // MAIN DECODER
    // ===============================
    Main_Decoder Main_Decoder(
        .Op(Op),
        .RegWrite(RegWrite_d),
        .ImmSrc(ImmSrc),
        .MemWrite(MemWrite_d),
        .ResultSrc(ResultSrc_d),
        .Branch(Branch),
        .ALUSrc(ALUSrc_d),
        .ALUOp(ALUOp)
    );

    // ===============================
    // ALU DECODER
    // ===============================
    ALU_Decoder ALU_Decoder(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    // ===============================
    // ACC DETECTION (for start only)
    // ===============================
    wire is_acc;

    assign is_acc = (Op == 7'b0110011) &&
                    (funct7 == 7'b0000001);

    // ===============================
    // FINAL CONTROL (DONE-ALIGNED)
    // ===============================

    // Write ONLY when accelerator is done
    assign RegWrite = done ? 1'b1 : RegWrite_d;

    // Never write memory for accelerator
    assign MemWrite = done ? 1'b0 : MemWrite_d;

    // ALU not used for ACC
    assign ALUSrc = done ? 1'b0 : ALUSrc_d;

    // Select accelerator result ONLY at done
    assign ResultSrc = done ? 2'b10 : ResultSrc_d;

endmodule