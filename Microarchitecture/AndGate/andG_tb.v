`include "andG.v"

module andG_tb;
    reg A, B, C;
    wire Xin;
    wire X;

    integer index;

    andG UUT1(.A(A), .B(B), .X(Xin));
    andG UUT2(.A(Xin), .B(C), .X(X));

    initial begin
        $dumpfile("andG_tb.vcd");
        $dumpvars(0, andG_tb);

        for(index=0; index<8; index=index+1) begin
            A=index[0];
            B=index[1];
            C=index[2];
            #20;
        end
    end
endmodule