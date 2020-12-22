`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: UCLA
// Engineer: Kenta Hayakawa
//
// Create Date:   22:30:27 10/23/2020
// Design Name:   FPCVT
// Module Name:   /home/ise/Project1/testbench_FPCVT.v
// Project Name:  Project1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCVT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_FPCVT;

	// Inputs
	reg [12:0] encoding;

	// Outputs
	wire sign;
	wire [2:0] exp;
	wire [4:0] sig;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
		.D(encoding), 
		.S(sign), 
		.E(exp), 
		.F(sig)
	);

	initial begin
		// Initialize Inputs
		encoding = 0; // 0
		// Wait 100 ns for global reset to finish
		#20;
		encoding = 1;
		#20;
		encoding = 10; // 10
		#20;
		encoding = 20; // 20 
		#20;
      encoding = 30; // 30
		#20;
		encoding = 40; // 40
		#20;
		encoding = 0; // 0
		#20;
		encoding = -400; // -40
		#20;
		encoding = 50; // 56
		#20;
		encoding = 100; // 128
		#20;
		encoding = 253; // 128
		#20;
		encoding = 4095;
		#20;
		encoding = -4096; //edge
		#20;
		encoding = 13'b0000000001111; //edge
		#20;
		encoding = 13'b0000011111101; //edge
		#20;
		encoding = 13'b0111111111111; //edge
		#20;
		encoding = 0;
	end
      
endmodule

