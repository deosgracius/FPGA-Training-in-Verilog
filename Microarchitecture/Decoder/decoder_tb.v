`include "decoder.v"

module decoder_tb;
    reg [1:0] in;
    wire W, X, Y, Z;

    decoder UUT(.in(in), .W(W), .X(X), .Y(Y), .Z(Z));

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_tb);

        in=0;
        #20;

        in=1;
        #20;

        in=2;
        #20;

        in=3;
        #20;
    end

endmodule