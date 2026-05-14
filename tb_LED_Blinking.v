module tb_LED_Blinking;

    reg clk;
    reg rst;
    wire led;

    // Instantiate DUT
    LED_Blinking uut (
        .clk(clk),
        .rst(rst),
        .led(led)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Dump file for GTKWave
    initial begin
        $dumpfile("LED_Blinking.vcd");
        $dumpvars(0, tb_LED_Blinking);
    end

    // Monitor values
    initial begin
        $monitor("Time=%0t clk=%b rst=%b led=%b",
                  $time, clk, rst, led);
    end

    // Test sequence
    initial begin
        rst = 1; // Assert reset
        #10;
        rst = 0; // Deassert reset

        #100000000; // Run simulation for a while to observe LED blinking

        $finish;
    end
endmodule


