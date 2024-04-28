module BIT_READ_ARBITER
(
	//CLK:
	input wire 			  CLK,
	
	input wire			  BITREADARBITER_BIT_SELECT,
	//Carry in:
	input wire 			  BITREADARBITER_RR_PREV,
		
	//Driver data:
	input wire 			  BITREADARBITER_READ_REQUEST,
	output wire  		  BITREADARBITER_THREAD_DATA,
	input wire   [15:0] BITREADARBITER_THREAD_ADDR,

	//Output data:
	input wire   		  BITREADARBITER_RAM_DATA,
	output wire  [15:0] BITREADARBITER_RAM_ADDR,
	
	//Ack:
	output reg			  BITREADARBITER_ACK,

	//Carry out:
	output wire 		  BITREADARBITER_CARRY_OUT
);

reg	RR_reg;
wire 	SELECTOR;

always @(posedge CLK)
begin
	if(BITREADARBITER_BIT_SELECT)
	begin
		RR_reg 					 <= BITREADARBITER_READ_REQUEST;
		BITREADARBITER_ACK 	 <= SELECTOR;
	end
end




assign SELECTOR 							= (BITREADARBITER_RR_PREV &&  RR_reg) ? 1'b1 : 1'b0;
assign BITREADARBITER_CARRY_OUT 		=  BITREADARBITER_RR_PREV && ~RR_reg;

assign BITREADARBITER_THREAD_DATA 	= (SELECTOR) ? BITREADARBITER_RAM_DATA 	 :  8'bzzzz_zzzz; 
assign BITREADARBITER_RAM_ADDR 		= (SELECTOR) ? BITREADARBITER_THREAD_ADDR  :  8'bzzzz_zzzz; 


endmodule 