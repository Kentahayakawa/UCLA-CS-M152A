`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCLA
// Engineer: Kenta Hayakawa
// 
// Create Date:    22:26:00 10/23/2020 
// Design Name: 
// Module Name:    FPCVT 
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


module FPCVT (D, S, E, F);

   input wire [12:0] D;
   output wire S;
   output wire [2:0] E;
   output wire [4:0] F;
	assign S = D[12];

   wire [12:0] convertedSignMag;
	wire [5:0] initialSig;
   wire [2:0] initialExp;
	
   signmagconverter convert(.encoding(D), .sign(S), .convertedOutput(convertedSignMag));
   initialExpSig getinitialExpSig(.convertedInput(convertedSignMag), .initialSig(initialSig), .initialExp(initialExp));
   rounder round(.initialSig(initialSig), .initialExp(initialExp), .finalSig(F), .finalExp(E));

endmodule



module signmagconverter(encoding, sign, convertedOutput);
  
  input [12:0] encoding;
  input sign; 
  output [12:0] convertedOutput;
  reg [12:0] convTemp;
  
  always @ (*) begin
	 convTemp = convertedOutput;
	 if(sign == 1) begin
	   if(encoding == -13'b1000000000000) begin
			convTemp = 13'b0111111111111; 
      end
		else begin
      convTemp = (~encoding) + 1; 
		end
    end
    else begin
       convTemp = encoding; 
     end
   end
	
	assign convertedOutput = convTemp;
	
endmodule




module initialExpSig(convertedInput,initialExp, initialSig);
  
  input [12:0] convertedInput;
  output [2:0] initialExp;
  output [5:0] initialSig;
  reg [2:0] initialExpTemp;
  reg [5:0] initialSigTemp;
  reg [4:0] fivebitSig;
  reg [12:0] pretruncated;
  reg [3:0] numzero;
  reg [2:0] shift;
  
  always @ (*) begin
      initialExpTemp = 0;
		initialSigTemp = 0;
		numzero = 0;
		shift = 0;
      if (convertedInput[12] == 0) begin
			numzero = numzero + 1;
			if (convertedInput[11] == 0) begin
				numzero = numzero + 1;
				if (convertedInput[10] == 0) begin
					numzero = numzero + 1;
					if (convertedInput[9] == 0) begin
						numzero = numzero + 1;
						if (convertedInput[8] == 0) begin
							numzero = numzero + 1;
							if (convertedInput[7] == 0) begin
								numzero = numzero + 1;
								if (convertedInput[6] == 0) begin
									numzero = numzero + 1;
									if (convertedInput[5] == 0) begin
										numzero = numzero + 1;
										end
								   end
								end
							end
						end
					end
				end
			end
		
		if (numzero >= 8) begin
			numzero = 8;
		end
		shift = 13 - (numzero + 6);
		if (numzero == 8) begin
			fivebitSig = convertedInput[4:0];
			initialSigTemp = {fivebitSig, 1'b0};
		end
		else begin
			pretruncated = convertedInput >> shift;
			initialSigTemp = pretruncated[5:0];
		end
	   initialExpTemp = 8 - numzero;
	end
  
	assign initialExp = initialExpTemp;
	assign initialSig = initialSigTemp;
	
endmodule



module rounder(initialSig, initialExp,finalSig, finalExp);
  
    input [5:0] initialSig;
    input [2:0] initialExp;
    output [4:0] finalSig;
    output [2:0] finalExp;
	 reg [5:0] inputSigTemp;
	 reg [2:0] inputExpTemp;
	 
    always @ (*) begin
		inputSigTemp = initialSig;
		inputExpTemp= initialExp;
		if(initialSig[0] == 1) begin //round up
			if ((&initialSig) == 1) begin //if all initial sig bits are 1
				if (initialExp < 7) begin //if initial exp < 7, truncate extra bit off end to make 5 bit again
					inputSigTemp = 5'b10000;
					inputExpTemp = initialExp + 1; //increase exponent value by 1 to compensate
				end
				else if (initialExp == 7) begin //if initial exp = 7, leave it
					inputSigTemp = 5'b11111;
					inputExpTemp = initialExp;
				end
			end
			else begin //normal round up procedure
				inputSigTemp = initialSig[5:1] + 1;
				inputExpTemp = initialExp;
			end
		end
		else begin //round down
			inputSigTemp = initialSig[5:1];
			inputExpTemp = initialExp;
		end
	 end
	 
	 assign finalSig = inputSigTemp;
	 assign finalExp = inputExpTemp;
	 
endmodule

