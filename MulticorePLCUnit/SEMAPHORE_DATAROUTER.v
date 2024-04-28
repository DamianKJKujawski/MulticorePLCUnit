module SEMAPHORE_DATADECODER
#
(
	parameter NumberOfSemaphores 	= 4,
	parameter NumberOfCores 			= 2
)
(
	//Data from Semaphores to AddrDecoder:  
	input wire [4*(NumberOfSemaphores*NumberOfCores)-1: 0]	SEMAPHOREDATADECODER_Data_fromSemaphore,
	//Data from AddrDecoder to CPU:  
	output wire [3:0]																				SEMAPHOREDATADECODER_Data_toCPU,
	//Addr from CPU to AddrDecoder:
	input  wire [7:0]																			  SEMAPHOREDATADECODER_Addr_fromCPU
);

genvar i;
generate
	for (i=0; i<(4); i=i+1) 
	begin 
		: generate_WE_CONTROLLER_id

			assign SEMAPHOREDATADECODER_Data_toCPU[i] = SEMAPHOREDATADECODER_Data_fromSemaphore [(SEMAPHOREDATADECODER_Addr_fromCPU*8)+i];

	end
endgenerate




endmodule
