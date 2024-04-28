module SEMAPHORE_ENABLE_ROUTER
#
(
parameter NumberOfSemaphores 	= 4,
parameter NumberOfCores 			= 2,

parameter numOfSemaphores_AddrMSB = (NumberOfSemaphores>1)? ($clog2(NumberOfCores)-1) : 0,
parameter numOfCores_AddrMSB 		 	= (NumberOfSemaphores>1)? ($clog2(NumberOfCores)-1) : 0
)
(
	//Addr from CPU to AddrDecoder:
	input  wire [7: 0]																				SEMAPHOREENABLER_Addr_fromCPU,
	//Addr from AddrDecoder to Semaphore:
	input wire 																								SEMAPHOREENABLER_EN_fromCPU,
	output wire [(NumberOfSemaphores*NumberOfCores)-1: 0]			SEMAPHOREENABLER_EN_toSemaphore,
	
	input wire 																								SEMAPHOREADDRDECODER_WR_fromCPU,
	output wire [(NumberOfSemaphores*NumberOfCores)-1: 0]			SEMAPHOREADDRDECODER_WR_toSemaphore,
		
	input wire 	[3:0]																					SEMAPHOREADDRDECODER_Data_fromCPU,
	output wire [(4*(NumberOfSemaphores*NumberOfCores))-1: 0] SEMAPHOREINDATAROUTER_Data_toSemaphore
);

wire [(NumberOfSemaphores*NumberOfCores)-1: 0]_SEMAPHOREENABLER_WE_buffer = (SEMAPHOREENABLER_EN_fromCPU) ? (1'b1 << SEMAPHOREENABLER_Addr_fromCPU[7:0]) : 4'd0;


SEMAPHORE_WE_CONTROL #
(
	.NumberOfCores(NumberOfCores),
	.NumberOfSemaphores(NumberOfSemaphores)
)
_SEMAPHORE_WE_CONTROL
(
	.SEMAPHOREWECONTROLLER_WE_buffer(_SEMAPHOREENABLER_WE_buffer),
	.SEMAPHOREWECONTROLLER_WE_toSemaphore(SEMAPHOREENABLER_EN_toSemaphore)
);


SEMAPHORE_WR_CONTROLLER #
(
	.NumberOfCores(NumberOfCores),
	.NumberOfSemaphores(NumberOfSemaphores)
)
_SEMAPHORE_WR_CONTROLLER
(
	.SEMAPHORESETCONTROLLER_WR_fromCPU(SEMAPHOREADDRDECODER_WR_fromCPU),
	.SEMAPHORESETCONTROLLER_WE_buffer(_SEMAPHOREENABLER_WE_buffer),
	.SEMAPHORESETCONTROLLER_WR_toSemaphore(SEMAPHOREADDRDECODER_WR_toSemaphore)
);


SEMAPHORE_DATA_CONTROLLER #
(
	.NumberOfCores(NumberOfCores),
	.NumberOfSemaphores(NumberOfSemaphores)
)
_SEMAPHORE_DATA_CONTROLLER
(
	.SEMAPHOREDATACONTROLLER_Data_fromCPU(SEMAPHOREADDRDECODER_Data_fromCPU),
	.SEMAPHOREDATACONTROLLER_WE_buffer(_SEMAPHOREENABLER_WE_buffer),
	.SEMAPHOREDATACONTROLLER_Data_toSemaphore(SEMAPHOREINDATAROUTER_Data_toSemaphore)
);

endmodule
