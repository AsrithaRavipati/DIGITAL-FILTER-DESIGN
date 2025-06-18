module fir_filter #(parameter N = 4)(
    input clk,
    input reset,
    input signed [7:0] x_in,              // 8-bit input
    output reg signed [15:0] y_out        // 16-bit output
);

// Coefficients (example: low-pass)
parameter signed [7:0] h[0:N-1] = '{8'd1, 8'd2, 8'd3, 8'd4};

// Delay line for input samples
reg signed [7:0] x [0:N-1];
integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < N; i = i + 1)
            x[i] <= 0;
        y_out <= 0;
    end else begin
        // Shift input samples
        for (i = N-1; i > 0; i = i - 1)
            x[i] <= x[i-1];
        x[0] <= x_in;

        // Perform convolution
        y_out <= h[0]*x[0] + h[1]*x[1] + h[2]*x[2] + h[3]*x[3];
    end
end

endmodule
//TESTBENCH
module fir_filter_tb;

reg clk, reset;
reg signed [7:0] x_in;
wire signed [15:0] y_out;

fir_filter uut (
    .clk(clk),
    .reset(reset),
    .x_in(x_in),
    .y_out(y_out)
);

initial begin
    clk = 0; reset = 1;
    #10 reset = 0;

    // Test input samples
    x_in = 8'd5; #10;
    x_in = 8'd10; #10;
    x_in = 8'd0; #10;
    x_in = 8'd4; #10;
    x_in = 8'd2; #10;
    x_in = -8'd2; #10;
    x_in = -8'd5; #10;
    x_in = 8'd0; #10;
    x_in = 8'd3; #10;
    $stop;
end

always #5 clk = ~clk;

endmodule

