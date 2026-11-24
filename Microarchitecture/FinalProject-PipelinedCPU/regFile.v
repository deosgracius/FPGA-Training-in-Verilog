/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Final Project

*/

// 32x32 register file (Project 2, with a reset added for the final project
// so every register starts at a known value of zero).
//
// Reading: busA shows the register selected by AA, busB the one selected
// by BA. Both reads are combinational.
// Writing: the value on D is stored in the register selected by DA on the
// rising edge of RL. rst is active high and clears all 32 registers.
module regFile(rst, D, DA, RL, AA, BA, busA, busB);
    input rst;              // clears every register
    input [31:0] D;         // input data bus
    input [4:0] DA;         // address of the register to load from D
    input RL;               // register load signal, loads on the rising edge
    input [4:0] AA;         // address of the register shown on busA
    input [4:0] BA;         // address of the register shown on busB

    output [31:0] busA;     // output bus A
    output [31:0] busB;     // output bus B

    reg [31:0] registers[0:31];

    integer index;

    assign busA = registers[AA];
    assign busB = registers[BA];

    always @(posedge RL or posedge rst) begin
        if(rst==1) begin
            for(index=0; index<32; index=index+1) begin
                registers[index] <= 0;
            end
        end else begin
            registers[DA] <= D;
        end
    end
endmodule
