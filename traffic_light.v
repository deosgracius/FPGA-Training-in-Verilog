`timescale 1ns / 1ps

// State machine for traffic light control
module traffic_light(
    input clk,
    input rst,
    output reg [2:0] lights
);

    // State encoding
    localparam RED     = 2'b00,
               GREEN   = 2'b01,
               YELLOW  = 2'b10;

    // Light outputs
    localparam RED_LIGHT    = 3'b001,
               GREEN_LIGHT  = 3'b010,
               YELLOW_LIGHT = 3'b100,
               OFF_ALL      = 3'b000;

    reg [1:0] state;
    reg [24:0] timer;

    // State transition logic
    always @(posedge clk) begin

        if (rst) begin
            state <= RED;
            timer <= 0;
            lights <= RED_LIGHT;
        end
        else begin

            timer <= timer + 1;

            case(state)

                RED: begin
                    lights <= RED_LIGHT;

                    if (timer >= 10) begin
                        state <= GREEN;
                        timer <= 0;
                    end
                end

                GREEN: begin
                    lights <= GREEN_LIGHT;

                    if (timer >= 10) begin
                        state <= YELLOW;
                        timer <= 0;
                    end
                end

                YELLOW: begin
                    lights <= YELLOW_LIGHT;

                    if (timer >= 10) begin
                        state <= RED;
                        timer <= 0;
                    end
                end

                default: begin
                    state <= RED;
                    lights <= OFF_ALL;
                end

            endcase
        end
    end

endmodule



      