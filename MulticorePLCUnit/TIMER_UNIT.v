module TIMER
(
	input wire			  			CLK,
	input wire							CPU_Reset,

	input  wire							TIMER_EN,
	
	input wire			 				TIMER_WR_MSB,
	input wire			 				TIMER_WR_LSB,

	input  wire 						TIMER_SET_REGISTER,
	
	input  wire	[7:0] 			TIMER_DATA,
	
	output wire							TIMER_OV
);


wire _prescaler_OV;
reg [7:0]  _TIMER_CONFIG;

always @(posedge CLK)
begin
	if(TIMER_EN && TIMER_SET_REGISTER)
		begin
			_TIMER_CONFIG <= TIMER_DATA;
		end
end


//PRESCALER:
TIMER_Prescaler _TIMER_Prescaler
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),
	
	.TIMER_EN(!TIMER_EN && _TIMER_CONFIG[7]),
	.TIMER_CONFIG_PRESCALER(_TIMER_CONFIG[5:0]),
	
	.PRESCALER_OV(_prescaler_OV)
);

TIMERCOUNTER_UNIT _TIMERCOUNTER_UNIT
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),
	
	.TIMER_WR_MSB(TIMER_WR_MSB),
	.TIMER_MSB(TIMER_DATA),
	.TIMER_WR_LSB(TIMER_WR_LSB),
	.TIMER_LSB(TIMER_DATA),
	
	.TIMERCOUNTER_EN(!TIMER_EN && _prescaler_OV),
	.TIMERCOUNTER_MODE(_TIMER_CONFIG[6]),
	
	.TIMER_OV(TIMER_OV) 
);


endmodule 