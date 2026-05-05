module Accelerator(clk, rst, A, B, start, result, done);

input clk, rst, start;
input [31:0] A, B;
output reg [31:0] result;
output reg done;

reg start_d;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        result <= 0;
        done <= 0;
        start_d <= 0;
    end 
    else begin
        start_d <= start;
        done <= 0;

        // compute ONE cycle AFTER start
        if (start_d) begin
            result <= A * B;
            done <= 1;
        end
    end
end

endmodule