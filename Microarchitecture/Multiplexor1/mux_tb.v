`include "mux.v"

module mux_tb;
    reg A, B, sel;
    wire X;

    mux UUT(.A(A), .B(B), .sel(sel), .X(X));

    initial begin
        $dumpfile("mux.vcd");
        $dumpvars(0, mux_tb);

        A=1;
        B=0;
        sel=0;
        #20;

        A=0;
        #20;

        B=1;
        #20;

        sel=1;
        #20;
    end
endmodule