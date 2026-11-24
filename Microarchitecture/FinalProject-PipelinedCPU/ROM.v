/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Final Project

*/

// 64x49 instruction ROM (Project 4 ROM, widened for the final project).
//
// addr selects one of 64 locations, each holding one 49-bit instruction.
// CS is active low: with CS low the selected instruction is on dataOut,
// with CS high dataOut reads zero. rst loads the program on its rising
// edge, the same way the LUT from class loads its table.
//
// The program was assembled with the class assembler (crASM) from
// program.asm, which is included in the project folder. Part 1 gives the
// registers known values, part 2 is the example instruction listing, and
// part 3 stores and loads through the RAM and tests every branch. Unused
// locations hold zero, which the CPU treats as a NOP.
module ROM(rst, CS, addr, dataOut);
    input rst;                  // loads the program
    input CS;                   // chip select, active low
    input [5:0] addr;           // instruction address (0 to 63)
    output [48:0] dataOut;      // 49-bit instruction

    reg [48:0] data[0:63];      // the 64 locations

    integer index;

    assign dataOut = CS==0 ? data[addr] : 49'd0;

    always @(posedge rst) begin
        for(index=0; index<64; index=index+1) begin
            data[index] <= 49'd0;
        end
        data[0 ] <= 49'h10020000000A ; //  0: ld r2, #10
        data[1 ] <= 49'h100400000064 ; //  1: ld r4, #100
        data[2 ] <= 49'h100500000003 ; //  2: ld r5, #3
        data[3 ] <= 49'h100700000000 ; //  3: ld r7, #0
        data[4 ] <= 49'h100800000005 ; //  4: ld r8, #5
        data[5 ] <= 49'h100AF0F0F0F0 ; //  5: ld r10, #$F0F0F0F0
        data[6 ] <= 49'h100C12345678 ; //  6: ld r12, #$12345678
        data[7 ] <= 49'h100EFF00FF00 ; //  7: ld r14, #$FF00FF00
        data[8 ] <= 49'h100F0F0F0F0F ; //  8: ld r15, #$0F0F0F0F
        data[9 ] <= 49'h1011FFFFFFFF ; //  9: ld r17, #$FFFFFFFF
        data[10] <= 49'h1013AAAAAAAA ; // 10: ld r19, #$AAAAAAAA
        data[11] <= 49'h10140F0F0F0F ; // 11: ld r20, #$0F0F0F0F
        data[12] <= 49'h101655555555 ; // 12: ld r22, #$55555555
        data[13] <= 49'h101880000000 ; // 13: ld r24, #$80000000
        data[14] <= 49'h101900000001 ; // 14: ld r25, #1
        data[15] <= 49'h101B80000040 ; // 15: ld r27, #$80000040
        data[16] <= 49'h101D00000003 ; // 16: ld r29, #3
        data[17] <= 49'h101E00000004 ; // 17: ld r30, #4
        data[18] <= 49'h1001ABCDEF12 ; // 18: ld r1, #$ABCDEF12
        data[19] <= 49'h140100000200 ; // 19: ld r1, $200
        data[20] <= 49'h242000000200 ; // 20: st r1, $200
        data[21] <= 49'h391F0000000A ; // 21: add r31, r8, r10
        data[22] <= 49'h304100000001 ; // 22: add r1, r2, #1
        data[23] <= 49'h488300000005 ; // 23: sub r3, r4, r5
        data[24] <= 49'h40E600000001 ; // 24: sub r6, r7, #1
        data[25] <= 49'h894900000000 ; // 25: not r9, r10
        data[26] <= 49'h718BDEADBEEF ; // 26: xor r11, r12, #$DEADBEEF
        data[27] <= 49'h79CD0000000F ; // 27: xor r13, r14, r15
        data[28] <= 49'h523000000001 ; // 28: and r16, r17, #1
        data[29] <= 49'h5A7200000014 ; // 29: and r18, r19, r20
        data[30] <= 49'h62D5AAAAAAAA ; // 30: or r21, r22, #$AAAAAAAA
        data[31] <= 49'h6B1700000019 ; // 31: or r23, r24, r25
        data[32] <= 49'hA37A00000001 ; // 32: sr r26, r27, #1
        data[33] <= 49'hAB7A00000005 ; // 33: sr r26, r27, r5
        data[34] <= 49'h93BC00000001 ; // 34: sl r28, r29, #1
        data[35] <= 49'h9BBC0000001E ; // 35: sl r28, r29, r30
        data[36] <= 49'h101400000009 ; // 36: ld r20, #9
        data[37] <= 49'h9B3500000014 ; // 37: sl r21, r25, r20
        data[38] <= 49'h3AB600000014 ; // 38: add r22, r21, r20
        data[39] <= 49'h1003000000FF ; // 39: ld r3, #$FF
        data[40] <= 49'h886300000000 ; // 40: not r3, r3
        data[41] <= 49'h27E000000005 ; // 41: st r31, $5
        data[42] <= 49'h140000000005 ; // 42: ld r0, $5
        data[43] <= 49'h300000000000 ; // 43: add r0, r0, #0
        data[44] <= 49'h110000000002F; // 44: bnz #skip1
        data[45] <= 49'h100900000BAD ; // 45: ld r9, #$BAD
        data[46] <= 49'h100A00000BAD ; // 46: ld r10, #$BAD
        data[47] <= 49'h48C600000006 ; // 47: sub r6, r6, r6
        data[48] <= 49'h1000000000033; // 48: bz #skip2
        data[49] <= 49'h100900000BAD ; // 49: ld r9, #$BAD
        data[50] <= 49'h100C00000BAD ; // 50: ld r12, #$BAD
        data[51] <= 49'h1100000000035; // 51: bnz #bad
        data[52] <= 49'h1200000000037; // 52: bra #skip3
        data[53] <= 49'h100900000BAD ; // 53: ld r9, #$BAD
        data[54] <= 49'h100E00000BAD ; // 54: ld r14, #$BAD
        data[55] <= 49'h10070000003B ; // 55: ld r7, #halt
        data[56] <= 49'h128E000000000; // 56: bra r7
        data[57] <= 49'h100900000BAD ; // 57: ld r9, #$BAD
        data[58] <= 49'h100F00000BAD ; // 58: ld r15, #$BAD
        data[59] <= 49'h120000000003B; // 59: bra #halt
    end
endmodule
