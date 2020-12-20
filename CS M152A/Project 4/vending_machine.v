`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:52:55 12/12/2020 
// Design Name: 
// Module Name:    vending_machine 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vending_machine(
	input CLK,
	input RST,
	input RELOAD,
	input CARD_IN,
	input [3:0] ITEM_CODE,
	input KEY_PRESS,
	input VALID_TRAN,
	input DOOR_OPEN,
	output reg VEND,
	output reg INVALID_SEL,
	output reg [2:0] COST,
	output reg FAILED_TRAN
    );

reg [4:0] current_state;
reg [4:0] next_state;

parameter [3:0] initial_state = 4'b0000;
parameter [3:0] empty_state = 4'b0001;
parameter [3:0] stocked_state = 4'b0010;
parameter [3:0] firstinput_state = 4'b0011;
parameter [3:0] secondinput_state = 4'b0100;
parameter [3:0] validation_state = 4'b0101;
parameter [3:0] vend_state = 4'b0110;
parameter [3:0] door_open_state = 4'b0111;
parameter [3:0] invalid_state = 4'b1000;

reg [3:0] zeroctr;
reg [3:0] onectr;
reg [3:0] twoctr;
reg [3:0] threectr;
reg [3:0] fourctr;
reg [3:0] fivectr;
reg [3:0] sixctr;
reg [3:0] sevenctr;
reg [3:0] eightctr;
reg [3:0] ninectr;
reg [3:0] tenctr;
reg [3:0] elevenctr;
reg [3:0] twelvectr;
reg [3:0] thirteenctr;
reg [3:0] fourteenctr;
reg [3:0] fifteenctr;
reg [3:0] sixteenctr;
reg [3:0] seventeenctr;
reg [3:0] eighteenctr;
reg [3:0] nineteenctr;

reg [2:0] fivecyclectr;

reg [3:0] first_input = 0;
reg [3:0] tempfirst_input = 0;
reg [3:0] second_input = 0;

reg firstinputctr = 0;
reg firstinputctrforout = 0;
reg [3:0] prev_state;
reg [2:0] fivecycleadjust;
reg [2:0] vendctr;

initial begin
	current_state = initial_state;
end

always@(posedge CLK) begin
	current_state <= next_state;
end

always@(negedge CLK) begin
	if(next_state == initial_state) begin
		fivecyclectr = 0;
		prev_state = initial_state;
	end
	if(next_state == initial_state && prev_state == initial_state) begin
		fivecyclectr = 0;
	end
	
	if(next_state == firstinput_state && prev_state == initial_state) begin
		fivecyclectr = 0;
		fivecycleadjust = 0;
		prev_state = firstinput_state;
	end
	else if(next_state == firstinput_state && prev_state == firstinput_state) begin
		if(fivecycleadjust == 0) begin
			fivecyclectr = 0;
			fivecycleadjust=fivecycleadjust+1;
		end
		else if(fivecycleadjust >= 1)	
			fivecyclectr = fivecyclectr + 1;
	end
		
	if(next_state == secondinput_state && prev_state == firstinput_state) begin
		fivecyclectr = 0;
		prev_state = secondinput_state;
	end
	else if(next_state == secondinput_state && prev_state == secondinput_state) 
		fivecyclectr = fivecyclectr + 1;
		
	if(next_state == validation_state && prev_state == secondinput_state) begin
		fivecyclectr = 0;
		prev_state = validation_state;
	end
	else if(next_state == validation_state && prev_state == validation_state)
		fivecyclectr = fivecyclectr + 1;
		
	if(next_state == vend_state && prev_state == validation_state) begin
		fivecyclectr = 0;
		vendctr = 0;
		prev_state = vend_state;
	end
	else if(next_state == vend_state && prev_state == vend_state)  begin
		fivecyclectr = fivecyclectr + 1;
		vendctr = vendctr + 1;
	end
	
		
end

always@(*) begin
	case(current_state) 
		initial_state: begin
			firstinputctr = 0;
			
			if(RELOAD==1) 
				next_state = stocked_state;
			else if(RST)
				next_state = empty_state;
			else if(CARD_IN)
				next_state = firstinput_state;
			else 
				next_state = initial_state;
		end
		
		empty_state: begin 
			zeroctr=0; onectr=0; twoctr=0; threectr=0; fourctr=0; 
			fivectr=0; sixctr=0; sevenctr=0; eightctr=0; ninectr=0;
			tenctr=0; elevenctr=0; twelvectr=0; thirteenctr=0; fourteenctr=0;
			fifteenctr=0; sixteenctr=0; seventeenctr=0; eighteenctr=0; nineteenctr=0;
			if(RST==0)
				next_state = initial_state;
			else
				next_state = empty_state;
		end
		
		stocked_state: begin
			zeroctr=10; onectr=10; twoctr=10; threectr=10; fourctr=10; 
			fivectr=10; sixctr=10; sevenctr=10; eightctr=10; ninectr=10;
			tenctr=10; elevenctr=10; twelvectr=10; thirteenctr=10; fourteenctr=10;
			fifteenctr=10; sixteenctr=10; seventeenctr=10; eighteenctr=10; nineteenctr=10;
			if(RELOAD==0) 
				next_state = initial_state;
			else
				next_state = stocked_state;
		end
		
		firstinput_state: begin
			if(fivecyclectr == 5) 
				next_state = initial_state;
			else if(fivecyclectr < 5) begin
				if(KEY_PRESS==1) begin
					if(firstinputctr == 0) begin
						next_state = firstinput_state;
						firstinputctr=firstinputctr+1;
					end
					else if(firstinputctr == 1)
						next_state = secondinput_state;
				end
				else if(KEY_PRESS==0)
					next_state = firstinput_state;
			end
		end
		
		secondinput_state: begin
			if(fivecyclectr == 5) 
				next_state = initial_state;
			else if(fivecyclectr < 5) begin
				if(KEY_PRESS==0 && VALID_TRAN == 0) begin
					if(first_input > 1) 
						next_state = initial_state;
					else if(first_input == 0) begin
						if(second_input == 0) begin
							if(zeroctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 1) begin
							if(onectr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 2) begin
							if(twoctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 3) begin
							if(threectr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 4) begin
							if(fourctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 5) begin
							if(fivectr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 6) begin
							if(sixctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 7) begin
							if(sevenctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 8) begin
							if(eightctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 9) begin
							if(ninectr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
					end
					else if(first_input == 1) begin
						if(second_input == 0) begin
							if(tenctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 1) begin
							if(elevenctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 2) begin
							if(twelvectr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 3) begin
							if(thirteenctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 4) begin
							if(fourteenctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 5) begin
							if(fifteenctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 6) 
							if(sixteenctr == 0) next_state = initial_state;
							else next_state = validation_state;
						else if(second_input == 7) begin
							if(seventeenctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 8) begin
							if(eighteenctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						else if(second_input == 9) begin
							if(nineteenctr == 0) next_state = initial_state;
							else next_state = validation_state;
						end
						
					end
				end
				else if(KEY_PRESS==1) 
					next_state = secondinput_state;
			end
				
		end
		
		validation_state: begin
			if(fivecyclectr == 5) 
				next_state = invalid_state;
			else if(fivecyclectr < 5) begin
				if(VALID_TRAN)
					next_state = vend_state;
				else
					next_state = validation_state;
			end
		end
		
		vend_state: begin
			if(fivecyclectr == 5) 
				next_state = initial_state;
			else if(fivecyclectr < 5) begin			
				if(DOOR_OPEN)
					next_state = door_open_state;
				else if(vendctr == 1) begin
					if(first_input == 0) begin
						if(second_input == 0) 
							zeroctr = zeroctr - 1;
						if(second_input == 1) 
							onectr = onectr - 1;
						if(second_input == 2) 
							twoctr = twoctr -1;
						if(second_input == 3) 
							threectr = threectr - 1;
						if(second_input == 4) 
							fourctr = fourctr - 1;
						if(second_input == 5) 
							fivectr = fivectr - 1;
						if(second_input == 6) 
							sixctr = sixctr - 1;
						if(second_input == 7) 
							sevenctr = sevenctr - 1;
						if(second_input == 8) 
							eightctr = eightctr - 1;
						if(second_input == 9) 
							ninectr = ninectr - 1;
					end
					else if(first_input == 1) begin
						if(second_input == 0) 
							tenctr = tenctr - 1;
						if(second_input == 1) 
							elevenctr = elevenctr - 1;
						if(second_input == 2) 
							twelvectr = twelvectr -1;
						if(second_input == 3) 
							thirteenctr = thirteenctr - 1;
						if(second_input == 4) 
							fourteenctr = fourteenctr - 1;
						if(second_input == 5) 
							fifteenctr = fifteenctr - 1;
						if(second_input == 6) 
							sixteenctr = sixteenctr - 1;
						if(second_input == 7) 
							seventeenctr = seventeenctr - 1;
						if(second_input == 8) 
							eighteenctr = eighteenctr - 1;
						if(second_input == 9) 
							nineteenctr = nineteenctr - 1;
					end
				end
			end
			
		end
		
		door_open_state: begin
				if(DOOR_OPEN == 0) 
					next_state = initial_state;
				else if(DOOR_OPEN==1)
					next_state = door_open_state;
			end
		
		
		invalid_state: begin
			next_state = initial_state;
		end
		
	endcase
end


always@(*) begin
	case(current_state) 
		initial_state: begin
			VEND = 0; INVALID_SEL = 0; COST = 0; FAILED_TRAN = 0; 
		end
		
		empty_state: begin
			VEND = 0; INVALID_SEL = 0; COST = 0; FAILED_TRAN = 0; 
		end
		
		stocked_state: begin
			VEND = 0; INVALID_SEL = 0; COST = 0; FAILED_TRAN = 0; 
		end
		
		firstinput_state: begin
			VEND = 0; COST = 0; FAILED_TRAN = 0; 
			if(fivecyclectr == 5) begin
				INVALID_SEL = 1;
			end
			else if(fivecyclectr < 5) begin
				if(KEY_PRESS==1) begin 
					if(firstinputctrforout == 0) begin
						firstinputctrforout = firstinputctrforout + 1;
						tempfirst_input = ITEM_CODE;
						INVALID_SEL = 0;
					end
					else if(firstinputctrforout == 1) begin
						first_input = tempfirst_input;
						INVALID_SEL = 0;
					end
				end
				else begin
					tempfirst_input = ITEM_CODE;
					INVALID_SEL = 0;
				end
			end
		end
		
		secondinput_state: begin
			VEND = 0; FAILED_TRAN = 0; 
			if(fivecyclectr == 5) begin
				INVALID_SEL = 1;
				COST = 0;
			end
			if(fivecyclectr < 5) begin
				if(KEY_PRESS==0) 
					INVALID_SEL = 0;
				else if(KEY_PRESS==1) begin
				   if(first_input != 1 && first_input != 0) begin
						INVALID_SEL = 1;
						COST = 0;
					end
					if(first_input == 0) begin
						second_input = ITEM_CODE;
						if(second_input == 0) begin
							if(zeroctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 1; end
						end
						else if(second_input == 1) begin
							if(onectr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 1; end
						end
						else if(second_input == 2) begin
							if(twoctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 1; end
						end
						else if(second_input == 3) begin
							if(threectr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 1; end
						end
						else if(second_input == 4) begin
							if(fourctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 2; end
						end
						else if(second_input == 5) begin
							if(fivectr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 2; end
						end
						else if(second_input == 6) begin
							if(sixctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 2; end
						end
						else if(second_input == 7) begin
							if(sevenctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 2; end
						end
						else if(second_input == 8) begin
							if(eightctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 3; end
						end
						else if(second_input == 9) begin
							if(ninectr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 3; end
						end
					end
					
					else if(first_input == 1) begin
						second_input = ITEM_CODE;
						if(second_input == 0) begin
							if(tenctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 3; end
						end
						else if(second_input == 1) begin
							if(elevenctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 3; end
						end
						else if(second_input == 2) begin
							if(twelvectr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 4; end
						end
						else if(second_input == 3) begin
							if(thirteenctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 4; end
						end
						else if(second_input == 4) begin
							if(fourteenctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 4; end
						end
						else if(second_input == 5) begin
							if(fifteenctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 4; end
						end
						else if(second_input == 6) begin
							if(sixteenctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 5; end
						end
						else if(second_input == 7) begin
							if(seventeenctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 5; end
						end
						else if(second_input == 8) begin
							if(eighteenctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 6; end
						end
						else if(second_input == 9) begin
							if(nineteenctr == 0) begin INVALID_SEL = 1; COST = 0; end
							else begin INVALID_SEL = 0; COST = 6; end
						end
					end
				end
				
			
			end
		end
		
		validation_state: begin
			VEND = 0; INVALID_SEL = 0; 
			if(fivecyclectr == 5) 
				FAILED_TRAN=1;
			else if(fivecyclectr < 5) begin
				if(VALID_TRAN) begin
					FAILED_TRAN = 0;
					VEND = 1;
				end
			end
		end
		
		vend_state: begin
			INVALID_SEL = 0; FAILED_TRAN = 0; VEND = 1; 
			if(fivecyclectr == 5) 
				VEND = 0; 
			else
				VEND = 1;
		end
		
		door_open_state: begin
			INVALID_SEL = 0; FAILED_TRAN = 0; 
			if(DOOR_OPEN == 0)
				VEND = 0;
			else
				VEND = 1;
		end
		
		invalid_state: begin 
			INVALID_SEL = 0; COST = 0; VEND = 0; FAILED_TRAN = 1;
		end
		
		
	endcase
end
endmodule
