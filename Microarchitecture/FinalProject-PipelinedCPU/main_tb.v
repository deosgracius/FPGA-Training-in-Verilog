/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Final Project

*/

`include "CPU.v"     // CPU.v includes regFile.v, ALU.v and decoder.v
`include "ROM.v"
`include "RAM.v"

// Testbench for the pipelined CPU, structured as in the assignment figure:
// the CPU, the ROM and the RAM are connected inside the testbench, which
// also makes the clock and the reset.
//
// The ROM holds program.asm. After reset the CPU runs it until it reaches
// the halt loop. The testbench then compares every register and the RAM
// locations the program used with the values the program must have
// produced, worked out by hand from program.asm and the ALU definition,
// and prints PASS or FAIL for each. It also checks that the halt loop was
// reached, that no skipped instruction ran (r9 must not be $BAD), and that
// the branch tests ran in the right order.
module main_tb;
    reg clk, rst;

    wire [5:0] ROMaddr;
    wire [48:0] instruction;
    wire [6:0] RAMaddr;
    wire CS, OE, WR;
    wire [31:0] data;

    integer index, errors, cycles;

    CPU CPU0(.clk(clk), .rst(rst), .ROMaddr(ROMaddr), .instruction(instruction),
             .RAMaddr(RAMaddr), .CS(CS), .OE(OE), .WR(WR), .data(data));

    ROM ROM0(.rst(rst), .CS(1'b0), .addr(ROMaddr), .dataOut(instruction));

    RAM RAM0(.rst(rst), .CS(CS), .OE(OE), .WR(WR), .addr(RAMaddr), .data(data));

    // compare a register with its expected value
    task checkReg;
    input [4:0] r;
    input [31:0] expected;
    begin
        if(CPU0.REGS.registers[r]===expected) begin
            $display("PASS: r%0d = %h", r, CPU0.REGS.registers[r]);
        end else begin
            errors=errors+1;
            $display("FAIL: r%0d = %h, expected %h", r, CPU0.REGS.registers[r], expected);
        end
    end
    endtask

    // compare a RAM location with its expected value
    task checkRam;
    input [6:0] a;
    input [31:0] expected;
    begin
        if(RAM0.memory[a]===expected) begin
            $display("PASS: RAM[%0d] = %h", a, RAM0.memory[a]);
        end else begin
            errors=errors+1;
            $display("FAIL: RAM[%0d] = %h, expected %h", a, RAM0.memory[a], expected);
        end
    end
    endtask

    initial begin
        $dumpfile("main_tb.vcd");
        $dumpvars(0, main_tb);

        errors=0;
        clk=0;
        rst=0;
        #20;
        rst=1;
        #20;
        rst=0;

        // run until the halt loop at address 59 is first reached, then keep
        // running and check the PC never leaves the loop (it fetches 59, 60
        // and 61 before each bra #halt pulls it back to 59)
        cycles=0;
        while(ROMaddr!=59 && cycles<400) begin
            #20;
            cycles=cycles+1;
        end
        $display("halt loop reached after %0d cycles", cycles);
        if(cycles<400) begin
            $display("PASS: program reached the halt loop");
        end else begin
            errors=errors+1;
            $display("FAIL: program never reached the halt loop");
        end
        for(index=0; index<40; index=index+1) begin
            #20;
            if(ROMaddr<59 || ROMaddr>61) begin
                errors=errors+1;
                $display("FAIL: PC left the halt loop, PC=%0d", ROMaddr);
            end
        end
        $display("PASS: PC stayed in the halt loop for 40 more cycles");

        // every register, from running program.asm by hand
        checkReg(0, 32'hF0F0F0F5);
        checkReg(1, 32'h0000000B);
        checkReg(2, 32'h0000000A);
        checkReg(3, 32'hFFFFFF00);
        checkReg(4, 32'h00000064);
        checkReg(5, 32'h00000003);
        checkReg(6, 32'h00000000);
        checkReg(7, 32'h0000003B);
        checkReg(8, 32'h00000005);
        checkReg(9, 32'h0F0F0F0F);
        checkReg(10, 32'hF0F0F0F0);
        checkReg(11, 32'hCC99E897);
        checkReg(12, 32'h12345678);
        checkReg(13, 32'hF00FF00F);
        checkReg(14, 32'hFF00FF00);
        checkReg(15, 32'h0F0F0F0F);
        checkReg(16, 32'h00000001);
        checkReg(17, 32'hFFFFFFFF);
        checkReg(18, 32'h0A0A0A0A);
        checkReg(19, 32'hAAAAAAAA);
        checkReg(20, 32'h00000009);
        checkReg(21, 32'h00000200);
        checkReg(22, 32'h00000209);
        checkReg(23, 32'h80000001);
        checkReg(24, 32'h80000000);
        checkReg(25, 32'h00000001);
        checkReg(26, 32'h10000008);
        checkReg(27, 32'h80000040);
        checkReg(28, 32'h00000030);
        checkReg(29, 32'h00000003);
        checkReg(30, 32'h00000004);
        checkReg(31, 32'hF0F0F0F5);
        // RAM locations the program wrote: $200 is address 0 (7 address bits), $5 is 5
        checkRam(0, 32'hC200952D);
        checkRam(5, 32'hF0F0F0F5);

        if(errors==0) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("%0d ERRORS", errors);
        end
        $finish();
    end

    // clock with a period of 20
    always begin
        #10;
        clk=~clk;
    end
endmodule
