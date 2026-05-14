module mux(
    input  sel,
    input  a,
    input  b,
    output reg y
);

    always @(*) begin
        if (sel == 1'b0)
            y = b;
        else
            y = a;
    end

endmodule



