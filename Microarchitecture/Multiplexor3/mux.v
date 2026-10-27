module mux(A, B, C, D, sel, X);
    input [3:0] A, B, C, D;
    input [1:0] sel;
    output reg [3:0] X;

    always @(A, B, C, D, sel) begin
        if(sel==0) begin
            X=A;
        end else if(sel==1) begin
            X=B;
        end else if(sel==2) begin
            X=C;
        end else if(sel==3) begin
            X=D;
        end        
    end
endmodule