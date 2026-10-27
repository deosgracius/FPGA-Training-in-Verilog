`include "gamepad.v"

module gamepad_tb;
    reg A, B, X, Y, clk, latch;
    wire data;

    gamepad UUT(.A(A), .B(B), .X(X), .Y(Y), 
                .clk(clk), .latch(latch), .data(data)
                );

    integer index;

    initial begin
        $dumpfile("gamepad.vcd");
        $dumpvars(0, gamepad_tb);

        latch=0;
        clk=0;

        A=0;
        B=1;
        X=0;
        Y=1;
        #20;

        latch=1;
        #20;
        latch=0;
        #20;

        for(index=0; index<4; index=index+1) begin
            clk=1;
            #20;
            clk=0;
            #20;
        end
    end
endmodule