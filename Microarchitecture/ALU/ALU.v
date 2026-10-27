module ALU(busA, busB, X, sel, C);
    input [3:0] busA, busB;
    input sel;

    output reg [3:0] X;
    output reg C;

    always @(busA, busB, sel) begin
        if(sel==0) begin
            {C, X} = busA + busB;
        end else begin
            {C, X} = busA - busB;
        end
    end
endmodule
