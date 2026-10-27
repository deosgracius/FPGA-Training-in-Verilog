/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Project 2

*/

// 32x32 register file: 32 registers, each 32 bits wide.
//
// Reading: two independent output busses. busA shows the register selected
// by address AA, busB shows the register selected by address BA. Both reads
// are combinational, so a bus follows its address lines right away.
//
// Writing: one register at a time. The value on bus D is stored in the
// register selected by DA on the rising edge of the register load signal RL.
module regFile(D, DA, RL, AA, BA, busA, busB);
    input [31:0] D;         // input data bus
    input [4:0] DA;         // address of the register to load from D
    input RL;               // register load signal, loads on the rising edge
    input [4:0] AA;         // address of the register shown on busA
    input [4:0] BA;         // address of the register shown on busB

    output [31:0] busA;     // output bus A
    output [31:0] busB;     // output bus B

    // the 32 registers, 32 bits each (5 address bits select one of them)
    reg [31:0] registers[0:31];

    // both output busses read their register directly from the array
    assign busA = registers[AA];
    assign busB = registers[BA];

    // load the selected register with D on the rising edge of RL
    always @(posedge RL) begin
        registers[DA] <= D;
    end
endmodule
