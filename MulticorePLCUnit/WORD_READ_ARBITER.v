module READ_ARBITER
(
	//CLK:
	input wire 			  	CLK,

	//Carry in:
	input wire 			  	READARBITER_RR_PREV,
		
	//Driver data:
	input wire 			  	READARBITER_READ_REQUEST,

	//Data:
	output wire  [7:0]  READARBITER_CORE_ReadDATA,
	input wire   [15:0] READARBITER_CORE_ReadADDR,

	input wire   [7:0]  READARBITER_RAM_ReadDATA,
	output wire  [15:0] READARBITER_RAM_ReadADDR,
	
	//Ack:
	output reg			  	READARBITER_ACK,

	//Carry out:
	output wire 		  	READARBITER_CARRY_OUT
);

reg		RR_reg;
wire 	SELECTOR;

always @(posedge CLK)
begin
	RR_reg 				 		<= READARBITER_READ_REQUEST;
	READARBITER_ACK 	<= SELECTOR;
end

assign SELECTOR 										= (READARBITER_RR_PREV &&  RR_reg) ? 1'b1 : 1'b0;
assign READARBITER_CARRY_OUT 				= (READARBITER_RR_PREV && ~RR_reg) ? 1'b1 : 1'b0;

assign READARBITER_CORE_ReadDATA 		= READARBITER_RAM_ReadDATA; 
assign READARBITER_RAM_ReadADDR 		= (SELECTOR) ? READARBITER_CORE_ReadADDR  :  16'bzzzz_zzzz_zzzz_zzzz; 

initial begin
	RR_reg = 0;
	READARBITER_ACK = 0;
end

endmodule 