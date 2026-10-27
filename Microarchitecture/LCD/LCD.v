module LCD(clk, rst, LCD_DATA, LCD_CS, LCD_WR);
    input clk, rst;

    output reg [7:0] LCD_DATA;
    output reg LCD_CS, LCD_WR;

    reg [1:0] state;
    reg [1:0] state2;
    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state<=0;
            state2<=0;
            count<=0;
            LCD_CS<=0;
            LCD_WR<=0;
            LCD_DATA<=0;
        end else begin
            case(state2)
            0: begin
                LCD_DATA<=8'h55;
                sendCommand;
                count<=count+1;
                if(count==3)  
                    state2<=1;
            end
            1: begin
                LCD_DATA<=8'hAA;
                sendCommand;
                count<=count+1;
                if(count==3)  
                    state2<=2;
            end
            2: begin
                LCD_DATA<=8'h8A;
                sendCommand;
                count<=count+1;
                if(count==3) 
                    state2<=3;                
            end
            3: begin
                LCD_DATA<=8'h7A;
                sendCommand;
                count<=count+1;
                if(count==3) 
                    state2<=0;                
            end            
            endcase            
        end
    end

    task sendCommand;
    begin
        case(state)
            0: begin
                LCD_CS<=1;
                state<=1;
            end
            1: begin
                LCD_WR<=1;
                state<=2;
            end
            2: begin
                LCD_WR<=0;
                state<=3;
            end
            3: begin
                LCD_CS<=0;
                state<=0;
            end
        endcase
    end
    endtask
endmodule