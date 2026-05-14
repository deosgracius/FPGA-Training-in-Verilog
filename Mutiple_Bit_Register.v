module M_ff_register(
    input clk,
    input rst,
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (rst) begin
        q <= 8'b0; // Reset the register to 0
        end else begin
        q <= d; // Load the input data into the register on the rising edge of the clock
        end
    end 
endmodule