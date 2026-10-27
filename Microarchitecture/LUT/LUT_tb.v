`include "LUT.v"

module LUT_tb;
    reg [1:0] addr;
    reg rst;

    wire [3:0] X;

    LUT UUTanything(.addr(addr), .X(X), .rst(rst));

    initial begin
        $dumpfile("LUT.vcd");
        $dumpvars(0, LUT_tb);

        rst=0;
        addr=0;
        #20;
        rst=1;
        #20;
        rst=0;
        #20;

        addr=1;
        #20;

        addr=2;
        #20;

        addr=3;
        #20;
    end
endmodule