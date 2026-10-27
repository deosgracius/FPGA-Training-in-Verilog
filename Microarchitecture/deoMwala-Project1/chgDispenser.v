module chgDispenser(clk, reset, change, outquarter, outdime, outnickel, done);
    input clk, reset;
    input [9:0] change;
    output reg outquarter, outdime, outnickel;
    output done;

    reg [1:0] state;
    reg [9:0] remaining;

    assign done = state==0;

    always @(posedge clk or posedge reset) begin
        if(reset==1) begin
            state <= 0;
            remaining <= 0;
            outquarter <= 0;
            outdime <= 0;
            outnickel <= 0;
        end else begin
            case(state)
                0: begin
                    if(change>0) begin
                        remaining <= change;
                        state <= 1;
                    end
                end
                1: begin
                    if(remaining>=25) begin
                        outquarter <= 1;
                        remaining <= remaining - 25;
                        state <= 2;
                    end else if(remaining>=10) begin
                        outdime <= 1;
                        remaining <= remaining - 10;
                        state <= 2;
                    end else if(remaining>=5) begin
                        outnickel <= 1;
                        remaining <= remaining - 5;
                        state <= 2;
                    end else begin
                        state <= 0;
                    end
                end
                2: begin
                    outquarter <= 0;
                    outdime <= 0;
                    outnickel <= 0;
                    state <= 1;
                end
            endcase
        end
    end
endmodule
