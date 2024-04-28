module INPUT_REGISTERS
(
	input wire 		   	CLK,
	input wire 				INPUTREGISTERS_EN,
		
	input wire 		   	INPUTREGISTERS_LoadInput,
	input wire [15:0] INPUTREGISTERS_INPUT,
	
	input wire [3:0] 	INPUTREGISTERS_InADDR,
	output wire 			INPUTREGISTERS_InDATA
);

reg [15:0] IN_REGISTER;

assign INPUTREGISTERS_InDATA = (INPUTREGISTERS_EN) ? IN_REGISTER[INPUTREGISTERS_InADDR] : 1'bz;
		
always @ (posedge CLK)
begin
	if (INPUTREGISTERS_LoadInput) 
		IN_REGISTER[15:0] <= INPUTREGISTERS_INPUT;
end


//TESTBENCH INIT:
initial begin
	IN_REGISTER = 16'b0;
end


endmodule 