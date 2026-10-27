`include "mux.v"

module mux_tb;
    reg A, B, C, D;
    reg [1:0] sel;
    wire X;

    mux UUT(.A(A), .B(B), .C(C), .D(D), .sel(sel), .X(X));

    initial begin
        $dumpfile("mux.vcd");
        $dumpvars(0, mux_tb);

        A=0;
        B=1;
        C=0;
        D=1;
        sel=0;
        #20;

        A=0;
        B=1;
        C=0;
        D=1;
        sel=1;
        #20;

        A=0;
        B=1;
        C=0;
        D=1;
        sel=2;
        #20;

        A=0;
        B=1;
        C=0;
        D=1;
        sel=3;
        #20;        
    end
endmodule