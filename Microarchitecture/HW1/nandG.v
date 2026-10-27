module nandG(A, B, X);
    input A, B;
    output X;

    assign X = ~(A & B);
endmodule