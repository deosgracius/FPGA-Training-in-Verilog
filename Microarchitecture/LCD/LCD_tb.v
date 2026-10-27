`include "LCD.v"

module LCD_tb;
    reg clk, rst;
    wire LCD_CS, LCD_WR;
    wire [7:0] LCD_DATA;

    LCD UUT(
            .clk(clk), .rst(rst), .LCD_DATA(LCD_DATA), 
            .LCD_CS(LCD_CS), .LCD_WR(LCD_WR)
            );
    
    integer index;

    initial begin
        $dumpfile("LCD.vcd");
        $dumpvars(0, LCD_tb);

        clk=0;
        rst=0;
        #20;

        rst=1;
        #20;
        rst=0;
        #20;

        for(index=0; index<16; index=index+1) begin
            clk=1;
            #20;
            clk=0;
            #20;
        end
    end
endmodule