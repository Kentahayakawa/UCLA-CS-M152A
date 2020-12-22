`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:36:13 10/27/2020
// Design Name:   counter
// Module Name:   /home/ise/Counters/testbench_clockgen.v
// Project Name:  Counters
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_clockgen;

	// Inputs
	reg clk_in;
	reg rst;

	// Outputs
   wire clk_div_2, clk_div_4, clk_div_8, clk_div_16, clk_div_28, clk_div_5;
	wire [7:0] toggle_counter;

	// Instantiate the Unit Under Test (UUT)
	clock_gen uut (
		.clk_in(clk_in), 
		.rst(rst), 
		.clk_div_2(clk_div_2),
		.clk_div_4(clk_div_4),
		.clk_div_8(clk_div_8),
		.clk_div_16(clk_div_16),
		.clk_div_28(clk_div_28),
		.clk_div_5(clk_div_5),
		.toggle_counter(toggle_counter)
	);

	initial begin
		// Initialize Inputs
		clk_in = 0;
		rst = 1;
		
		#20;        
		rst = 0; 

	end
	
	always begin 	
	#10  clk_in = ~clk_in;
	end 
	
	
      
endmodule
