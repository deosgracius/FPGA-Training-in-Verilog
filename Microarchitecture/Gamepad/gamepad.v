module gamepad(A, B, X, Y, clk, latch, data);
    input A, B, X, Y, clk, latch;
    output reg data;

    reg [3:0] buttonState;

    always @(posedge latch or posedge clk) begin
        if(latch==1) begin
            buttonState <= {A, B, X, Y};
        end else begin
            data <= buttonState[3];
            buttonState <= {buttonState[2:0], 1'b0};
        end
    end
endmodule

