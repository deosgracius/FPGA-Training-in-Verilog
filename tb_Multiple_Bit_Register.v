`timescale 1ns / 1ps

module tb_M_ff_register;

    reg clk;
    reg rst;
    reg [7:0] d;
    wire [7:0] q;

    // Instantiate DUT
    M_ff_register uut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Dump file for GTKWave
    initial begin
        $dumpfile("register.vcd");
        $dumpvars(0, tb_M_ff_register);
    end

    // Monitor values
    initial begin
        $monitor("Time=%0t clk=%b rst=%b d=%b q=%b",
                  $time, clk, rst, d, q);
    end

    // Test sequence
    initial begin

        rst = 1;
        d   = 8'b10101010;

        #10;

        rst = 0;

        #10;

        d = 8'b11110000;

        #20;

        $finish;
    end

endmodule