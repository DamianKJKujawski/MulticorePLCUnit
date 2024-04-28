module OUTPUT_REGISTERS
(
	input wire 		    	CLK,
	input wire 		    	OUTPUTREGISTERS_WE,
	input wire			 		OUTPUTREGISTERS_EN,
	
	input wire 		 	 		OUTPUTREGISTERS_LoadOutput,
	output reg  [15:0] 	OUTPUTREGISTERS_OUTPUT,
	
	input wire  [3:0]  	OUTPUTREGISTERS_OutADDR,
	input wire 			 		OUTPUTREGISTERS_OutDATA,
	
	input  wire  [3:0]  OUTPUTREGISTERS_ReadOutADDR,
	output wire 			 	OUTPUTREGISTERS_ReadOutDATA
);

reg [15:0] OUT_REGISTER;

assign OUTPUTREGISTERS_ReadOutDATA = (OUTPUTREGISTERS_EN) ? OUT_REGISTER[OUTPUTREGISTERS_ReadOutADDR] : 1'bz;

always @ (posedge CLK)
begin
	if (OUTPUTREGISTERS_WE && OUTPUTREGISTERS_EN) 
		OUT_REGISTER[OUTPUTREGISTERS_OutADDR] <= OUTPUTREGISTERS_OutDATA;
end

always @ (posedge CLK)
begin
	if (OUTPUTREGISTERS_LoadOutput) 
		OUTPUTREGISTERS_OUTPUT[15:0] <= OUT_REGISTER;
end

//TESTBENCH INIT:
initial begin
	OUT_REGISTER = 16'b0;
	OUTPUTREGISTERS_OUTPUT = 16'b0;
end

endmodule 