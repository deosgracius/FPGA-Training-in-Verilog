/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Project 4

*/

`include "ROM.v"

// Testbench for the 32x4 ROM.
//
// Reset is shown to load the contents on its rising edge.
// Test 1: every one of the 32 addresses is read with CS low and compared with the value that reset loads.
// Test 2: with CS high, every address is read again and dataOut must be 0.
// Test 3: CS is toggled on one address to show dataOut follows CS.
// Test 4: reset is applied again after the run and the contents are the same.
//
// Each check prints PASS or FAIL and the run ends with ALL TESTS PASSED when
// every check was correct.
module ROM_tb;
    reg reset, CS;
    reg [4:0] addr;
    wire [3:0] dataOut;

    integer index, errors;

    // the values that reset loads, used to check what is read back
    reg [3:0] expected[0:31];

    ROM UUT(.reset(reset), .CS(CS), .addr(addr), .dataOut(dataOut));

    // compare dataOut with an expected value
    task check;
    input [3:0] exp;
    input [255:0] name;
    begin
        if(dataOut===exp) begin
            $display("PASS: %0s, address %0d reads %h", name, addr, dataOut);
        end else begin
            errors=errors+1;
            $display("FAIL: %0s, address %0d reads %h, expected %h", name, addr, dataOut, exp);
        end
    end
    endtask

    initial begin
        $dumpfile("ROM_tb.vcd");
        $dumpvars(0, ROM_tb);

        expected[0]=4'hA;
        expected[1]=4'hD;
        expected[2]=4'hA;
        expected[3]=4'h8;
        expected[4]=4'hC;
        expected[5]=4'h3;
        expected[6]=4'hD;
        expected[7]=4'h6;
        expected[8]=4'hD;
        expected[9]=4'h9;
        expected[10]=4'h0;
        expected[11]=4'h2;
        expected[12]=4'h1;
        expected[13]=4'h2;
        expected[14]=4'h4;
        expected[15]=4'h5;
        expected[16]=4'h7;
        expected[17]=4'hD;
        expected[18]=4'h9;
        expected[19]=4'h8;
        expected[20]=4'h0;
        expected[21]=4'h4;
        expected[22]=4'h3;
        expected[23]=4'h0;
        expected[24]=4'h7;
        expected[25]=4'h8;
        expected[26]=4'h4;
        expected[27]=4'h0;
        expected[28]=4'h9;
        expected[29]=4'hE;
        expected[30]=4'hA;
        expected[31]=4'h6;

        errors=0;
        reset=0;
        CS=1;
        addr=0;
        #20;

        // before reset the contents are not loaded yet; the rising edge of
        // reset loads them, so the data must be there while reset is still high
        CS=0;
        addr=5;
        #20;
        check(4'bxxxx, "Before reset the contents are not loaded");
        reset=1;
        #20;
        check(expected[5], "Reset loads contents on its rising edge");
        reset=0;
        #20;
        CS=1;

        // Test 1: read all 32 addresses with the chip selected
        CS=0;
        for(index=0; index<32; index=index+1) begin
            addr=index;
            #20;
            check(expected[index], "Test 1 CS low");
        end

        // Test 2: with CS high every address must read zero
        CS=1;
        for(index=0; index<32; index=index+1) begin
            addr=index;
            #20;
            check(4'b0000, "Test 2 CS high");
        end

        // Test 3: dataOut follows CS on a single address
        addr=29;
        CS=0;
        #20;
        check(expected[29], "Test 3 CS low again");
        CS=1;
        #20;
        check(4'b0000, "Test 3 CS high again");
        CS=0;
        #20;
        check(expected[29], "Test 3 CS low once more");

        // Test 4: a second reset leaves the contents unchanged
        reset=1;
        #20;
        reset=0;
        #20;
        for(index=0; index<32; index=index+1) begin
            addr=index;
            #20;
            check(expected[index], "Test 4 after second reset");
        end

        if(errors==0) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("%0d ERRORS", errors);
        end
        $finish();
    end
endmodule
