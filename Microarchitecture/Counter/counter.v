module counter(latch, X, rst);
    input latch, rst;

    output reg [3:0] X;

    always @(posedge latch) begin
        if(rst==1) begin
            X=0;
        end else begin
            X = X + 1;
        end
    end    
endmodule