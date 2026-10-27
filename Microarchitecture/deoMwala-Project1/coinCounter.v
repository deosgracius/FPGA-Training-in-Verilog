module coinCounter(clk, reset, inquarter, indime, innickel, monCount);
    input clk, reset;
    input inquarter, indime, innickel;
    output reg [9:0] monCount;

    reg prevQuarter, prevDime, prevNickel;

    // a coin is counted on the rising edge of its pulse
    always @(posedge clk or posedge reset) begin
        if(reset==1) begin
            monCount <= 0;
            prevQuarter <= 0;
            prevDime <= 0;
            prevNickel <= 0;
        end else begin
            prevQuarter <= inquarter;
            prevDime <= indime;
            prevNickel <= innickel;
            if(inquarter==1) begin
                if(prevQuarter==0) begin
                    monCount <= monCount + 25;
                end
            end else if(indime==1) begin
                if(prevDime==0) begin
                    monCount <= monCount + 10;
                end
            end else if(innickel==1) begin
                if(prevNickel==0) begin
                    monCount <= monCount + 5;
                end
            end
        end
    end
endmodule
