module SEMAPHORE_DATA_CONTROLLER
#
(
	parameter NumberOfSemaphores 	= 4,
	parameter NumberOfCores 	= 2
)
(
	input wire  [3:0]																				SEMAPHOREDATACONTROLLER_Data_fromCPU,
	//WE decoder
	input wire  [(NumberOfSemaphores*NumberOfCores)-1: 0] 	SEMAPHOREDATACONTROLLER_WE_buffer,
	
	output wire [(4*NumberOfSemaphores*NumberOfCores)-1: 0]	SEMAPHOREDATACONTROLLER_Data_toSemaphore
);

genvar i;
generate
	for (i=0; i<(NumberOfSemaphores*NumberOfCores); i=i+1) 
	begin 
		: generate_DATA_CONTROLLER_id

		assign SEMAPHOREDATACONTROLLER_Data_toSemaphore[((4*i)+4)-1:4*i] = (SEMAPHOREDATACONTROLLER_WE_buffer[i]) ? SEMAPHOREDATACONTROLLER_Data_fromCPU : 4'bzzzz;
		
	end
endgenerate

endmodule
