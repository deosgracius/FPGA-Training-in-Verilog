// Blocking Assignments
module assignments(clk, X);
    input clk;
    output reg [3:0] X;

    reg [3:0] A, B, C, D;

    always @(posedge clk) begin
        A=1;
        B=2;
        C=A+B;
        D=C+1; 
        X=D;   
    end
endmodule

// Non-blocking Assignments
module assignments2(clk, X);
    input clk;
    output reg [3:0] X;

    reg [3:0] A, B, C, D;

    always @(posedge clk) begin
        A<=1;
        B<=2;
        C<=A+B;
        D<=C+1; 
        X<=D;   
    end
endmodule
