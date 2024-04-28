module WRITE_ARBITER
(
	//CLK:
	input wire 			 		CLK,

	//Carry in:
	input wire 			 		WRITEARBITER_WE_PREV,
	
	//Driver data:
	input wire 			 		WRITEARBITER_WE,
	output wire					WRITEARBITER_RAM_WE,
	
	//Data:
	input wire  [7:0]  	WRITEARBITER_CORE_WriteDATA,
	input wire  [15:0] 	WRITEARBITER_CORE_WriteADDR,

	output wire [7:0]  	WRITEARBITER_RAM_WriteDATA,
	output wire [15:0] 	WRITEARBITER_RAM_WriteADDR,
	
	//Ack:
	output reg			 		WRITEARBITER_ACK,

	//Carry out:
	output wire 		 		WRITEARBITER_CARRY_OUT
);

reg		WE_reg;
wire  SELECTOR_GATE;

always @(posedge CLK)
begin
	WE_reg <= WRITEARBITER_WE;
	WRITEARBITER_ACK <= SELECTOR_GATE;
end

assign SELECTOR_GATE	 							= (WRITEARBITER_WE_PREV &&  WE_reg) ? 1'b1 : 1'b0;
assign WRITEARBITER_CARRY_OUT 			= (WRITEARBITER_WE_PREV && ~WE_reg) ? 1'b1 : 1'b0;

assign WRITEARBITER_RAM_WriteDATA 	= (SELECTOR_GATE) ? WRITEARBITER_CORE_WriteDATA :  8'bzzzz_zzzz; 
assign WRITEARBITER_RAM_WriteADDR 	= (SELECTOR_GATE) ? WRITEARBITER_CORE_WriteADDR :  16'bzzzz_zzzz_zzzz_zzzz; 

assign WRITEARBITER_RAM_WE = (SELECTOR_GATE) ? 1'b1 : 1'b0;

initial begin
	WE_reg = 0;
	WRITEARBITER_ACK = 0;
end


endmodule 