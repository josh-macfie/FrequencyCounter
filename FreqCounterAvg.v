`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Joshua MacFie
// 
// Create Date:    21:00:46 1/23/2015
// Design Name: 	 
// Module Name:    FreqCount 
// Project Name: 	 mini project lab 1
// Target Devices: Basys2 board
// Tool versions:  ISE 14.7
// Description: 	This module was written to gather a square wave signal
// and compare it to the clock in order to gather frequency information.
//
// Dependencies: 
//
// Revision: 1.3 Shifted frequency averaging to include old readings
//	Revision: 1.2 addded frequency averaging capability
// Revision: 1.1 changed counter run time to match circuit clock
// Revision 1.0 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module FreqCounter(
	 //Clock input pin B8
	 input mclk,
	 //signal input pin B2
	 input signal,
	 //binary frequency module output
	 output [15:0] freq
    );
parameter countTo = 55000000; //50,000,000 is about 1 sec

//Set up registers
// These registers are used to count, avg, and tie the frequency to the output
reg [15:0] freq_count;
reg [15:0] freq_out;
reg [15:0] freqHold0;
reg [15:0] freqHold1;
reg [15:0] freqHold2;
reg [15:0] freqHold3;
reg [15:0] freqHold4;
reg [15:0] freqHold5;
reg [15:0] freqHold6;
reg [15:0] freqHold7;
reg [15:0] freqHold8;
reg [15:0] freqHold9;
reg [15:0] freqHold10;
reg [15:0] freqHold11;
reg [15:0] freqHold12;
reg [15:0] freqHold13;
reg [15:0] freqHold14;
reg [15:0] freqHold15;


// This register is used to create a count timing to compare the signal to
reg [25:0] count;

//This register is used for comparison of the signal from cycle to cycle
reg old_sig;

//this register used to debounce the incoming signal
reg [4:0] debounce_sig;

//this register is used to keep track of different readings over time
reg [2:0] avClk;

reg [18:0] freqTemp;

//Initializing regs to 0 to prevent float error
initial begin
	count = 26'b0;
	old_sig = 1'b0;
	freq_out = 16'b0;
	freq_count = 16'b0;
	avClk = 3'b0;
	freqTemp = 19'b0;
	freqHold0 = 16'b0;
	freqHold1 = 16'b0;
	freqHold2 = 16'b0;
	freqHold3 = 16'b0;
	freqHold4 = 16'b0;
	freqHold5 = 16'b0;
	freqHold6 = 16'b0;
	freqHold7 = 16'b0;
	freqHold8 = 16'b0;
	freqHold9 = 16'b0;
	freqHold10 = 16'b0;
	freqHold11 = 16'b0;
	freqHold12 = 16'b0;
	freqHold13 = 16'b0;
	freqHold14 = 16'b0;
	freqHold15 = 16'b0;

end



always @(posedge mclk) begin
	//Increment count once per up clock edge
	count = count + 1;
	
	//shift the signal into debounce_sig up to 8 bits
	debounce_sig[0] = signal;
	debounce_sig = debounce_sig << 1;
	
	//If debounce_sig is filled with ones or zeros
	if ((&debounce_sig) | (~&debounce_sig))begin
	
	//If the incoming signal does not match the previous clock cycle signal add one
	// to the frequency count. Note this results in a count twice per period.
	// thiss is dealt with later in the loop with a shift right ">>"

		if (signal != old_sig) begin
			freq_count = freq_count +1;
		end
	end
	
	//When the count is at approximately 1 sec (as close as the clock will get)
	// output the shifted count and reset values counts to 0
	if (count >= (countTo >> 4)) begin
		freq_out = freq_count << 3;// >> 1;
		count = 0;
		freq_count = 0;
		avClk = avClk + 1;
	end

	case (avClk)
		0 : freqHold0 = freq_out;
		1 : freqHold1 = freq_out;
		2 : freqHold2 = freq_out;
		3 : freqHold3 = freq_out;
		4 : freqHold4 = freq_out;
		5 : freqHold5 = freq_out;
		6 : freqHold6 = freq_out;
		7 : begin
				freqHold7 = freq_out;
				//Adding all frequency readings
				freqTemp = freqHold0 + freqHold1 + freqHold2 + freqHold3 +freqHold4 + freqHold5 + freqHold6 + freqHold7+freqHold8 + freqHold9 + freqHold10 + freqHold11 +freqHold12 + freqHold13 + freqHold14 + freqHold15;
			 end

		default :;
	endcase
	
	//Setting up old signal for next clock pulse comparison
	old_sig = signal;
	

	//Holding old readings to mix with new
	freqHold8 = freqHold0;
	freqHold9 = freqHold1;
	freqHold10 = freqHold2;
	freqHold11 = freqHold3;
	freqHold12 = freqHold4;
	freqHold13 = freqHold5;
	freqHold14 = freqHold6;
	freqHold15 = freqHold7;
end


	//Tying the output register to the module output

	assign freq =  freqTemp >> 4;
	
endmodule
