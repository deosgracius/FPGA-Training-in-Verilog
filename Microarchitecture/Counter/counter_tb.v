`include "counter.v"

module counter_tb;
    reg latch, rst;

    wire [3:0] X;

    counter UUT(.latch(latch), .X(X), .rst(rst));

    initial begin
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, counter_tb);

        rst=0;
        latch=0;
        #20;
        rst=1;
        latch=1;
        #20;
        rst=0;
        latch=0;
        #20;

        latch=0;
        #20;
        latch=1;
        #20;

        latch=0;
        #20;
        latch=1;
        #20;

        latch=0;
        #20;
        latch=1;
        #20;

        latch=0;
        #20;                
    end
endmodule