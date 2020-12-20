`timescale 1ms / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:34:06 11/26/2020
// Design Name:   parking_meter
// Module Name:   /home/ise/ParkingMeterProj/testbench_105313948.v
// Project Name:  ParkingMeterProj
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: parking_meter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_parkingmeter;
	
	reg add1;
	reg add2;
	reg add3;
	reg add4;
	reg clk;
	reg rst;
	reg rst1;
	reg rst2;
	// Outputs
	wire [6:0] led_seg;
	wire a1;
	wire a2;
	wire a3;
	wire a4;
	wire [3:0] val1;
	wire [3:0] val2;
	wire [3:0] val3;
	wire [3:0] val4;

	// Instantiate the Unit Under Test (UUT)
	parking_meter uut ( .add1(add1), .add2(add2), .add3(add3), .add4(add4), .clk(clk),.rst(rst), .rst1(rst1), .rst2(rst2),
							  .led_seg(led_seg), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .val1(val1), .val2(val2), .val3(val3), .val4(val4));

	initial begin
		// Initialize Inputs
		// Wait 100 ns for global reset to finish
		clk=0; 
		add1=0;add2=0;add3=0;add4=0;
		rst1=0;rst2=0; rst=1;
		#20 rst=0;
		#5000 add3=1;
		#20 add3=0;
		#500 add4=1; 
		#20 add4=0;
		#2000 rst1=1;
		#20 rst1=0;
		#1000 add1=1;
		#20 add1=0;
		#500 rst2=1;
		#20 rst2=0;
		#1000 add2=1;
		#20 add2=0;
		#1000 rst=1;
		#20 rst=0;
		
		// Add stimulus here
	end
      
	always begin 
		#10 clk=~clk;
	end
	
	
endmodule

