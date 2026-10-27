// Console controller
// Reads the button states serially from the gamepad controller.

module console(clock, getState, data, latch, clk, A, B, X, Y);
    input clock, getState, data;

    output reg latch, clk;
    output reg A, B, X, Y;

    reg [3:0] buttonState;  
    reg [2:0] step;         
    reg [1:0] bitCount;     

    initial begin
        latch=0;
        clk=0;
        A=0;
        B=0;
        X=0;
        Y=0;
        step=0;
        bitCount=0;
    end

    always @(posedge clock) begin
        case(step)
            0: begin
                if(getState==1) begin
                    latch <= 1;
                    step <= 1;
                end
            end
            1: begin
                latch <= 0;
                bitCount <= 0;
                step <= 2;
            end
            2: begin
                clk <= 1;
                step <= 3;
            end
            3: begin
                clk <= 0;
                buttonState <= {buttonState[2:0], data};
                if(bitCount==3) begin
                    step <= 4;
                end else begin
                    bitCount <= bitCount + 1;
                    step <= 2;
                end
            end
            // All 4 bits read: update the outputs
            4: begin
                A <= buttonState[3];
                B <= buttonState[2];
                X <= buttonState[1];
                Y <= buttonState[0];
                step <= 0;
            end
            default: begin
                latch <= 0;
                clk <= 0;
                step <= 0;
            end
        endcase
    end
endmodule
