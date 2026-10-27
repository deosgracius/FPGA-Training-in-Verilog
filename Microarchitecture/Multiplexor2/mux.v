module mux(A, B, C, D, sel, X);
    input A;
    input B;
    input C;
    input D;
    input [1:0] sel;
    output reg X;

    always @(A, B, C, D, sel) begin
        case(sel)
            0: X=A;
            1: X=B;
            2: X=C;
            3: X=D;
        endcase
    end
endmodule