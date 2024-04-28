module SEMAPHORE_BLOCKINGMUX
#
(
	parameter NumberOfSemaphores 	= 4,
	parameter NumberOfCores 			= 2
)
(
	//Data from Semaphores to CPU:  
	input wire [(NumberOfSemaphores*NumberOfCores)-1: 0]		SEMAPHOREBLOCKINGMUX_Blocking_fromSemaphore, 
	//Addr from CPU:
	input  wire [7: 0]																			SEMAPHOREBLOCKINGMUX_Addr_fromCPU,
	
	output wire 																						SEMAPHOREBLOCKINGMUX_Blocking_toCPU
);

assign SEMAPHOREBLOCKINGMUX_Blocking_toCPU = SEMAPHOREBLOCKINGMUX_Blocking_fromSemaphore[SEMAPHOREBLOCKINGMUX_Addr_fromCPU];

endmodule
