module FIFO_POINTER
( 
	//Basic:
	input wire 			CLK, 
	
	input wire 			FIFOPOINTERS_RST,
	
	//Input:
	input wire 			FIFOPOINTERS_EnablingSignal,
	input wire 			FIFOPOINTERS_CntSignal, 
	
	//Output:
	output reg [1:0] 	FIFOPOINTERS_CntPointer
); 


always@(posedge CLK)
begin
   if(FIFOPOINTERS_RST)
		begin
			FIFOPOINTERS_CntPointer <= 0;
		end
   else
		begin
			if( !FIFOPOINTERS_EnablingSignal && FIFOPOINTERS_CntSignal ) 
					FIFOPOINTERS_CntPointer <= FIFOPOINTERS_CntPointer + 1'b1;
		end
end


endmodule 