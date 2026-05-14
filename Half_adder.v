`timescale 1ns / 1ps

module Half_adder(
    input f,
    input g,
    output c,
    output s
);

    // sum and carry logic
    assign s = f ^ g;
    assign c = f & g;

endmodule