module SEMAPHORE_READ_CONTROLLER
#
(
	parameter NumberOfSemaphores 	= 8,
	parameter NumberOfCores 	= 2
)
(
	//Read signal:
	input wire 																							SEMAPHOREREADCONTROLLER_READ_fromCPU,
	//WE decoder
	input wire  [(NumberOfSemaphores*NumberOfCores)-1: 0] 	SEMAPHOREREADCONTROLLER_WE_buffer,
	
	output wire [(NumberOfSemaphores*NumberOfCores)-1: 0]		SEMAPHOREREADCONTROLLER_READ_toSemaphore
);

genvar i;
generate
	for (i=0; i<(NumberOfSemaphores*NumberOfCores); i=i+1) 
	begin 
		: generate_READ_CONTROLLER_id
	
		assign SEMAPHOREREADCONTROLLER_READ_toSemaphore[i]  = (SEMAPHOREREADCONTROLLER_READ_fromCPU) ? SEMAPHOREREADCONTROLLER_WE_buffer[i] : 1'bz;
		
	end
endgenerate

endmodule
