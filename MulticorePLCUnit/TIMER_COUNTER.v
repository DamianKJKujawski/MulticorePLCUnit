module TIMERCOUNTER_UNIT
(
	input wire 				CLK,
	input wire 				CPU_Reset,
	
	input wire			 	TIMER_WR_MSB,
	input wire [7:0] 	TIMER_MSB,
	
	input wire			 	TIMER_WR_LSB,
	input wire [7:0] 	TIMER_LSB,
	
	input wire 				TIMERCOUNTER_EN,
	input wire 				TIMERCOUNTER_MODE,
	
	output wire 			TIMER_OV
);

reg [15:0] _TIMER_COUNTER;

assign TIMER_OV = (_TIMER_COUNTER == 16'h0000) ? 1'b1 : 1'b0;

always @(posedge CLK or posedge CPU_Reset)
begin
	if(CPU_Reset)
	begin
		_TIMER_COUNTER 	 <= 0;
	end	
	else if(TIMERCOUNTER_EN)
	begin
		if(TIMERCOUNTER_MODE)
			begin
				_TIMER_COUNTER <= _TIMER_COUNTER + 1'b1;
			end
		else if(_TIMER_COUNTER != TIMER_OV)
			_TIMER_COUNTER <= _TIMER_COUNTER - 1'b1;
	end
	else if(TIMER_WR_MSB)
		_TIMER_COUNTER[15:8] <= TIMER_MSB;
	else if(TIMER_WR_LSB)
		_TIMER_COUNTER[ 7:0] <= TIMER_LSB;
end

endmodule 