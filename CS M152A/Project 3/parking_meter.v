`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:33:28 11/26/2020 
// Design Name: 
// Module Name:    parking_meter 
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
module parking_meter(
    input add1,
    input add2,
    input add3,
    input add4,
    input rst1,
    input rst2,
    input clk,     //100 Hz
    input rst,
    output [6:0] led_seg,
    output a1,
    output a2,
    output a3,
    output a4,
    output [3:0] val1,
    output [3:0] val2,
    output [3:0] val3,
    output [3:0] val4
    );


reg [13:0] time_left;
reg [3:0] dig1; reg [3:0] dig2; reg [3:0] dig3; reg [3:0] dig4;

sevenseg s1(.time_left(time_left), .dig1(dig1), .dig2(dig2), .dig3(dig3), .dig4(dig4), .rst(rst), .clk(clk), 
				.led_seg(led_seg), .a1(a1), .a2(a2), .a3(a3), .a4(a4));
BCDencoder encoder(.dig1(dig1), .dig2(dig2), .dig3(dig3), .dig4(dig4), .clk(clk), .rst(rst), .val1(val1), .val2(val2), .val3(val3), .val4(val4));

reg [5:0] round;
always@(posedge clk or negedge clk) begin
	if(rst) begin
		round<=0; 
		time_left<=0;
		dig1<=0; dig2<=0; dig3<=0; dig4<=0;
	end
	else begin
	if(add1) begin
		if((round)%2!=0) begin
			time_left<=time_left+60;
			dig2<=dig2+6;
			if(dig2 > 9) begin 
				case(dig2) 
					5'b01010: begin dig2<=0; end
					5'b01011: begin dig2<=1; end
					5'b01100: begin dig2<=2; end
					5'b01101: begin dig2<=3; end
					5'b01110: begin dig2<=4; end
					5'b01111: begin dig2<=5; end
				endcase
				dig3<=dig3+1;
				if(dig3 > 9) begin 
					dig3<=0;
					dig4<=dig4+1;
					if(dig4 > 9) begin dig4<=9; end
				end
			end
		end
	end
	
	if(add2) begin
		if((round)%2!=0) begin
		time_left<=time_left+120;
		dig2<=dig2+2;
		if(dig2 > 9) begin
			case(dig2) 
				5'b01010: begin dig2<=0; end
				5'b01011: begin dig2<=1; end
			endcase
			dig3<=dig3+2;
			if(dig3 > 9) begin 
				case(dig3)
					5'b01010: begin dig3<=0; end
					5'b01011: begin dig3<=1; end
				endcase
				dig4<=dig4+1;
				if(dig4 > 9) begin dig4<=9; end
			end
		end
		dig3<=dig3+1;
		if(dig3 > 9) begin 
			dig3<=0;
			dig4<=dig4+1;
			if(dig4 > 9) begin dig4<=9; end
		end
	end
end
	
	if(add3) begin
	if((round)%2!=0) begin
		time_left<=time_left+180;
		dig2<=dig2+8;
		if(dig2 > 9) begin
			case(dig2) 
				5'b01010: begin dig2<=0; end
				5'b01011: begin dig2<=1; end
				5'b01100: begin dig2<=2; end
				5'b01101: begin dig2<=3; end
				5'b01110: begin dig2<=4; end
				5'b01111: begin dig2<=5; end
				5'b10000: begin dig2<=6; end
				5'b10001: begin dig2<=7; end
			endcase
			dig3<=dig3+2;
			if(dig3 > 9) begin 
				case(dig3)
					5'b01010: begin dig3<=0; end
					5'b01011: begin dig3<=1; end
				endcase
				dig4<=dig4+1;
				if(dig4 > 9) begin dig4<=9; end
			end
		end
		dig3<=dig3+1;
		if(dig3 > 9) begin 
			dig3<=0;
			dig4<=dig4+1;
			if(dig4 > 9) begin dig4<=9; end
		end
	end
end
	if(add4) begin
	if((round)%2!=0) begin
		time_left<=time_left+300;
		dig3<=dig3+3;
		if(dig3 > 9) begin
			case (dig3)
				5'b01010: begin dig2<=0; end
				5'b01011: begin dig2<=1; end
				5'b01100: begin dig2<=2; end
			endcase
			dig4<=dig4+1;
			if(dig4 > 9) begin dig4<=9; end
		end	
	end
end
	if(rst1) begin
		time_left<=16;
		dig1<=6; dig2<=1; dig3<=0; dig4<=0;
	end
	if(rst2) begin
		time_left<=150;
		dig1<=0; dig2<=5; dig3<=1; dig4<=0;
	end
	
	if(round > 48) begin
		round<=0;
		if(add1==0 && add2==0 && add3==0 && add4==0 && rst1==0 && rst2==0 && rst==0) begin
			if(dig1==0 && (dig2!=0 || dig3!=0 || dig4!=0)) begin
				time_left<=time_left-1;
				dig1<=9; 
				if(dig2==0) begin dig2<=9; end
				else begin dig2<=dig2-1; end
			end
			else if(dig1!=0)begin
				time_left <= time_left-1;
				dig1<=dig1-1;
			end
		 end
	end
	else begin round<=round+1; end
	end
end
endmodule


module sevenseg(time_left, dig1, dig2, dig3, dig4, rst, clk, led_seg, a1, a2, a3, a4);
input [13:0] time_left;
input [3:0] dig1; input [3:0] dig2; input [3:0] dig3; input [3:0] dig4;
input clk;
input rst;
output reg [6:0] led_seg = 0;
output reg a1; output reg a2; output reg a3; output reg a4;

function [6:0] ledsegdisplay; 
input [3:0] digit; 
case(digit)
	4'b0000: begin ledsegdisplay=7'b0000001; end
	4'b0001: begin ledsegdisplay=7'b1001111; end
	4'b0010: begin ledsegdisplay=7'b0010010; end
	4'b0011: begin ledsegdisplay=7'b0000110; end
	4'b0100: begin ledsegdisplay=7'b1001100; end
	4'b0101: begin ledsegdisplay=7'b0100100; end
	4'b0110: begin ledsegdisplay=7'b0100000; end
	4'b0111: begin ledsegdisplay=7'b0001111; end
	4'b1000: begin ledsegdisplay=7'b0000000; end
	4'b1001: begin ledsegdisplay=7'b0000100; end
endcase
endfunction

// update count 
// overflow from 3 to 0
reg [1:0] count;
reg [6:0] zeroCt = 0;
reg [1:0] dosCt=0;
reg [6:0] dosRoundCt = 0;
reg [5:0] posedgectr = 0;

always@(posedge clk or negedge clk) begin 
	if(rst) begin 
		count <= 0; 
		zeroCt<=0;
		posedgectr<=0;
		dosCt<=0;
	end 
	else begin
	if(zeroCt < 49) begin
		case(count)
			0: begin a1 = 0; a2 = 1; a3 = 1; a4 = 1; led_seg = ledsegdisplay(dig1); end
			1: begin a1 = 1; a2 = 0; a3 = 1; a4 = 1; led_seg = ledsegdisplay(dig2); end
			2: begin a1 = 1; a2 = 1; a3 = 0; a4 = 1; led_seg = ledsegdisplay(dig3); end
			3: begin a1 = 1; a2 = 1; a3 = 1; a4 = 0; led_seg = ledsegdisplay(dig4); end
		endcase
	end
	
	else if(zeroCt >= 49 && zeroCt < 98) begin
		case(count)
			0: begin a1 = 0; a2 = 1; a3 = 1; a4 = 1; led_seg = 7'b1111111; end
			1: begin a1 = 1; a2 = 0; a3 = 1; a4 = 1; led_seg = 7'b1111111; end
			2: begin a1 = 1; a2 = 1; a3 = 0; a4 = 1; led_seg = 7'b1111111; end
			3: begin a1 = 1; a2 = 1; a3 = 1; a4 = 0; led_seg = 7'b1111111; end
		endcase
	end
		if(zeroCt == 98) begin zeroCt<=0; count<=0; end
		else begin
			count <= count + 1;
			zeroCt<=zeroCt + 1;
			posedgectr<=posedgectr+1;
		end  
		
		if(time_left==180) begin
			dosCt<=dosCt+1;
			if(dosRoundCt == 0) begin
		a1=0;a2=1;a3=1;a4=1; led_seg=ledsegdisplay(dig1);
		case(count) 
			1: begin a1 = 1; a2 = 0; a3 = 1; a4 = 1; led_seg = ledsegdisplay(dig2); end
			2: begin a1 = 1; a2 = 1; a3 = 0; a4 = 1; led_seg = ledsegdisplay(dig3); end
			3: begin a1=1; a2=1; a3=1; a4=0; led_seg=ledsegdisplay(dig4); end
		endcase
	end
			
		
	else if(dosRoundCt > 0 && dosRoundCt < 90) begin
		case(count)
			0: begin a1=0;a2=1;a3=1;a4=1; led_seg=ledsegdisplay(dig1);  end
			1: begin a1 = 1; a2 = 0; a3 = 1; a4 = 1; led_seg = ledsegdisplay(dig2); end
			2: begin a1 = 1; a2 = 1; a3 = 0; a4 = 1; led_seg = ledsegdisplay(dig3); end
			3: begin a1=1; a2=1; a3=1; a4=0; led_seg=ledsegdisplay(dig4); end
		endcase
	end
	
			if(dosRoundCt==98) begin dosRoundCt<=0; dosCt<=0; end
			else begin
				dosRoundCt<=dosRoundCt+1;
				posedgectr<=posedgectr+1;
			end
		end
		if(time_left < 180 && time_left > 0) begin
			dosCt<=dosCt+1;
			if((time_left)%2 == 0 && dosRoundCt==0) begin 
				a1=0; a2=1; a3=1; a4=1; led_seg=ledsegdisplay(dig1); 
				case(count)
				1: begin a1 = 1; a2 = 0; a3 = 1; a4 = 1; led_seg=ledsegdisplay(dig2); end
				2: begin a1 = 1; a2 = 1; a3 = 0; a4 = 1; led_seg=ledsegdisplay(dig3); end
				3: begin a1=1; a2=1; a3=1; a4=0; led_seg=ledsegdisplay(dig4); end
				endcase
			end
			else if((time_left)%2 == 0 && dosRoundCt > 0 && dosRoundCt < 98) begin
			a1=0;a2=1;a3=1;a4=1;led_seg=7'b1111111; 
			case(count)
			1: begin a1 = 1; a2 = 0; a3 = 1; a4 = 1; led_seg=ledsegdisplay(dig2);end
			2: begin a1 = 1; a2 = 1; a3 = 0; a4 = 1; led_seg=ledsegdisplay(dig3);end
			3: begin a1=1; a2=1; a3=1; a4=0; led_seg=ledsegdisplay(dig4);end
			endcase		
			end
			else begin
			a1=0;a2=1;a3=1;a4=1;led_seg=7'b1111111; 
		case(count)
			1: begin a1 = 1; a2 = 0; a3 = 1; a4 = 1; led_seg=7'b1111111; end
			2: begin a1 = 1; a2 = 1; a3 = 0; a4 = 1; led_seg=7'b1111111;  end
			3: begin a1=1; a2=1; a3=1; a4=0; led_seg=7'b1111111;  end
			endcase
	end
			if(dosRoundCt==98) begin dosRoundCt<=0; dosCt<=0; end
			else begin
				dosRoundCt<=dosRoundCt+1;
				posedgectr<=posedgectr+1;
			end
		end
		else if(time_left > 180 && time_left < 10000) begin
		a1=0;a2=1;a3=1;a4=1;led_seg=ledsegdisplay(dig1); 
			case(count)
			1: begin a1 = 1; a2 = 0; a3 = 1; a4 = 1; led_seg=ledsegdisplay(dig2); end
			2: begin a1 = 1; a2 = 1; a3 = 0; a4 = 1; led_seg=ledsegdisplay(dig3); end
			3: begin a1=1; a2=1; a3=1; a4=0; led_seg=ledsegdisplay(dig4);  end
			endcase
	end
	end
end

endmodule

module BCDencoder(dig1, dig2, dig3, dig4, clk, rst, val1, val2, val3, val4); 
input [3:0] dig1; input [3:0] dig2; input [3:0] dig3; input [3:0] dig4;
input clk;
input rst;
output reg [3:0] val1; output reg [3:0] val2; output reg [3:0] val3; output reg [3:0] val4;

always@(posedge clk) begin
	if(rst) begin
		val1<=0; val2<=0; val3<=0; val4<=0; 
	end
	else begin
	val1<=dig1;
	val2<=dig2;
	val3<=dig3;
	val4<=dig4;
	end
end


endmodule
