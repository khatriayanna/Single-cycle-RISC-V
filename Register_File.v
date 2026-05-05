module Register_File (clk,rst,WE3,WD3,A1,A2,A3,RD1,RD2);

    input clk,rst,WE3;
    input [4:0]A1,A2,A3;
    input [31:0]WD3;
    output [31:0]RD1,RD2;

    reg [31:0] Register [31:0];

    always @ (posedge clk)
    begin
        if(WE3 && A3!=0)
            Register[A3] <= WD3;
    end

    assign RD1 = (A1 == 0) ? 32'd0 : Register[A1];
    assign RD2 = (A2 == 0) ? 32'd0 : Register[A2];
    
    initial begin
        Register[5] = 32'h00000005;
        Register[6] = 32'h00000004;
    end

endmodule