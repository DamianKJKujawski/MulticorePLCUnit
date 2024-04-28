module FIFO_COUNTER
( 
	//Basic:
	input wire 			CLK, 
	
	input wire 			FIFOCOUNTER_RST,
	
	//Input:
	input wire 			FIFOCOUNTER_CntUpEnable,
	input wire 			FIFOCOUNTER_CntDownEnable,
	
	input wire 			FIFOCOUNTER_CntUpSignal, 
	input wire 			FIFOCOUNTER_CntDownSignal, 
	
	//Output:
	output reg [1:0] 	FIFOCOUNTER_Counter
); 

wire CntUp 		=  !FIFOCOUNTER_CntUpEnable   && FIFOCOUNTER_CntUpSignal;
wire CntDown 	=  !FIFOCOUNTER_CntDownEnable && FIFOCOUNTER_CntDownSignal;

reg [1:0] Counter;

always @(posedge CLK)
begin
	if(FIFOCOUNTER_RST)
		FIFOCOUNTER_Counter <= 0;
	else
		FIFOCOUNTER_Counter <= Counter;
end

always @(*)
begin
	if(CntDown && !CntUp)
		Counter <= FIFOCOUNTER_Counter - 1'b1;
	else if(CntUp && !CntDown)
		Counter <= FIFOCOUNTER_Counter + 1'b1;
	else
		Counter <= FIFOCOUNTER_Counter;
end

endmodule 