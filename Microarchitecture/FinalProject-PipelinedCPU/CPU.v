/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Final Project

*/

// Sub-modules used by the CPU (same approach as the testbenches in class)
`include "regFile.v"
`include "ALU.v"
`include "decoder.v"

// 4-stage pipelined CPU.
//
// Stages (see the datapath diagram in the project folder):
//   IF  the program counter addresses the ROM, the 49-bit instruction is
//       latched into the IF/ID register
//   ID  the decoder splits the instruction and the two source registers are
//       read from the register file; operands and controls go to ID/EX
//   EX  the ALU computes the result and sets the flags; branches are decided
//       here using the Z flag; the result goes to EX/WB
//   WB  the RAM is read or written, and the register file is loaded
//
// Hazards are handled with interlocks and flushes:
//   - an instruction in ID waits (the pipeline stalls) while an older
//     instruction still in EX or WB is going to write a register it reads
//   - when a branch is taken in EX, the two younger instructions already in
//     IF/ID and ID/EX are replaced with NOPs and the PC takes the target
//
// Memory timing: the RAM latches on the falling edge of WR and the register
// file on the rising edge of RL. Both pulses are made from the clock's low
// half, so addresses and data set at the rising edge are stable by then.
module CPU(clk, rst, ROMaddr, instruction, RAMaddr, CS, OE, WR, data);
    input clk, rst;
    input [48:0] instruction;   // from the ROM
    output [5:0] ROMaddr;       // program counter, to the ROM
    output [6:0] RAMaddr;       // to the RAM
    output CS, OE, WR;          // RAM controls, active low
    inout [31:0] data;          // RAM data bus

    // ---------------- pipeline registers ----------------
    reg [5:0] PC;
    reg [48:0] IFID_inst;       // IF/ID
    // ID/EX
    reg [4:0] IDEX_opcode, IDEX_aluOp, IDEX_dst;
    reg [1:0] IDEX_mode;
    reg [31:0] IDEX_A, IDEX_B, IDEX_literal;
    reg IDEX_regWrite, IDEX_memRead, IDEX_memWrite, IDEX_isBranch;

    // EX/WB
    reg [4:0] EXWB_dst;
    reg [31:0] EXWB_result, EXWB_storeData;
    reg [6:0] EXWB_addr;
    reg EXWB_regWrite, EXWB_memRead, EXWB_memWrite;

    // ---------------- IF stage ----------------

    assign ROMaddr = PC;

    // ---------------- ID stage ----------------
    wire [4:0] opcode, src, dst;
    wire [1:0] mode;
    wire [31:0] literal;
    wire [4:0] aluOp;
    wire regWrite, memRead, memWrite, isBranch, loadImm, useLit, usesSrc, usesSrc2;

    decoder DEC(.instruction(IFID_inst), .opcode(opcode), .mode(mode), .src(src),
                .dst(dst), .literal(literal), .aluOp(aluOp), .regWrite(regWrite),
                .memRead(memRead), .memWrite(memWrite), .isBranch(isBranch),
                .loadImm(loadImm), .useLit(useLit), .usesSrc(usesSrc), .usesSrc2(usesSrc2));

    wire [31:0] regA, regB;     // register file read ports
    wire [31:0] wbData;         // value written into the register file
    wire RL;

    regFile REGS(.rst(rst), .D(wbData), .DA(EXWB_dst), .RL(RL),
                 .AA(src), .BA(literal[4:0]), .busA(regA), .busB(regB));

    // operand A is the literal for an immediate LD, otherwise register src;
    // operand B is the literal in immediate mode, otherwise register literal[4:0]
    wire [31:0] operandA = loadImm==1 ? literal : regA;
    wire [31:0] operandB = useLit==1 ? literal : regB;

    // stall while an older instruction will still write a register we read
    wire hazardSrc  = usesSrc==1  && ((IDEX_regWrite==1 && IDEX_dst==src) ||
                                      (EXWB_regWrite==1 && EXWB_dst==src));
    wire hazardSrc2 = usesSrc2==1 && ((IDEX_regWrite==1 && IDEX_dst==literal[4:0]) ||
                                      (EXWB_regWrite==1 && EXWB_dst==literal[4:0]));
    wire stall = hazardSrc | hazardSrc2;

    // ---------------- EX stage ----------------
    wire [31:0] aluResult;
    wire Z, N, C, V;

    ALU ALU0(.clk(clk), .reset(rst), .busA(IDEX_A), .busB(IDEX_B), .op(IDEX_aluOp),
             .result(aluResult), .Z(Z), .N(N), .C(C), .V(V));

    // branch decision: BRA always, BZ when Z, BNZ when not Z
    wire branchTaken = IDEX_isBranch==1 &&
                       (IDEX_opcode==5'h12 || (IDEX_opcode==5'h10 && Z==1) ||
                        (IDEX_opcode==5'h11 && Z==0));
    // target is register src (held in A) in register mode, else the literal
    wire [5:0] branchTarget = IDEX_mode==2'd2 ? IDEX_A[5:0] : IDEX_literal[5:0];

    // an immediate LD passes the literal through the ALU (op LD on operand A)
    wire [31:0] exResult = IDEX_aluOp==0 ? IDEX_A : aluResult;

    // ---------------- WB stage ----------------
    // RAM controls: select for a load or store, enable output for a load,
    // pulse WR low in the second half of the cycle for a store
    assign CS = (EXWB_memRead==1 || EXWB_memWrite==1) ? 1'b0 : 1'b1;
    assign OE = EXWB_memRead==1 ? 1'b0 : 1'b1;
    assign WR = (EXWB_memWrite==1 && clk==0) ? 1'b0 : 1'b1;
    assign RAMaddr = EXWB_addr;
    assign data = EXWB_memWrite==1 ? EXWB_storeData : 32'hZZZZZZZZ;

    // register file: a load from RAM writes the bus value, anything else the
    // EX result; RL rises in the second half of the cycle
    assign wbData = EXWB_memRead==1 ? data : EXWB_result;
    assign RL = (EXWB_regWrite==1 && clk==0) ? 1'b1 : 1'b0;

    // ---------------- pipeline register updates ----------------
    always @(posedge clk or posedge rst) begin
        if(rst==1) begin
            PC <= 0;
            IFID_inst <= 0;
            IDEX_opcode <= 0;
            IDEX_aluOp <= 0;
            IDEX_dst <= 0;
            IDEX_mode <= 0;
            IDEX_A <= 0;
            IDEX_B <= 0;
            IDEX_literal <= 0;
            IDEX_regWrite <= 0;
            IDEX_memRead <= 0;
            IDEX_memWrite <= 0;
            IDEX_isBranch <= 0;
            EXWB_dst <= 0;
            EXWB_result <= 0;
            EXWB_storeData <= 0;
            EXWB_addr <= 0;
            EXWB_regWrite <= 0;
            EXWB_memRead <= 0;
            EXWB_memWrite <= 0;
        end else begin
            // EX -> WB always advances
            EXWB_dst <= IDEX_dst;
            EXWB_result <= exResult;
            EXWB_storeData <= IDEX_A;
            EXWB_addr <= IDEX_literal[6:0];
            EXWB_regWrite <= IDEX_regWrite;
            EXWB_memRead <= IDEX_memRead;
            EXWB_memWrite <= IDEX_memWrite;

            if(branchTaken==1) begin
                // taken branch: load the PC and flush the two younger instructions
                PC <= branchTarget;
                IFID_inst <= 0;
                IDEX_opcode <= 0;
                IDEX_aluOp <= 0;
                IDEX_dst <= 0;
                IDEX_mode <= 0;
                IDEX_A <= 0;
                IDEX_B <= 0;
                IDEX_literal <= 0;
                IDEX_regWrite <= 0;
                IDEX_memRead <= 0;
                IDEX_memWrite <= 0;
                IDEX_isBranch <= 0;
            end else if(stall==1) begin
                // hazard: hold IF and ID, send a NOP into EX
                IDEX_opcode <= 0;
                IDEX_aluOp <= 0;
                IDEX_dst <= 0;
                IDEX_mode <= 0;
                IDEX_A <= 0;
                IDEX_B <= 0;
                IDEX_literal <= 0;
                IDEX_regWrite <= 0;
                IDEX_memRead <= 0;
                IDEX_memWrite <= 0;
                IDEX_isBranch <= 0;
            end else begin
                // normal advance
                PC <= PC + 1;
                IFID_inst <= instruction;
                IDEX_opcode <= opcode;
                IDEX_aluOp <= aluOp;
                IDEX_dst <= dst;
                IDEX_mode <= mode;
                IDEX_A <= operandA;
                IDEX_B <= operandB;
                IDEX_literal <= literal;
                IDEX_regWrite <= regWrite;
                IDEX_memRead <= memRead;
                IDEX_memWrite <= memWrite;
                IDEX_isBranch <= isBranch;
            end
        end
    end
endmodule
