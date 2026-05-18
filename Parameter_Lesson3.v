module register #(
    parameter Width = 8 
)(
    input clk, 
    input rst, 
    input [Width-1:0]d,
    output reg [Width-1:0] q   
);
    always @(posedge clk) begin
        if (rst) begin 
            q <=0;
        end 
        else begin
          q <= d;
        end 
    end
endmodule


// This module defines a parameterized register that can be used to create registers of different widths. 
// The `Width` parameter allows us to specify the number of bits for the register, and it defaults to 8.
// Example usage of the register module with different widths


// 8-bit register - uses default
register r8(
    .clk(clk),
    .d(data_in_8),
    .q(data_out_8)
);

// 16-bit register - overrides default
register #(.Width(16)) r16(
    .clk(clk),
    .d(data_in_16),
    .q(data_out_16)
);

// 32-bit register - For CPU
register #(.Width(32)) r32(
    .clk(clk),
    .d(data_in_32),
    .q(data_out_32)
); 


// Multiple Parameters Example: A register with an enable signal
module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16    
)( 
    input clk,
    input rst, 
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout,
    input push,
    input pop,
    output full,
    output empty
);
// FIFO implementation would go here, using WIDTH and DEPTH parameters to define the size of the FIFO buffer.
endmodule

// Use it like this:
// Create a 32-bit wide FIFO with a depth of 64
// This instantiation of the fifo module creates a FIFO with a width of 32 bits and a depth of 64 entries.
// mostly used in CPU design for buffering data between different stages of the pipeline or between different components.

fifo #(.WIDTH(32), .DEPTH(64)) my_fifo(
    .clk(clk),
    .rst(rst),
    .din(data_in),
    .dout(data_out),
    .push(push_signal),
    .pop(pop_signal),
    .full(full_signal),
    .empty(empty_signal)
);

