`timescale 1ns / 1ps

module tb_half_adder;

    // inputs (driven by testbench)
    reg f, g;

    // outputs (observed)
    wire c, s;

    // Instantiate DUT (Device Under Test)
    Half_adder uut (
        .f(f),
        .g(g),
        .c(c),
        .s(s)
    );

    initial begin
        $display("f g | s c");
        $display("----------");

        f = 0; g = 0; #10;
        $display("%b %b | %b %b", f, g, s, c);

        f = 0; g = 1; #10;
        $display("%b %b | %b %b", f, g, s, c);

        f = 1; g = 0; #10;
        $display("%b %b | %b %b", f, g, s, c);

        f = 1; g = 1; #10;
        $display("%b %b | %b %b", f, g, s, c);

        $finish;
    end

endmodule