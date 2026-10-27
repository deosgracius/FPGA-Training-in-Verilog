`include "ALU.v"

module ALU_tb;
    reg [3:0] busA, busB;
    reg sel;

    wire [3:0] X;
    wire C;

    ALU UUT(.busA(busA), .busB(busB), .X(X), .sel(sel), .C(C));

    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALU_tb);

        busA=15;
        busB=1;
        sel=0;
        #20;

        sel=1;
        #20;
    end
endmodule