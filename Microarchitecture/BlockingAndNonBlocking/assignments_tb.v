`timescale 1ns / 1ps
`include "assignments.v"

module assignments_tb;
    reg clk;
    wire [3:0] X;

    assignments2 UUT(.clk(clk), .X(X));

    initial begin
        $dumpfile("assignments.vcd");
        $dumpvars(0, assignments_tb);
        
        clk=0;
        #200;

        $finish();                                                              
    end

    always begin
        #1;
        clk=~clk;
        #20;
    end
endmodule