module bevDispenser(clk, reset, money, inbev1, inbev2, inbev3, outbev1, outbev2, outbev3, change);
    input clk, reset;
    input [9:0] money;
    input inbev1, inbev2, inbev3;
    output reg outbev1, outbev2, outbev3;
    output reg [9:0] change;

    // prices: bev1 = 65, bev2 = 90, bev3 = 120 cents
    // outbev and change are held for one clock (20 units)
    always @(posedge clk or posedge reset) begin
        if(reset==1) begin
            outbev1 <= 0;
            outbev2 <= 0;
            outbev3 <= 0;
            change <= 0;
        end else begin
            outbev1 <= 0;
            outbev2 <= 0;
            outbev3 <= 0;
            change <= 0;
            if(inbev1==1) begin
                if(money>=65) begin
                    outbev1 <= 1;
                    change <= money - 65;
                end
            end else if(inbev2==1) begin
                if(money>=90) begin
                    outbev2 <= 1;
                    change <= money - 90;
                end
            end else if(inbev3==1) begin
                if(money>=120) begin
                    outbev3 <= 1;
                    change <= money - 120;
                end
            end
        end
    end
endmodule
