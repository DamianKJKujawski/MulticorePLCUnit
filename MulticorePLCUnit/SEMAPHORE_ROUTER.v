module SEMAPHORE_ROUTER
#
(
	parameter NumberOfSemaphores = 4,
	parameter NumberOfCores      = 2
)
(
	input  wire 																						CLK,
	input  wire																							SEMAPHOREROUTER_RESET,
	
	//--------------------------------- DRIVING SIGNALS --------------------------------------------
	//Core - Router:
	input  wire 																						SEMAPHOREROUTER_EN_FromCPU,
	input  wire																							SEMAPHOREROUTER_CREATE_FromCPU,
	input  wire 																						SEMAPHOREROUTER_ACQUIRE_FromCPU,
	input  wire 																						SEMAPHOREROUTER_RELEASE_FromCPU,
	//Router - Semaphore:
	output wire [(NumberOfSemaphores*NumberOfCores)-1: 0]		SEMAPHOREROUTER_EN_ToSemaphore,
	output wire [(NumberOfSemaphores*NumberOfCores)-1: 0]		SEMAPHOREROUTER_WR_toSemaphore,
	
	//Ack:
	output reg																							SEMAPHOREROUTER_ACK,
	//Semaphore busy:
	input  wire [(NumberOfSemaphores*NumberOfCores)-1: 0]		SEMAPHOREROUTER_BLOCKING_FromSemaphore,
	
	//------------------------------------ DATA ----------------------------------------------------
	//Core - Router:
	input  wire [3: 0]		 																	SEMAPHOREROUTER_Data_fromCPU,
	input  wire [7: 0]																			SEMAPHOREROUTER_Addr_FromCPU,

	//Router - Semaphore:
	input wire  [(4*NumberOfSemaphores*NumberOfCores)-1: 0] SEMAPHOREROUTER_CntOut,
	output wire [(4*NumberOfSemaphores*NumberOfCores)-1: 0]	SEMAPHOREROUTER_CntIn
);


reg  [3:0] _SEMAPHOREROUTER_Data_toCnt;
wire [3:0] _SEMAPHOREROUTER_Data_toCntIn;
wire [3:0] _SEMAPHOREROUTER_SemaphoreData;

//-------------------------------------------------------------------------------------------//
//Router controller:



reg _SEMAPHOREROUTER_WR_FromCPU;
reg _SEMAPHOREROUTER_EN_FromCPU;

//
localparam IDLE 		= 2'b00;
localparam CREATE 	= 2'b01;
localparam RELEASE 	= 2'b10;
localparam ACQUIRE 	= 2'b11;

reg [2:0] semaphoreController;


wire _SEMAPHOREROUTER_BLOCKING;

