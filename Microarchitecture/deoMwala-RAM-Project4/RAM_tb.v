/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Project 4

*/

`include "RAM.v"

// Testbench for the 32x4 RAM.
//
// The testbench drives the bidirectional bus through dataReg, which is put
// on the bus only while writing (driveBus=1). The rest of the time the
// testbench leaves the bus alone so the RAM can drive it, or so it can be
// seen to be high impedance.
//
// Test 1: after reset, read all 32 addresses and compare with the values
//         that reset loads.
// Test 2: write a new value into every address, then read all 32 back.
// Test 3: with CS high, the bus is high impedance whatever OE and WR do,
//         and a write attempt does not change the memory.
// Test 4: with CS low but OE high, the bus is high impedance.
// Test 5: the write happens on the falling edge of WR: the data bus is
//         changed while WR is low and only the value present at the falling
//         edge is stored.
// Test 6: reset restores the initial contents.
//
// Each check prints PASS or FAIL and the run ends with ALL TESTS PASSED when
// every check was correct.
module RAM_tb;
    reg reset, CS, OE, WR;
    reg [4:0] addr;
    reg [3:0] dataReg;          // value the testbench drives onto the bus
    reg driveBus;               // 1 while the testbench drives the bus
    wire [3:0] data;

    integer index, errors;

    // the values that reset loads
    reg [3:0] startValue[0:31];

    // the testbench side of the bidirectional bus
    assign data = driveBus==1 ? dataReg : 4'bzzzz;

    RAM UUT(.reset(reset), .CS(CS), .OE(OE), .WR(WR), .addr(addr), .data(data));

    // compare the bus with an expected value (4'bzzzz for high impedance)
    task check;
    input [3:0] exp;
    input [255:0] name;
    begin
        if(data===exp) begin
            $display("PASS: %0s, address %0d bus %b", name, addr, data);
        end else begin
            errors=errors+1;
            $display("FAIL: %0s, address %0d bus %b, expected %b", name, addr, data, exp);
        end
    end
    endtask

    // write value into the selected address with a 20-unit low pulse on WR
    task write;
    input [4:0] a;
    input [3:0] value;
    begin
        addr=a;
        dataReg=value;
        driveBus=1;
        #20;
        WR=0;
        #20;
        WR=1;
        #20;
        driveBus=0;
        #20;
    end
    endtask

    initial begin
        $dumpfile("RAM_tb.vcd");
        $dumpvars(0, RAM_tb);

        startValue[0]=4'hB;
        startValue[1]=4'hB;
        startValue[2]=4'hD;
        startValue[3]=4'h4;
        startValue[4]=4'h6;
        startValue[5]=4'hA;
        startValue[6]=4'hC;
        startValue[7]=4'hA;
        startValue[8]=4'h1;
        startValue[9]=4'hC;
        startValue[10]=4'h0;
        startValue[11]=4'h1;
        startValue[12]=4'h2;
        startValue[13]=4'h9;
        startValue[14]=4'h1;
        startValue[15]=4'h5;
        startValue[16]=4'h1;
        startValue[17]=4'h4;
        startValue[18]=4'hB;
        startValue[19]=4'hB;
        startValue[20]=4'hE;
        startValue[21]=4'hF;
        startValue[22]=4'hE;
        startValue[23]=4'hF;
        startValue[24]=4'h5;
        startValue[25]=4'h1;
        startValue[26]=4'h8;
        startValue[27]=4'hC;
        startValue[28]=4'h9;
        startValue[29]=4'hD;
        startValue[30]=4'h3;
        startValue[31]=4'h8;

        errors=0;
        reset=0;
        CS=1;
        OE=1;
        WR=1;
        addr=0;
        dataReg=0;
        driveBus=0;
        #20;

        // load the initial contents
        reset=1;
        #20;
        reset=0;
        #20;

        // Test 1: read every address after reset
        CS=0;
        OE=0;
        for(index=0; index<32; index=index+1) begin
            addr=index;
            #20;
            check(startValue[index], "Test 1 read after reset");
        end
        OE=1;
        #20;

        // Test 2: write a new value (the bitwise NOT of the address) into every
        // address, then read all 32 back
        for(index=0; index<32; index=index+1) begin
            write(index, ~index[3:0]);
        end
        OE=0;
        for(index=0; index<32; index=index+1) begin
            addr=index;
            #20;
            check(~index[3:0], "Test 2 read after write");
        end
        OE=1;
        #20;

        // Test 3: CS high. The bus must be high impedance with OE low, and a
        // write pulse must not change the memory
        CS=1;
        addr=7;
        OE=0;
        #20;
        check(4'bzzzz, "Test 3 CS high OE low, bus tristated");
        dataReg=4'h0;
        driveBus=1;
        #20;
        WR=0;
        #20;
        WR=1;
        #20;
        driveBus=0;
        #20;
        check(4'bzzzz, "Test 3 CS high after write pulse, bus tristated");
        CS=0;
        #20;
        check(~4'd7, "Test 3 write with CS high was ignored");
        OE=1;
        #20;

        // Test 4: CS low but OE high, the bus must be high impedance
        addr=12;
        #20;
        check(4'bzzzz, "Test 4 OE high, bus tristated");
        OE=0;
        #20;
        check(~4'd12, "Test 4 OE low, data driven");
        OE=1;
        #20;

        // Test 5: data is latched on the falling edge of WR. The bus holds 5
        // at the falling edge and is changed to A while WR is still low; the
        // stored value must be 5
        addr=20;
        dataReg=4'h5;
        driveBus=1;
        #20;
        WR=0;
        #20;
        dataReg=4'hA;
        #20;
        WR=1;
        #20;
        driveBus=0;
        OE=0;
        #20;
        check(4'h5, "Test 5 value at falling edge of WR stored");
        OE=1;
        #20;

        // Test 6: reset puts the initial contents back in every address
        reset=1;
        #20;
        reset=0;
        #20;
        OE=0;
        for(index=0; index<32; index=index+1) begin
            addr=index;
            #20;
            check(startValue[index], "Test 6 read after second reset");
        end
        OE=1;
        #20;

        if(errors==0) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("%0d ERRORS", errors);
        end
        $finish();
    end
endmodule
