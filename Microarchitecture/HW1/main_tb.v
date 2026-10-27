`include "andG.v"
`include "nandG.v"
`include "norG.v"

module main_tb;
    reg A, B, C;
    wire X, norOut, nandOut;

    andG ANDG(.A(nandOut), .B(norOut), .C(C), .X(X));
    nandG NANDG(.A(A), .B(B), .X(nandOut));
    norG NORG(.A(A), .B(B), .X(norOut));

    initial begin
        $dumpfile("main_tb.vcd");
        $dumpvars(0, main_tb);

        A=0;
        B=0;
        C=0;
        #20;

        A=0;
        B=0;
        C=1;
        #20;

        A=0;
        B=1;
        C=0;
        #20;

        A=0;
        B=1;
        C=1;
        #20;

        A=1;
        B=0;
        C=0;
        #20;

        A=1;
        B=0;
        C=1;
        #20;

        A=1;
        B=1;
        C=0;
        #20;

        A=1;
        B=1;
        C=1;
        #20;

    end

endmodule