module TIMER_COUNTER
(
	input wire			  								CLK,
	input wire												CPU_Reset,

	input  wire												TIMER_EN,
	
	input  wire 											TIMER_SET_REG,
	input  wire 											TIMER_SET_PRESC,
	input  wire 											TIMER_SET_VALUE,
	
	input  wire	[7:0] 								TIMER_DATA,
	
	output wire												TIMER_OV
);


reg [7:0]  _TIMER_CONFIG;
reg [15:0] _TIMER_COUNTER;

wire _prescaler_OV;

wire _TIMER_ZERO = (_TIMER_COUNTER == 16'h0000) ? 1'b1 : 1'bz;
wire _TIMER_FULL = (_TIMER_COUNTER == 16'hFFFF) ? 1'b1 : 1'bz;

//PRESCALER:
TIMER_Prescaler _TIMER_Prescaler
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),
	
	.TIMER_EN(!TIMER_EN && _TIMER_CONFIG_EN),
	.TIMER_CONFIG_PRESCALER(_TIMER_CONFIG_PRESCALER),
	
	.PRESCALER_OV(_prescaler_OV)
);


//TIMER:
always @(posedge CLK)
begin
	if(CPU_Reset)
	begin
		_TIMER_COUNTER 	 <= 0;
	end	
	else if(!TIMER_EN && _prescaler_OV)
	begin
		if(_TIMER_CONFIG[6])
			_TIMER_COUNTER <= _TIMER_COUNTER + 1'b1;
		else if(_TIMER_COUNTER != _TIMER_ZERO)
			_TIMER_COUNTER <= _TIMER_COUNTER - 1'b1;
	end
end

assign TIMER_OV = (_TIMER_CONFIG[6]) ? _TIMER_FULL : _TIMER_ZERO;

endmodule 