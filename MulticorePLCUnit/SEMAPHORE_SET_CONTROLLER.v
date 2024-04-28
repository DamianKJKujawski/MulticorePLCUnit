module SEMAPHORE_WR_CONTROLLER
#
(
	parameter NumberOfSemaphores 	= 4,
	parameter NumberOfCores 	= 2
)
(
	//Set signal:
	input wire 																							SEMAPHORESETCONTROLLER_WR_fromCPU,
	//WE decoder
	input wire  [(NumberOfSemaphores*NumberOfCores)-1: 0] 	SEMAPHORESETCONTROLLER_WE_buffer,
	
	output wire [(NumberOfSemaphores*NumberOfCores)-1: 0]		SEMAPHORESETCONTROLLER_WR_toSemaphore
);

genvar i;
generate
	for (i=0; i<(NumberOfSemaphores*NumberOfCores); i=i+1) 
	begin 
		: generate_WR_CONTROLLER_id

		assign SEMAPHORESETCONTROLLER_WR_toSemaphore[i] = (SEMAPHORESETCONTROLLER_WR_fromCPU) ? SEMAPHORESETCONTROLLER_WE_buffer[i] : 1'bz;
		
	end
endgenerate

endmodule
