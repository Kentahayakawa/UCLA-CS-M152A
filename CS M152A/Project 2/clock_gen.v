`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:30:07 11/06/2020 
// Design Name: 
// Module Name:    clock_gen 
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
module clock_gen(input clk_in, input rst, output clk_div_2, output clk_div_4, output clk_div_8, 
                 output clk_div_16, output clk_div_28, output clk_div_5, output [7:0] toggle_counter);

clock_div_two task_one(.clk_in(clk_in), .rst(rst), .clk_div_2(clk_div_2), .clk_div_4(clk_div_4), .clk_div_8(clk_div_8), .clk_div_16(clk_div_16));
clock_div_twenty_eight task_two(.clk_in(clk_in), .rst(rst), .clk_div_28(clk_div_28));
clock_div_five task_three(.clk_in(clk_in), .rst(rst), .clk_div_5(clk_div_5));
clock_strobe task_four(.clk_in(clk_in), .rst(rst), .toggle_counter(toggle_counter));
endmodule

module clock_div_two(clk_in, rst, clk_div_2, clk_div_4, clk_div_8, clk_div_16);
input clk_in, rst;
output reg clk_div_2, clk_div_4, clk_div_8, clk_div_16;


always @ (posedge clk_in) begin
	if(rst) begin
		clk_div_2<=0;
	end
	else begin
		clk_div_2<=clk_div_2+1;
	end
end

always @ (posedge clk_div_2, posedge rst) begin
	if(rst) begin
		clk_div_4<=0;
	end
	else begin
		clk_div_4<=clk_div_4+1;
	end
end
	
	always @ (posedge clk_div_4, posedge rst) begin
	if(rst) begin
		clk_div_8<=0;
	end
	else begin
		clk_div_8<=clk_div_8+1;
	end
end

	always @ (posedge clk_div_8, posedge rst) begin
	if(rst) begin
		clk_div_16<=0;
	end
	else begin
		clk_div_16<=clk_div_16+1;
	end
end


endmodule


module clock_div_twenty_eight(clk_in, rst, clk_div_28);
input clk_in, rst;
output reg clk_div_28;
reg [3:0] counter;

always @ (posedge clk_in) begin
	if(rst) begin
		clk_div_28<=0;
		counter<=0;
	end
	else begin
		counter<=counter+1;
		if(counter==13) begin
			clk_div_28<=~clk_div_28;
			counter<=0;
		end
	end
end
endmodule


module clock_div_five(clk_in, rst, clk_div_5);
input clk_in, rst;
output reg clk_div_5;
reg [2:0] ctr;
reg[2:0] roundctr;
reg[2:0] ctr2;
reg [2:0] roundctr2;

always @ (posedge clk_in) begin
	if(rst) begin
		clk_div_5<=0;
		ctr<=0;
		roundctr<=0;
	end
	else begin
		if(ctr==0 && roundctr==4) begin
			roundctr<=roundctr+1;
		end
		else if(ctr==0 && roundctr==0) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr==1 && roundctr==1) begin
			roundctr<=roundctr+1;
		end
		else if(ctr==1 && roundctr==5) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr==2 && roundctr==6) begin
			roundctr<=roundctr+1;
		end
		else if(ctr==2 && roundctr==2) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr==3 && roundctr==3) begin
			roundctr<=roundctr+1;
		end
		else if(ctr==3 && roundctr==7) begin
			clk_div_5<=~clk_div_5;
		end
		
		if(ctr==4 && roundctr==0) begin
			roundctr<=roundctr+1;
		end
		else if(ctr==4 && roundctr==4) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr==5 && roundctr==5) begin
			roundctr<=roundctr+1;
		end
		else if(ctr==5 && roundctr==1) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr==6 && roundctr==2) begin
			roundctr<=roundctr+1;
		end
		else if(ctr==6 && roundctr==6) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr==7 && roundctr==7) begin
			roundctr<=roundctr+1;
		end
		else if(ctr==7 && roundctr==3) begin
			clk_div_5<=~clk_div_5;
		end
		
		ctr<=ctr+1;
		
		if(ctr==8) begin
			ctr<=0;
		end
		if(roundctr==8) begin
			roundctr<=0;
		end
	end
end


always @ (negedge clk_in) begin
	if(rst) begin
		clk_div_5<=0;
		ctr2<=0;
		roundctr2<=0;
	end
	else begin
		if(ctr2==0 && roundctr2==4) begin
			roundctr2<=roundctr2+1;
		end
		else if(ctr2==0 && roundctr2==1) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr2==1 && roundctr2==1) begin
			roundctr2<=roundctr2+1;
		end
		else if(ctr2==1 && roundctr2==6) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr2==2 && roundctr2==6) begin
			roundctr2<=roundctr2+1;
		end
		else if(ctr2==2 && roundctr2==3) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr2==3 && roundctr2==3) begin
			roundctr2<=roundctr2+1;
		end
		else if(ctr2==3 && roundctr2==0) begin
			clk_div_5<=~clk_div_5;
		end
		
		if(ctr2==4 && roundctr2==0) begin
			roundctr2<=roundctr2+1;
		end
		else if(ctr2==4 && roundctr2==5) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr2==5 && roundctr2==5) begin
			roundctr2<=roundctr2+1;
		end
		else if(ctr2==5 && roundctr2==2) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr2==6 && roundctr2==2) begin
			roundctr2<=roundctr2+1;
		end
		else if(ctr2==6 && roundctr2==7) begin
			clk_div_5<=~clk_div_5;
		end
		if(ctr2==7 && roundctr2==7) begin
			roundctr2<=roundctr2+1;
		end
		else if(ctr2==7 && roundctr2==4) begin
			clk_div_5<=~clk_div_5;
		end
		
		ctr2<=ctr2+1;
		
		if(ctr2==8) begin
			ctr2<=0;
		end
		if(roundctr2==8) begin
			roundctr2<=0;
		end
	end
end

endmodule

module clock_strobe(clk_in, rst, toggle_counter);
	input clk_in, rst;
	output reg [7:0] toggle_counter;
	
	reg clk_strobe;
	reg [3:0] counter;
	
	always @ (posedge clk_in) begin //first always block, generates strobe
		if(rst) begin
			clk_strobe<=0;
			counter<=0;
		end
		else begin
			counter<=counter+1;
			if(counter==3) begin
				clk_strobe=~clk_strobe; 
			end
			if(counter==4) begin
				clk_strobe=~clk_strobe;
				counter<=1;
			end
		end
	end
	
	
	
	always @ (posedge clk_in) begin //second always block for final output 
		if(rst) begin
			toggle_counter<=0;
		end
		else begin
			toggle_counter<=toggle_counter+2;
		   if(clk_strobe) begin
				toggle_counter<=toggle_counter-5;
		   end
		end
	end
	
endmodule

