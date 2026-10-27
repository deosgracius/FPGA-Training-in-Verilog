`include "coinCounter.v"
`include "bevDispenser.v"
`include "chgDispenser.v"

module main(clk, rst, inquarter, indime, innickel, inbev1, inbev2, inbev3, cancel,
            outquarter, outdime, outnickel, outbev1, outbev2, outbev3);
    input clk, rst;
    input inquarter, indime, innickel;
    input inbev1, inbev2, inbev3;
    input cancel;
    output outquarter, outdime, outnickel;
    output outbev1, outbev2, outbev3;

    wire [9:0] monCount;
    wire [9:0] bevChange;
    wire [9:0] change;
    wire done;
    wire coinReset;
    wire selbev1, selbev2, selbev3;

    reg cancelReg;
    reg [9:0] cancelChange;
    reg prevBev1, prevBev2, prevBev3, prevCancel;

    // a selection or cancel is taken on the rising edge of its pulse,
    // and ignored while change is being dispensed (done==0)
    always @(posedge clk or posedge rst) begin
        if(rst==1) begin
            cancelReg <= 0;
            cancelChange <= 0;
            prevBev1 <= 0;
            prevBev2 <= 0;
            prevBev3 <= 0;
            prevCancel <= 0;
        end else begin
            prevBev1 <= inbev1;
            prevBev2 <= inbev2;
            prevBev3 <= inbev3;
            prevCancel <= cancel;
            cancelReg <= 0;
            cancelChange <= 0;
            if(cancel==1) begin
                if(prevCancel==0) begin
                    if(done==1) begin
                        cancelReg <= 1;
                        cancelChange <= monCount;
                    end
                end
            end
        end
    end

    assign coinReset = rst | cancelReg | outbev1 | outbev2 | outbev3;
    assign selbev1 = inbev1 & ~prevBev1 & done & ~cancel;
    assign selbev2 = inbev2 & ~prevBev2 & done & ~cancel;
    assign selbev3 = inbev3 & ~prevBev3 & done & ~cancel;
    assign change = bevChange + cancelChange;

    coinCounter COINS(.clk(clk), .reset(coinReset),
                      .inquarter(inquarter), .indime(indime), .innickel(innickel),
                      .monCount(monCount)
                      );

    bevDispenser BEV(.clk(clk), .reset(rst), .money(monCount),
                     .inbev1(selbev1), .inbev2(selbev2), .inbev3(selbev3),
                     .outbev1(outbev1), .outbev2(outbev2), .outbev3(outbev3),
                     .change(bevChange)
                     );

    chgDispenser CHG(.clk(clk), .reset(rst), .change(change),
                     .outquarter(outquarter), .outdime(outdime), .outnickel(outnickel),
                     .done(done)
                     );
endmodule
