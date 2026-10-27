module mux(A, B, sel, X);
    input A, B, sel;
    output X;

    assign X = sel==1 ? B : A;
endmodule