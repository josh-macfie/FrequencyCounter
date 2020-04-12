module top(
	 input mclk,
	 input signal,
	 output [11:0] freq
    );

// mclk default is 50 MHz
// (for 1 second count, need 26-bit counter that resets after 50000000
// clock tics)
reg [11:0] freq_count;
reg [25:0] count;
reg old_sig;
reg [11:0] freq_out;

assign freq = freq_out;

initial begin
	count <= 26'b0;
	old_sig <= 1'b0;
	freq_out <= 12'b0;
	freq_count <= 12'b0;
	
end

always @(posedge mclk) begin
	count <= count + 1;
	if (signal != old_sig) begin
		freq_count = freq_count +1;
	end
	
	if (count == 50000000) begin
		freq_out = freq_count >> 1;
		count <= 0;
		freq_count = 0;
	end
	
	old_sig = signal;
end
	

endmodule

