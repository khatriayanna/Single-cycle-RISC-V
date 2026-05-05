module Single_Cycle_Top_Tb ();

    reg clk;
    reg rst;

    Single_Cycle_Top uut (
        .clk(clk),
        .rst(rst)
    );

    // Dump waves
    initial begin
        $dumpfile("Single_Cycle.vcd");
        $dumpvars(0, Single_Cycle_Top_Tb);
    end

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset logic (ONLY ONE BLOCK)
    initial begin
        rst = 1;      // assert reset
        #50;
        rst = 0;      // release reset
    end

    // Simulation control
    initial begin
        #500;
        $finish;
    end

endmodule