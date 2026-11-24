/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Final Project

*/

// Instruction decoder.
//
// Every instruction is 49 bits, laid out the way the class assembler builds
// it (inst2ASCII in parser.c):
//
//   [48:44] opcode    [43:42] mode    [41:37] src    [36:32] dst    [31:0] literal
//
// mode is 0 for immediate, 1 for direct (literal is a memory address) and
// 2 for register. In register mode a three-operand instruction keeps its
// second source register number in the literal field.
//
// Besides splitting the fields, the decoder produces the control signals
// the datapath needs:
//   aluOp     operation for the ALU (0 for instructions that do not use it)
//   regWrite  the instruction writes a register (dst)
//   memRead   LD in direct mode, reads the RAM
//   memWrite  ST in direct mode, writes the RAM
//   isBranch  BZ, BNZ or BRA
//   loadImm   LD in immediate mode, the literal goes straight to dst
//   useLit    the ALU's second operand is the literal (immediate mode)
//   usesSrc   the instruction reads register src
//   usesSrc2  the instruction reads register literal[4:0] (register mode)
module decoder(instruction, opcode, mode, src, dst, literal, aluOp, regWrite,
               memRead, memWrite, isBranch, loadImm, useLit, usesSrc, usesSrc2);
    input [48:0] instruction;

    output [4:0] opcode;
    output [1:0] mode;
    output [4:0] src, dst;
    output [31:0] literal;
    output reg [4:0] aluOp;
    output reg regWrite, memRead, memWrite, isBranch, loadImm, useLit, usesSrc, usesSrc2;

    // opcodes
    parameter LD  = 5'h01;
    parameter ST  = 5'h02;
    parameter ADD = 5'h03;
    parameter SUB = 5'h04;
    parameter AND = 5'h05;
    parameter OR  = 5'h06;
    parameter XOR = 5'h07;
    parameter NOT = 5'h08;
    parameter SL  = 5'h09;
    parameter SR  = 5'h0A;
    parameter BZ  = 5'h10;
    parameter BNZ = 5'h11;
    parameter BRA = 5'h12;

    // addressing modes
    parameter IMMEDIATE = 2'd0;
    parameter DIRECT    = 2'd1;
    parameter REGISTER  = 2'd2;

    assign opcode  = instruction[48:44];
    assign mode    = instruction[43:42];
    assign src     = instruction[41:37];
    assign dst     = instruction[36:32];
    assign literal = instruction[31:0];

    always @(instruction, opcode, mode) begin
        aluOp    = 0;
        regWrite = 0;
        memRead  = 0;
        memWrite = 0;
        isBranch = 0;
        loadImm  = 0;
        useLit   = 0;
        usesSrc  = 0;
        usesSrc2 = 0;
        case(opcode)
            LD: begin
                regWrite = 1;
                if(mode==IMMEDIATE) begin
                    loadImm = 1;            // dst = literal
                end else if(mode==DIRECT) begin
                    memRead = 1;            // dst = RAM[literal]
                end else begin
                    aluOp = LD;             // dst = src, through the ALU
                    usesSrc = 1;
                end
            end
            ST: begin
                memWrite = 1;               // RAM[literal] = src
                usesSrc = 1;
            end
            ADD, SUB, AND, OR, XOR, SL, SR: begin
                aluOp = opcode;             // dst = src op (literal or register)
                regWrite = 1;
                usesSrc = 1;
                if(mode==IMMEDIATE) begin
                    useLit = 1;
                end else begin
                    usesSrc2 = 1;
                end
            end
            NOT: begin
                aluOp = NOT;                // dst = ~src
                regWrite = 1;
                usesSrc = 1;
            end
            BZ, BNZ, BRA: begin
                isBranch = 1;               // target is literal, or src in register mode
                if(mode==REGISTER) begin
                    usesSrc = 1;
                end
            end
            default: begin
                // opcode 0 and anything unknown is a NOP
            end
        endcase
    end
endmodule
