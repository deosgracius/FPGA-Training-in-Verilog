module LUT(rst, addr, X);
    input rst;
    input [1:0] addr;

    reg [3:0] data[0:3];

    output [3:0] X;

    assign X = data[addr];

    always @(negedge rst) begin
        data[0]<=2;
        data[1]<=5;
        data[2]<=6;
        data[3]<=9;
    end
endmodule
