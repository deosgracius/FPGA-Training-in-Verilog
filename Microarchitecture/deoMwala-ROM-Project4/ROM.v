/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Project 4

*/

// 32x4 read-only memory.
//
// addr selects one of 32 locations, each 4 bits wide. CS is active low:
// while CS is 0 the selected location is driven on dataOut; while CS is 1
// dataOut reads zero no matter what the address is.
//
// The contents are fixed, randomized values loaded by the reset input, the
// same way the LUT from class loads its table. reset is active high and
// loads the table on its rising edge.

module ROM(reset, CS, addr, dataOut);
    input reset;                // loads the memory contents
    input CS;                   // chip select, active low
    input [4:0] addr;           // address of the location to read
    output [3:0] dataOut;       // data output bus

    reg [3:0] data[0:31];       // the 32 memory locations, 4 bits each

    // dataOut shows the selected location when the chip is selected, 0 otherwise
    assign dataOut = CS==0 ? data[addr] : 4'b0000;

    // reset loads the randomized memory contents
    always @(posedge reset) begin
        data[0] <= 4'hA;
        data[1] <= 4'hD;
        data[2] <= 4'hA;
        data[3] <= 4'h8;
        data[4] <= 4'hC;
        data[5] <= 4'h3;
        data[6] <= 4'hD;
        data[7] <= 4'h6;
        data[8] <= 4'hD;
        data[9] <= 4'h9;
        data[10] <= 4'h0;
        data[11] <= 4'h2;
        data[12] <= 4'h1;
        data[13] <= 4'h2;
        data[14] <= 4'h4;
        data[15] <= 4'h5;
        data[16] <= 4'h7;
        data[17] <= 4'hD;
        data[18] <= 4'h9;
        data[19] <= 4'h8;
        data[20] <= 4'h0;
        data[21] <= 4'h4;
        data[22] <= 4'h3;
        data[23] <= 4'h0;
        data[24] <= 4'h7;
        data[25] <= 4'h8;
        data[26] <= 4'h4;
        data[27] <= 4'h0;
        data[28] <= 4'h9;
        data[29] <= 4'hE;
        data[30] <= 4'hA;
        data[31] <= 4'h6;
    end
endmodule
