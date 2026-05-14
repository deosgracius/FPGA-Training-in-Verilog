module LED_Blinking(
    input clk,
    input rst,
    output reg led
);

    reg [24:0] counter;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            counter <= 0;
            led <= 0;
        end
        else begin
            counter <= counter + 1;

            if (counter == 10) begin
                led <= ~led;
                counter <= 0;
            end

        end
    end

endmodule