module TIMERS
(
	input wire			  								CLK,
	input wire												CPU_Reset,

	input  wire												TIMER1_EN,
	
	input  wire 											TIMER_WR_MSB,
	input  wire 											TIMER_WR_LSB,
	
	input  wire 											TIMER_SET_REGISTER,
	
	input  wire	[7:0] 								TIMERS_DATA,
	
	input wire												TIMER1_OV_Read,
	output reg												TIMER1_OV_Flag
);

wire _TIMER1_OV;

always @(posedge CLK)
begin
	if(TIMER1_OV_Read)
		TIMER1_OV_Flag <= 1'b0;
	else if(_TIMER1_OV)
		TIMER1_OV_Flag <= 1'b1;
end

TIMER TIMER1
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),

	.TIMER_EN(TIMER1_EN),
	
	.TIMER_WR_MSB(TIMER_WR_MSB),
	.TIMER_WR_LSB(TIMER_WR_LSB),

	.TIMER_SET_REGISTER(TIMER_SET_REGISTER),
	
	.TIMER_DATA(TIMERS_DATA),
	
	.TIMER_OV(_TIMER1_OV)
);

endmodule 