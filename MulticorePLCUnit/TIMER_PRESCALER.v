module TIMER_Prescaler
(
	input wire CLK,
	input wire CPU_Reset,
	
	input wire TIMER_EN,
	input wire [5:0] TIMER_CONFIG_PRESCALER,
	
	output wire PRESCALER_OV
);

reg  [5:0] _TIMER_PRESCALER;

always @(posedge CLK or posedge CPU_Reset)
begin
		if(CPU_Reset)
		begin
			_TIMER_PRESCALER = 0;
		end	
		else if(TIMER_EN)
			begin
				if(!PRESCALER_OV)
					_TIMER_PRESCALER <= _TIMER_PRESCALER + 1'b1;
				else
					_TIMER_PRESCALER <= 0;
			end
end 

assign PRESCALER_OV = (_TIMER_PRESCALER == TIMER_CONFIG_PRESCALER);

endmodule 