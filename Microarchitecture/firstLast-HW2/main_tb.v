`include "gamepad.v"
`include "console.v"

module main_tb;
    reg A, B, X, Y;
    reg clock, getState;
    wire data, latch, clk;
    wire outA, outB, outX, outY;

    integer index;

    gamepad GAMEPAD(.A(A), .B(B), .X(X), .Y(Y),
                    .clk(clk), .latch(latch), .data(data)
                    );

    console CONSOLE(.clock(clock), .getState(getState), .data(data),
                    .latch(latch), .clk(clk),
                    .A(outA), .B(outB), .X(outX), .Y(outY)
                    );

    initial begin
        $dumpfile("main_tb.vcd");
        $dumpvars(0, main_tb);

        clock=0;
        getState=0;
        A=0;
        B=0;
        X=0;
        Y=0;
        #20;

        // Try every combination of the 4 buttons
        for(index=0; index<16; index=index+1) begin
            A=index[3];
            B=index[2];
            X=index[1];
            Y=index[0];
            #20;

            getState=1;
            #20;
            getState=0;
            #300;
        end

        $finish();
    end

    always begin
        #10;
        clock=~clock;
    end
endmodule
