module Single_Cycle_Top(clk,rst,debug_out);

    input clk,rst;
    output [31:0] debug_out;

    wire [31:0] PC_Top,RD_Instr,RD1_Top,Imm_Ext_Top,ALUResult,ReadData,PCPlus4,RD2_Top,SrcB,Result;
    wire RegWrite,MemWrite,ALUSrc;
    wire [1:0] ResultSrc;
    wire [1:0]ImmSrc;
    wire [2:0]ALUControl_Top;

    // ACCELERATOR WIRES
    wire [31:0] acc_result;
    wire done;
    reg [31:0] A_reg, B_reg;
    reg [4:0] rd_reg;

    // =========================================
    // 🔴 START GENERATION (FIXED)
    // =========================================

    reg [31:0] instr_d;

    always @(posedge clk) begin
        instr_d <= RD_Instr;
    end

    wire is_acc = (RD_Instr[6:0] == 7'b0110011) &&
              (RD_Instr[31:25] == 7'b0000001);
    wire is_acc_d = (instr_d[6:0] == 7'b0110011) &&
                (instr_d[31:25] == 7'b0000001);

    wire start_pulse = is_acc & ~is_acc_d;
    
    reg start_d;

    always @(posedge clk) begin
        start_d <= start_pulse;
    end

    // =========================================
    // 🔴 OPERAND CAPTURE (SYNC WITH START)
    // =========================================

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A_reg <= 0;
            B_reg <= 0;
            rd_reg <= 0;            // 🔴 ADD
        end 
        else if (start_pulse) begin
            A_reg <= RD1_Top;
            B_reg <= RD2_Top;
            rd_reg <= RD_Instr[11:7];  // 🔴 ADD
        end
    end

    // =========================================
    // CORE
    // =========================================

    PC_Module PC(
        .clk(clk),
        .rst(rst),
        .PC(PC_Top),
        .PC_Next(PCPlus4)
    );

    PC_Adder PC_Adder(
        .a(PC_Top),
        .b(32'd4),
        .c(PCPlus4)
    );
    
    Instruction_Memory Instruction_Memory(
        .rst(rst),
        .A(PC_Top),
        .RD(RD_Instr)
    );

    Register_File Register_File(
        .clk(clk),
        .rst(rst),
        .WE3(RegWrite),
        .WD3(Result),
        .A1(RD_Instr[19:15]),
        .A2(RD_Instr[24:20]),
        .A3(done ? rd_reg : RD_Instr[11:7]),
        .RD1(RD1_Top),
        .RD2(RD2_Top)
    );

    Sign_Extend Sign_Extend(
        .In(RD_Instr),
        .ImmSrc(ImmSrc),
        .Imm_Ext(Imm_Ext_Top)
    );

    Mux Mux_Register_to_ALU(
        .a(RD2_Top),
        .b(Imm_Ext_Top),
        .s(ALUSrc),
        .c(SrcB)
    );

    ALU ALU(
        .A(RD1_Top),
        .B(SrcB),
        .Result(ALUResult),
        .ALUControl(ALUControl_Top),
        .OverFlow(),
        .Carry(),
        .Zero(),
        .Negative()
    );

    // 🔴 REMOVED start FROM CONTROL UNIT
    Control_Unit_Top Control_Unit_Top(
        .Op(RD_Instr[6:0]),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(),
        .funct3(RD_Instr[14:12]),
        .funct7(RD_Instr[31:25]),
        .ALUControl(ALUControl_Top),
        .done(done)
    );

    // =========================================
    // 🔴 ACCELERATOR (TRIGGERED BY PULSE)
    // =========================================

    Accelerator Accelerator(
        .clk(clk),
        .rst(rst),
        .A(A_reg),
        .B(B_reg),
        .start(start_d),
        .result(acc_result),
        .done(done)
    );

    Data_Memory Data_Memory(
        .clk(clk),
        .rst(rst),
        .WE(MemWrite),
        .WD(RD2_Top),
        .A(ALUResult),
        .RD(ReadData)
    );

    assign Result = (ResultSrc == 2'b00) ? ALUResult :
                (ResultSrc == 2'b01) ? ReadData  :
                                       acc_result;
    
    assign debug_out = ALUResult;

endmodule