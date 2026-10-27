/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Project 2

*/

`include "regFile.v"

// Testbench for the 32x32 register file. The results are checked in the
// waveform (regFile_tb.vcd).
//
// Test 1: write a different value into every register, 0 to 31.
//         Register n is loaded with the value n+1, so register 0 does not
//         hold 0 and every register can be told apart in the waveform.
// Test 2: read every register on busA and on busB. busA counts up from
//         register 0 while busB counts down from register 31, so the two
//         busses read different registers at the same time. busA must show
//         AA+1 and busB must show BA+1.
// Test 3: overwrite register 17 with a new value, then read every register
//         on both busses. Only register 17 must have changed.
// Test 4: change D and DA while RL stays low. Registers 3 and 9 are then
//         read on busA and busB and must still hold 4 and 10.
module regFile_tb;
    reg [31:0] D;           // data to write
    reg [4:0] DA;           // write address
    reg RL;                 // register load signal
    reg [4:0] AA;           // read address for busA
    reg [4:0] BA;           // read address for busB

    wire [31:0] busA;
    wire [31:0] busB;

    integer index;

    regFile UUT(.D(D), .DA(DA), .RL(RL), .AA(AA), .BA(BA), .busA(busA), .busB(busB));

    initial begin
        $dumpfile("regFile_tb.vcd");
        $dumpvars(0, regFile_tb);

        D=0;
        DA=0;
        RL=0;
        AA=0;
        BA=0;
        #20;

        // Test 1: write every register with its own value (register n gets n+1)
        for(index=0; index<32; index=index+1) begin
            DA=index;
            D=index+1;
            #20;
            RL=1;
            #20;
            RL=0;
            #20;
        end

        // Test 2: read every register on both busses at the same time
        for(index=0; index<32; index=index+1) begin
            AA=index;
            BA=31-index;
            #20;
        end

        // Test 3: overwrite register 17, then read all registers again
        DA=17;
        D=32'hDEADBEEF;
        #20;
        RL=1;
        #20;
        RL=0;
        #20;
        for(index=0; index<32; index=index+1) begin
            AA=index;
            BA=index;
            #20;
        end

        // Test 4: with RL low, changing D and DA must not write anything
        DA=3;
        D=32'hFFFFFFFF;
        #20;
        DA=9;
        #20;
        D=32'h12345678;
        #20;
        AA=3;
        BA=9;
        #40;

        $finish();
    end
endmodule
