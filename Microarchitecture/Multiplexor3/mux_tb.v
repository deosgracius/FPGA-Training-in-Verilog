`include "mux.v"

module mux_tb;
    reg [3:0] A, B, C, D;
    reg [1:0] sel;
    wire [3:0] X;

    mux UUT(.A(A), .B(B), .C(C), .D(D), .sel(sel), .X(X));

    initial begin
        $dumpfile("mux.vcd");
        $dumpvars(0, mux_tb);
        
        A=4'h5;
        B=4'hA;
        C=4'b1100;
        D=4'd9;
        sel=0;
        #20;

        sel=1;
        #20; 

        sel=2;
        #20;

        sel=3;
        #20; 

        D=4'hA;
        #20;      
    end
endmodule