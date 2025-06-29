`timescale 1ns / 1ps

module fir_filter #(
    parameter N = 4,                     // Number of taps (filter order + 1)
    parameter WIDTH = 16,                // Bit width of input and coefficients
    parameter COEFFS = "{16'd2, 16'd4, 16'd4, 16'd2}" // Example coefficients
)(
    input clk,
    input rst,
    input signed [WIDTH-1:0] x_in,
    output reg signed [WIDTH+3:0] y_out // Output width: WIDTH + log2(N)
);

    // Coefficient and delay line
    reg signed [WIDTH-1:0] coeffs [0:N-1];
    reg signed [WIDTH-1:0] shift_reg [0:N-1];
    integer i;

    initial begin
        // Initialize coefficients (example: symmetric low-pass)
        coeffs[0] = 16'd2;
        coeffs[1] = 16'd4;
        coeffs[2] = 16'd4;
        coeffs[3] = 16'd2;
    end

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1)
                shift_reg[i] <= 0;
            y_out <= 0;
        end else begin
            // Shift input through delay line
            for (i = N-1; i > 0; i = i - 1)
                shift_reg[i] <= shift_reg[i-1];
            shift_reg[0] <= x_in;

            // FIR calculation
            y_out <= 0;
            for (i = 0; i < N; i = i + 1)
                y_out <= y_out + shift_reg[i] * coeffs[i];
        end
    end

endmodule
