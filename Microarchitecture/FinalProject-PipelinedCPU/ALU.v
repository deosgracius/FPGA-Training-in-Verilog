/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Final Project

*/
// 32-bit arithmetic logic unit (ALU/FU).
//
// The operation selected by the 5-bit op input is performed on busA and busB
// and the result is put on the 32-bit output. The result is combinational,
// so it follows the inputs right away, like the ALU from class.
//
// The condition code bits Z, N, C and V are registers. They are updated on
// the rising edge of clk, and only by the instructions that affect them
// (see the Project 3 appendix). LD does not touch any flag, the logic
// instructions only change Z, SL changes C and Z, SR changes Z only.
// reset clears all four flags.
//
//   Z: result is zero
//   N: result is negative (bit 31 set)
//   C: ADD carry out, SUB borrow out, SL last bit shifted out
//   V: signed overflow on ADD and SUB
module ALU(clk, reset, busA, busB, op, result, Z, N, C, V);
    input clk, reset;
    input [31:0] busA, busB;
    input [4:0] op;             // operation code (see list below)

    output reg [31:0] result;
    output reg Z, N, C, V;

    reg carry;                  // carry/borrow/shift-out bit of the current operation

    // opcodes
    parameter LD  = 5'h01;      // pass busA through
    parameter ADD = 5'h03;      // busA + busB
    parameter SUB = 5'h04;      // busA - busB
    parameter AND = 5'h05;      // busA & busB
    parameter OR  = 5'h06;      // busA | busB
    parameter XOR = 5'h07;      // busA ^ busB
    parameter NOT = 5'h08;      // ~busA
    parameter SL  = 5'h09;      // busA shifted left by busB bits
    parameter SR  = 5'h0A;      // busA shifted right by busB bits

    // compute the result (and the carry bit for ADD, SUB and SL)
    always @(busA, busB, op) begin
        carry = 0;
        case(op)
            LD:  result = busA;
            ADD: {carry, result} = busA + busB;
            SUB: {carry, result} = busA - busB;
            AND: result = busA & busB;
            OR:  result = busA | busB;
            XOR: result = busA ^ busB;
            NOT: result = ~busA;
            SL:  {carry, result} = {1'b0, busA} << busB;
            SR:  result = busA >> busB;
            default: result = 0;
        endcase
    end

    // update the condition code bits
    always @(posedge clk or posedge reset) begin
        if(reset==1) begin
            Z <= 0;
            N <= 0;
            C <= 0;
            V <= 0;
        end else begin
            case(op)
                ADD: begin
                    Z <= result==0;
                    N <= result[31];
                    C <= carry;
                    // overflow when both inputs have the same sign and the result does not
                    V <= (busA[31]==busB[31]) & (result[31]!=busA[31]);
                end
                SUB: begin
                    Z <= result==0;
                    N <= result[31];
                    C <= carry;
                    // overflow when the inputs have different signs and the result has busB's sign
                    V <= (busA[31]!=busB[31]) & (result[31]!=busA[31]);
                end
                AND, OR, XOR, NOT, SR: begin
                    Z <= result==0;
                end
                SL: begin
                    Z <= result==0;
                    C <= carry;
                end
                default: begin
                    // LD and unused opcodes leave the flags unchanged
                end
            endcase
        end
    end
endmodule
