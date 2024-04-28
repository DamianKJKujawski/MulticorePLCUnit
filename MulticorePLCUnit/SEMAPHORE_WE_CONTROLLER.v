module SEMAPHORE_WE_CONTROL
#
(
	parameter NumberOfSemaphores 	= 4,
	parameter NumberOfCores				= 2
)
(
	//WE decoder
	input wire  [(NumberOfSemaphores*NumberOfCores)-1: 0] 	SEMAPHOREWECONTROLLER_WE_buffer,
	//Addr from AddrDecoder to Semaphore:
	output wire [(NumberOfSemaphores*NumberOfCores)-1: 0]		SEMAPHOREWECONTROLLER_WE_toSemaphore
);


genvar i;
generate
	for (i=0; i<(NumberOfSemaphores*NumberOfCores); i=i+1) 
	begin 
		: generate_WE_CONTROLLER_id
		
			assign SEMAPHOREWECONTROLLER_WE_toSemaphore[i] 	= (SEMAPHOREWECONTROLLER_WE_buffer[i]) ? 1'b1 : 1'bz;
		
	end
endgenerate

endmodule 