wire _SEMAPHOREROUTER_ACQ_EN  = (4'b0000 != _SEMAPHOREROUTER_SemaphoreData);
wire _SEMAPHOREROUTER_RELE_EN = (4'b1111 != _SEMAPHOREROUTER_SemaphoreData);

wire [3:0] _SEMAPHOREROUTER_Cnt_RELEASE 	= _SEMAPHOREROUTER_SemaphoreData + 1'b1;
wire [3:0] _SEMAPHOREROUTER_Cnt_ACQUIRE 	= _SEMAPHOREROUTER_SemaphoreData - 1'b1;

wire RELE_EN 		= SEMAPHOREROUTER_RELEASE_FromCPU && _SEMAPHOREROUTER_RELE_EN;
wire ACQ_EN  		= SEMAPHOREROUTER_ACQUIRE_FromCPU && _SEMAPHOREROUTER_ACQ_EN;

wire enableGate = !_SEMAPHOREROUTER_BLOCKING && SEMAPHOREROUTER_EN_FromCPU;


always @(posedge CLK)
begin
	if(SEMAPHOREROUTER_RESET)
	begin
		SEMAPHOREROUTER_ACK <= 0;
		_SEMAPHOREROUTER_EN_FromCPU <= 0;
		_SEMAPHOREROUTER_WR_FromCPU <= 0;
		_SEMAPHOREROUTER_Data_toCnt <= 4'bzzzz;
		
		semaphoreController = IDLE;
	end
	case(semaphoreController)
	IDLE:
	begin
		SEMAPHOREROUTER_ACK <= 0;
		_SEMAPHOREROUTER_EN_FromCPU <= 0;
		_SEMAPHOREROUTER_WR_FromCPU <= 0;
		_SEMAPHOREROUTER_Data_toCnt <= 4'bzzzz;
	
		if(enableGate)
		begin
			if(SEMAPHOREROUTER_CREATE_FromCPU)
				semaphoreController = CREATE;				
			else if(RELE_EN)
				semaphoreController =  RELEASE;
			else if(ACQ_EN)
				semaphoreController = ACQUIRE;
		end
	end
	CREATE:
	begin
		_SEMAPHOREROUTER_Data_toCnt  <= SEMAPHOREROUTER_Data_fromCPU;
		_SEMAPHOREROUTER_EN_FromCPU <= 1'b1;
		_SEMAPHOREROUTER_WR_FromCPU <= 1'b1;
		SEMAPHOREROUTER_ACK <= 1'b1;
		
		semaphoreController = IDLE;
	end
	RELEASE:
	begin
		_SEMAPHOREROUTER_Data_toCnt <= _SEMAPHOREROUTER_Cnt_RELEASE;
		_SEMAPHOREROUTER_EN_FromCPU <= 1'b1;
		_SEMAPHOREROUTER_WR_FromCPU <= 1'b1;
		SEMAPHOREROUTER_ACK <= 1'b1;
		
		semaphoreController = IDLE;
	end
	ACQUIRE:
	begin
		_SEMAPHOREROUTER_Data_toCnt <= _SEMAPHOREROUTER_Cnt_ACQUIRE;
		_SEMAPHOREROUTER_EN_FromCPU <= 1'b1;
		_SEMAPHOREROUTER_WR_FromCPU <= 1'b1;	
		SEMAPHOREROUTER_ACK <= 1'b1;
		
		semaphoreController = IDLE;
	end
endcase
end

//Testbench init:
initial begin
	semaphoreController = 0;
	_SEMAPHOREROUTER_EN_FromCPU = 0;
	_SEMAPHOREROUTER_WR_FromCPU = 0;
	SEMAPHOREROUTER_ACK = 0;
end




//-------------------------------------------------------------------------------------------//
																									
SEMAPHORE_ENABLE_ROUTER #
(
	.NumberOfCores(NumberOfCores),
	.NumberOfSemaphores(NumberOfSemaphores)
)
_SEMAPHORE_ENABLE_ROUTER
(
	//Addr from CPU to AddrDecoder:
	.SEMAPHOREENABLER_Addr_fromCPU(SEMAPHOREROUTER_Addr_FromCPU),
	//Addr from AddrDecoder to Semaphore:
	.SEMAPHOREENABLER_EN_fromCPU(_SEMAPHOREROUTER_EN_FromCPU),
	.SEMAPHOREENABLER_EN_toSemaphore(SEMAPHOREROUTER_EN_ToSemaphore),
	
	//WR:
	.SEMAPHOREADDRDECODER_WR_fromCPU(_SEMAPHOREROUTER_WR_FromCPU),
	.SEMAPHOREADDRDECODER_WR_toSemaphore(SEMAPHOREROUTER_WR_toSemaphore),

	//Data:
	.SEMAPHOREADDRDECODER_Data_fromCPU(_SEMAPHOREROUTER_Data_toCnt),
	.SEMAPHOREINDATAROUTER_Data_toSemaphore(SEMAPHOREROUTER_CntIn)
);



SEMAPHORE_BLOCKINGMUX #
(
	.NumberOfCores(NumberOfCores),
	.NumberOfSemaphores(NumberOfSemaphores)
)
_SEMAPHORE_BLOCKINGMUX
(
	.SEMAPHOREBLOCKINGMUX_Blocking_fromSemaphore(SEMAPHOREROUTER_BLOCKING_FromSemaphore), 
	.SEMAPHOREBLOCKINGMUX_Addr_fromCPU(SEMAPHOREROUTER_Addr_FromCPU),
	.SEMAPHOREBLOCKINGMUX_Blocking_toCPU(_SEMAPHOREROUTER_BLOCKING)
);



SEMAPHORE_DATADECODER #
(
	.NumberOfCores(NumberOfCores),
	.NumberOfSemaphores(NumberOfSemaphores)
)
_SEMAPHORE_DATADECODER
(
	//Data from Semaphores to AddrDecoder:  
	.SEMAPHOREDATADECODER_Data_fromSemaphore(SEMAPHOREROUTER_CntOut),
	//Data from AddrDecoder:  
	.SEMAPHOREDATADECODER_Data_toCPU(_SEMAPHOREROUTER_SemaphoreData),
	//Addr from CPU to AddrDecoder:
	.SEMAPHOREDATADECODER_Addr_fromCPU(SEMAPHOREROUTER_Addr_FromCPU)
);


endmodule
