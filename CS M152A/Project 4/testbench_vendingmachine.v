`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:53:38 12/12/2020
// Design Name:   vending_machine
// Module Name:   /home/ise/FinalProj/testbench_105313948.v
// Project Name:  FinalProj
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vending_machine
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module testbench_vendingmachine;

	reg CLK;
	reg RST;
	reg RELOAD;
	reg CARD_IN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg VALID_TRAN;
	reg DOOR_OPEN;
	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire [2:0] COST;
	wire FAILED_TRAN;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CLK(CLK), .RST(RST), .RELOAD(RELOAD), .CARD_IN(CARD_IN), .ITEM_CODE(ITEM_CODE), .KEY_PRESS(KEY_PRESS), .VALID_TRAN(VALID_TRAN), 
		.DOOR_OPEN(DOOR_OPEN), .VEND(VEND), .INVALID_SEL(INVALID_SEL), .COST(COST), .FAILED_TRAN(FAILED_TRAN)
	);

	initial begin
		// Initialize Inputs

		// Wait 100 ns for global reset to finish
		CLK=0; RST=0; RELOAD=0; CARD_IN=0; ITEM_CODE=0; KEY_PRESS=0; VALID_TRAN=0;
		DOOR_OPEN=0; 
        
		#30 RELOAD = 1;
		#20 RELOAD = 0;
		#30 CARD_IN=1;
		#20 ITEM_CODE=1; KEY_PRESS=1;
		#20 KEY_PRESS=0;
		#30 ITEM_CODE=6; KEY_PRESS=1;
		#20 KEY_PRESS=0;
		#10 CARD_IN = 0;
		#30 VALID_TRAN=1;
		#20 VALID_TRAN=0;
		#20 DOOR_OPEN=1;
		#20 DOOR_OPEN = 0;
		
		#140 RELOAD = 1;
		#20 RELOAD = 0;
		#30 CARD_IN=1;
		#20 ITEM_CODE=1; KEY_PRESS=1;
		#20 KEY_PRESS=0;
		#30 ITEM_CODE=6; KEY_PRESS=1;
		#20 KEY_PRESS = 0; 
		#10 CARD_IN = 0;
		#30 VALID_TRAN = 1;
		#20 VALID_TRAN = 0;
		
		#140 RELOAD = 1;
		#20 RELOAD = 0;
		#30 CARD_IN=1;
		#20 ITEM_CODE=1; KEY_PRESS=1;
		#20 KEY_PRESS=0;
		#30 ITEM_CODE=6; KEY_PRESS=1;
		#20 KEY_PRESS = 0; 
		#10 CARD_IN = 0;
		
		#140 RST = 1;
		#20 RST = 0;
		#30 CARD_IN=1;
		#20 ITEM_CODE=1; KEY_PRESS=1;
		#20 KEY_PRESS=0;
		#30 ITEM_CODE=6; KEY_PRESS=1;
		#20 KEY_PRESS = 0; 
		#10 CARD_IN = 0;
		
		#140 RELOAD = 1;
		#20 RELOAD = 0;
		#30 CARD_IN=1;
		#20 ITEM_CODE=2; KEY_PRESS=1;
		#20 KEY_PRESS=0;
		#30 ITEM_CODE=6; KEY_PRESS=1;
		#20 KEY_PRESS = 0; 
		#10 CARD_IN = 0;
		
		#140 RELOAD = 1;
		#20 RELOAD = 0;
		#30 CARD_IN=1;
		#20 ITEM_CODE=2; KEY_PRESS=1;
		#20 KEY_PRESS = 0;
		#120 CARD_IN = 0;
		
		#140 RELOAD = 1;
		#20 RELOAD = 0;
		#30 CARD_IN=1;
		#120 CARD_IN = 0;
		
		
		
		
		
		
		// Add stimulus here

	end
	
	always begin
		#10 CLK=~CLK;
	end
      
endmodule