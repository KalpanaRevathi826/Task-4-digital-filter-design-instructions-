`timescale 1ns / 1ps

module fir_filter_tb;
    parameter N = 4;
    parameter WIDTH = 16;

    reg clk, rst;
    reg signed [WIDTH-1:0] x_in;
    wire signed [WIDTH+3:0] y_out;

    fir_filter #(.N(N), .WIDTH(WIDTH)) uut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $monitor("Time=%0t | x_in=%d | y_out=%d", $time, x_in, y_out);
        rst = 1;
        x_in = 0;
        #12;
        rst = 0;

        // Input sequence
        x_in = 16'd10; #10;
        x_in = 16'd20; #10;
        x_in = 16'd30; #10;
        x_in = 16'd40; #10;
        x_in = 16'd0;  #10;
        x_in = 16'd0;  #10;
        x_in = 16'd0;  #20;

        $stop;
    end
endmodule
