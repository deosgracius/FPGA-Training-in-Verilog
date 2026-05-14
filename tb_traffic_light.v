`timescale 1ns / 1ps

module tb_traffic_light;

    reg clk;
    reg rst;
    wire [2:0] lights;

    traffic_light uut (
        .clk(clk),
        .rst(rst),
        .lights(lights)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin

        rst = 1;

        @(posedge clk);
        @(posedge clk);

        rst = 0;

        repeat(50) @(posedge clk);

        $display("Final lights = %b", lights);

        $finish;

    end

    // GTKWave dump
    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, tb_traffic_light);
    end

    // Monitor
    initial begin
        $monitor("Time=%0t state lights=%b",
                  $time, lights);
    end

endmodule