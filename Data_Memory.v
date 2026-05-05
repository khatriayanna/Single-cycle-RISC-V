module Data_Memory(clk, rst, WE, WD, A, RD);

    input clk, rst, WE;
    input [31:0] A, WD;
    output reg [31:0] RD;

    reg [31:0] mem [0:1023];
    reg [31:0] A_reg, WD_reg;
    reg WE_reg;
    
    reg [31:0] A_reg2, WD_reg2;
    reg WE_reg2;

    // Accelerator registers
    reg [31:0] acc_A, acc_B;
    reg start;
    wire [31:0] acc_result;
    wire done;

    integer i;

    // Instantiate accelerator
    Accelerator accel(
        .clk(clk),
        .rst(rst),
        .A(acc_A),
        .B(acc_B),
        .start(start),
        .result(acc_result),
        .done(done)
    );
    
    always @(posedge clk) begin
        A_reg  <= A;
        WD_reg <= WD;
        WE_reg <= WE;
    
        A_reg2  <= A_reg;
        WD_reg2 <= WD_reg;
        WE_reg2 <= WE_reg;
    end

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 1024; i = i + 1)
                mem[i] <= 32'd0;

            acc_A <= 0;
            acc_B <= 0;
            start <= 0;
        end
        else if (WE_reg2) begin
            case (A_reg2[11:2])
                64: acc_A <= WD_reg2;
                65: acc_B <= WD_reg2;
                66: start <= WD_reg2[0];
                default: mem[A_reg2[11:2]] <= WD_reg2;
            endcase
        end
    end

    always @(*) begin
        case (A[11:2])

            67: RD = acc_result;  // 0x10C

            default:
                RD = mem[A[11:2]];

        endcase
    end

endmodule