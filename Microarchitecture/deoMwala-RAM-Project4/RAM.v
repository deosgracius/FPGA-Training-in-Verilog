/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Project 4

*/

// 32x4 random access memory with a bidirectional data bus.
//
// addr selects one of 32 locations, each 4 bits wide. All three control
// inputs are active low:

//   CS  chip select: while CS is 1 the data bus is high impedance and
//       nothing is written, whatever OE and WR do.
//   OE  output enable: while CS and OE are both 0 the selected location is
//       driven onto the data bus. Otherwise the bus is high impedance.
//   WR  write: with CS low, the value on the data bus is latched into the
//       selected location on the falling edge of WR.
//
// The contents start as randomized values loaded by reset, like the LUT
// from class, so different locations can be told apart before anything is
// written. reset is active high and loads the table on its rising edge.

// (The assignment only requires reset on the ROM; it is included here too
// because it is the simplest way to give the RAM randomized initial contents.)

module RAM(reset, CS, OE, WR, addr, data);
    input reset;                // loads the initial memory contents
    input CS;                   // chip select, active low
    input OE;                   // output enable, active low
    input WR;                   // write, active low, latches on the falling edge
    input [4:0] addr;           // address of the location to read or write
    inout [3:0] data;           // bidirectional data bus

    reg [3:0] memory[0:31];     // the 32 memory locations, 4 bits each

    // drive the bus only when the chip is selected and output is enabled
    assign data = (CS==0 && OE==1'b0) ? memory[addr] : 4'bzzzz;

    // reset loads the randomized contents; a falling edge on WR with the
    // chip selected stores the value on the data bus
    always @(posedge reset or negedge WR) begin
        if(reset==1) begin
            memory[0] <= 4'hB;
            memory[1] <= 4'hB;
            memory[2] <= 4'hD;
            memory[3] <= 4'h4;
            memory[4] <= 4'h6;
            memory[5] <= 4'hA;
            memory[6] <= 4'hC;
            memory[7] <= 4'hA;
            memory[8] <= 4'h1;
            memory[9] <= 4'hC;
            memory[10] <= 4'h0;
            memory[11] <= 4'h1;
            memory[12] <= 4'h2;
            memory[13] <= 4'h9;
            memory[14] <= 4'h1;
            memory[15] <= 4'h5;
            memory[16] <= 4'h1;
            memory[17] <= 4'h4;
            memory[18] <= 4'hB;
            memory[19] <= 4'hB;
            memory[20] <= 4'hE;
            memory[21] <= 4'hF;
            memory[22] <= 4'hE;
            memory[23] <= 4'hF;
            memory[24] <= 4'h5;
            memory[25] <= 4'h1;
            memory[26] <= 4'h8;
            memory[27] <= 4'hC;
            memory[28] <= 4'h9;
            memory[29] <= 4'hD;
            memory[30] <= 4'h3;
            memory[31] <= 4'h8;
        end else if(CS==0) begin
            memory[addr] <= data;
        end
    end
endmodule
