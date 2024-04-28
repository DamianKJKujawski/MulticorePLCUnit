module CORES
#
(
	parameter NumberOfCores 			= 4,
	parameter NumberOfSemaphores 	= 4,
	parameter AddrMSB 		 				= (NumberOfCores>1) ? ($clog2(NumberOfCores)-1) + 1 : 1,
	parameter AddrMSB2 		 				= (NumberOfCores>1) ? ($clog2(NumberOfCores))   + 1 : 1
)
(	
	input wire			 		CLK,
	
	input	wire			 		CPU_ProgramReset,
	input	wire			 		CPU_EN,
	input wire					CPU_HOLD,
	
	//--------------------------------- PROGRAMMER --------------------------------------------
	input	wire			 		PROGRAMMER_RESET,
	input	wire	[7:0]	 	PROGRAMMER_DIN,
	input	wire			 		PROGRAMMER_PCK,
	input	wire			 		PROGRAMMER_SCK,
	
	//------------------------------ STATE CONTROLLER -----------------------------------------
	output wire			 		CORES_CPU_END_Detected,

	//-------------------------------- PERIPHERALS --------------------------------------------
	//Word:
	output wire			  	PERIPHERALS_RAM_WE,
	output wire	[7:0]  	PERIPHERALS_RAM_DATA,
	output wire	[15:0] 	PERIPHERALS_RAM_ADDR,
	//Bit:
	output wire				 	PERIPHERALS_BIT_WE,
	output wire [15:0]  PERIPHERALS_BIT_InADDR,
	input wire  			  PERIPHERALS_BIT_InDATA,
	output wire [15:0]  PERIPHERALS_BIT_OutADDR,
	output wire 				PERIPHERALS_BIT_OutDATA
);


	
/*----------------------------------------------------------------------------------------*/
//																				PROGRAMMER
/*----------------------------------------------------------------------------------------*/

//Output data:
wire 	[7:0]				_PROGRAMMER_OutputData;
wire 	[3:0]				_PROGRAMMER_ROMAddr;

//CPU Driving sygnals:
wire 							_CPU_Reset;
wire 							_CPU_WE;
wire [AddrMSB:0] 	_CPU_WE_ADDR;


		PROGRAMMER #
		(
			.NumberOfCores(NumberOfCores)
		)
		_PROGRAMMER
		(
			.CLK(CLK),
			//Input signals:
			.PROGRAMMER_RESET(PROGRAMMER_RESET),
			.PROGRAMMER_InputData(PROGRAMMER_DIN),
			.PROGRAMMER_PCK(PROGRAMMER_PCK),
			.PROGRAMMER_SCK(PROGRAMMER_SCK),
			
			//Output data:
			.PROGRAMMER_OutputData(_PROGRAMMER_OutputData),
			.PROGRAMMER_ROMAddr(_PROGRAMMER_ROMAddr),
			.CPU_WE_ADDR(_CPU_WE_ADDR),
			
			//Output signals:
			.CPU_Reset(_CPU_Reset),
			.CPU_WE(_CPU_WE)
		);

/*----------------------------------------------------------------------------------------*/
//																			 GENVARs
/*----------------------------------------------------------------------------------------*/

	genvar i;
	genvar x;
	genvar y;

/*----------------------------------------------------------------------------------------*/
//																			CPU SIGNALS:
/*----------------------------------------------------------------------------------------*/
	
	//CPU - Arbiter Addr:
	wire	[15:0] 	_CPU_CORE_ADDR  		[AddrMSB:0];
	//CPU - Word Arboter Data:
	wire	[7:0]		_CPU_CORE_DATA  		[AddrMSB:0];
	
	//END Signal:
	wire [(NumberOfCores-1):0] 	_CPU_END_Detected;
	
	generate	//OR RAM_WE signals:
		for (i = 0; i < NumberOfCores-1; i=i+1)
			begin
				: generate_CPU_END_identifier
				
					assign CORES_CPU_END_Detected = _CPU_END_Detected[i] | _CPU_END_Detected[i+1];
					
			end
	endgenerate
	
/*----------------------------------------------------------------------------------------*/
//																			CPU SIGNALS:
/*----------------------------------------------------------------------------------------*/
	
	wire 	[(NumberOfCores*(NumberOfCores*NumberOfSemaphores))-1	: 0]	_SEMAPHOREARRAY_EN;
	wire 	[(NumberOfCores*(NumberOfCores*NumberOfSemaphores))-1	: 0]	__SEMAPHOREARRAY_EN;
	wire 	[(NumberOfCores*NumberOfSemaphores)-1									: 0]	_SEMAPHOREARRAY_WR;
	wire	[(NumberOfCores*(NumberOfCores*NumberOfSemaphores))-1	: 0]	_SEMAPHOREARRAY_BLOCKING;
	wire	[(NumberOfCores*(NumberOfCores*NumberOfSemaphores))-1	: 0]	__SEMAPHOREARRAY_BLOCKING;
	wire 	[(4*(NumberOfCores*NumberOfSemaphores))-1							: 0] _SEMAPHOREARRAY_CntIn;
	wire  [(4*(NumberOfCores*NumberOfSemaphores))-1							: 0] _SEMAPHOREARRAY_CntOut;
	
	wire 	[(NumberOfCores)-1	:  0]		_SEMAPHOREROUTER_EN;
	wire 	[(NumberOfCores)-1	:  0]		_SEMAPHOREROUTER_CREATE;
	wire 	[(NumberOfCores)-1	:  0]		_SEMAPHOREROUTER_ACQUIRE;
	wire 	[(NumberOfCores)-1	:  0]		_SEMAPHOREROUTER_RELEASE;
	wire 	[(NumberOfCores)-1	:  0]		_SEMAPHOREROUTER_ACK;
	
	
	generate
	for (x=0; x<NumberOfCores; x=x+1) 
	begin
		: generate_EN_x
		for (y=0; y<NumberOfCores; y=y+1) 
		begin
			: generate_SEMAPHORE_y
		
			assign __SEMAPHOREARRAY_EN [(((y*NumberOfCores*NumberOfSemaphores)+((x+1)*NumberOfSemaphores))-1) : ((y*NumberOfCores*NumberOfSemaphores)+((x)*NumberOfSemaphores))] = _SEMAPHOREARRAY_EN [(((x*NumberOfCores+y+1)*NumberOfSemaphores)-1) : ((y+x*NumberOfCores)*NumberOfSemaphores)];
			assign __SEMAPHOREARRAY_BLOCKING [(((x+(y*NumberOfCores)+1)*NumberOfSemaphores)-1) : (((y*NumberOfCores)+x)*NumberOfSemaphores)] = _SEMAPHOREARRAY_BLOCKING [(((x*NumberOfCores*NumberOfSemaphores)+((y+1)*NumberOfSemaphores))-1) : ((x*NumberOfCores*NumberOfSemaphores)+((y)*NumberOfSemaphores))];

		end
	end
	endgenerate
		
	/*----------------------------------------------------------------------------------------------*/
	//CORE ARBITER:
	//Word:
	wire [(NumberOfCores-1):0] 				_WORDCOREARBITER_RAM_WE;
	wire [AddrMSB:0] 									_WORDCOREARBITER_WR;
	wire [AddrMSB:0] 									_WORDCOREARBITER_RR;
	wire [AddrMSB2:0] 								_WORDCOREARBITER_Carry;
	wire [AddrMSB:0]									_WORDCOREARBITER_RAM_ACK;
	//Bit:
	wire [(NumberOfCores-1):0] 				_BITCOREARBITER_RAM_WE;
	wire [AddrMSB:0] 									_BITCOREARBITER_WR;
	wire [AddrMSB:0] 									_BITCOREARBITER_RR;
	wire [AddrMSB2:0] 								_BITCOREARBITER_RR_Carry;
	wire [AddrMSB2:0] 								_BITCOREARBITER_WR_Carry;
	wire [AddrMSB:0]									_BITCOREARBITER_RAM_ACK;
	
	assign _WORDCOREARBITER_Carry[0] 		= 1'b1;
	assign _BITCOREARBITER_RR_Carry[0] 	= 1'b1;
	assign _BITCOREARBITER_WR_Carry[0] 	= 1'b1;
	
	generate	//OR RAM_WE signals:
		for (i = 0; i < NumberOfCores-1; i=i+1)
			begin
				: generate_RAM_WE_identifier
				
					assign PERIPHERALS_RAM_WE = _WORDCOREARBITER_RAM_WE[i] 	| _WORDCOREARBITER_RAM_WE[i+1];
					assign PERIPHERALS_BIT_WE = _BITCOREARBITER_RAM_WE[i] 	| _BITCOREARBITER_RAM_WE[i+1];
					
			end
	endgenerate
		
		
		
	
	
	
/*------------------------------------------------------------------------------------------------*/
/*-----------------------------------------CORES--------------------------------------------------*/
/*------------------------------------------------------------------------------------------------*/
	
generate
	for (i=1; i<=NumberOfCores; i=i+1) 
	begin 
		: generate_CORE_identifier

			if(i < 3)
			begin
			CPU CPU_ 
			(
					.CLK(CLK),
					
					.CPU_HOLD(CPU_HOLD),
					
					//-------------------------- PROGRAMMER -----------------------------
					.PROGRAMMER_Addr(_PROGRAMMER_ROMAddr),
					.PROGRAMMER_Data(_PROGRAMMER_OutputData),	
					
					//----------------------- STATES CONTROLLER -------------------------
					//Input signals:
					.CPU_EN(CPU_EN),
					.CPU_WE(_CPU_WE),
					.CPU_WE_ADDR(_CPU_WE_ADDR[i-1]),
					.CPU_Reset(_CPU_Reset),
					.CPU_ProgramReset(CPU_ProgramReset),
					//Output signals:
					.CPU_END_Detected(_CPU_END_Detected[i-1]),
					
					//------------------------ EXTERNAL MEMORY --------------------------
					//MEMORY Addressing:
					.RAM_ADDR(_CPU_CORE_ADDR[i-1]),
					
					//-------- RAM --------
					//Data:
					.RAM_Data(_CPU_CORE_DATA[i-1]),
					//Driving signals:
					.RAM_WR(_WORDCOREARBITER_WR[i-1]),
					.RAM_RR(_WORDCOREARBITER_RR[i-1]),
					//Ack:
					.RAM_ACK(_WORDCOREARBITER_RAM_ACK[i-1]),
					
					//---- BIT MEMORY ----
					//Data:
					.BITRAM_BIT_DATA(_CPU_CORE_DATA[0][i-1]),
					//Driving signals:
					.BITRAM_WR(_BITCOREARBITER_WR[i-1]),
					.BITRAM_RR(_BITCOREARBITER_RR[i-1]),
					//Ack:
					.BITRAM_RAM_ACK(_BITCOREARBITER_RAM_ACK[i-1]),
					
					//EXTERNAL INTERRUPT
					.INT1_Signal(1'b0),
					
					//SEMAPHORE:
					//Output signals:
					.SEMAPHORE_EN(_SEMAPHOREROUTER_EN[i-1]),
					.SEMAPHORE_CREATE(_SEMAPHOREROUTER_CREATE[i-1]),
					.SEMAPHORE_ACQUIRE(_SEMAPHOREROUTER_ACQUIRE[i-1]),
					.SEMAPHORE_RELEASE(_SEMAPHOREROUTER_RELEASE[i-1]),

					.SEMAPHORE_ACK(_SEMAPHOREROUTER_ACK[i-1])
				);
			end
	end
endgenerate	

/*------------------------------------------------------------------------------------------------*/
/*-----------------------------------------CORES--------------------------------------------------*/
/*------------------------------------------------------------------------------------------------*/




generate
	for (i=1; i<=NumberOfCores; i=i+1) 
	begin 
		: generate_PERIPHERALS_identifier
		
/*----------------------------------------------------------------------------------------*/
//																				SEMAPHORES
/*----------------------------------------------------------------------------------------*/
		
		SEMAPHORE_ROUTER _SEMAPHORE_ROUTER
		(
			.CLK(CLK),	
			.SEMAPHOREROUTER_RESET(CPU_ProgramReset),
			
			//-------------------------- DRIVING SIGNALS -----------------------------
			//Core - Router:
			.SEMAPHOREROUTER_EN_FromCPU(_SEMAPHOREROUTER_EN[i-1]),
			.SEMAPHOREROUTER_CREATE_FromCPU(_SEMAPHOREROUTER_CREATE[i-1]),
			.SEMAPHOREROUTER_ACQUIRE_FromCPU(_SEMAPHOREROUTER_ACQUIRE[i-1]),
			.SEMAPHOREROUTER_RELEASE_FromCPU(_SEMAPHOREROUTER_RELEASE[i-1]),
			//Router - Semaphore:
			.SEMAPHOREROUTER_EN_ToSemaphore(_SEMAPHOREARRAY_EN[ ((i*NumberOfCores*NumberOfSemaphores)-1) : (i-1)*(NumberOfCores*NumberOfSemaphores)]),
			.SEMAPHOREROUTER_WR_toSemaphore(_SEMAPHOREARRAY_WR),

			//Ack:
			.SEMAPHOREROUTER_ACK(_SEMAPHOREROUTER_ACK[i-1]),
			//Semaphore busy:
			.SEMAPHOREROUTER_BLOCKING_FromSemaphore(__SEMAPHOREARRAY_BLOCKING[(NumberOfCores*NumberOfSemaphores*(i))-1:(NumberOfCores*NumberOfSemaphores*(i-1))]),

			//------------------------------ DATA -----------------------------------
			//Core - Router:
			.SEMAPHOREROUTER_Data_fromCPU(_CPU_CORE_DATA[i-1][3:0]),
			.SEMAPHOREROUTER_Addr_FromCPU(_CPU_CORE_ADDR[i-1][7:0]),
	
			//Router - Semaphore:
			.SEMAPHOREROUTER_CntOut(_SEMAPHOREARRAY_CntOut),
			.SEMAPHOREROUTER_CntIn(_SEMAPHOREARRAY_CntIn)
		);
		
		SEMAPHORE_ARRAY _SEMAPHORE_ARRAY
		(
			.CLK(CLK),
			.SEMAPHOREARRAY_RESET(CPU_ProgramReset),

			//---------------- Driving signals --------------------
			.SEMAPHOREARRAY_EN(__SEMAPHOREARRAY_EN[(NumberOfCores*NumberOfSemaphores*(i))-1:(NumberOfCores*NumberOfSemaphores*(i-1))]),
			.SEMAPHOREARRAY_WR(_SEMAPHOREARRAY_WR[(NumberOfSemaphores+NumberOfSemaphores*(i-1))-1:(NumberOfSemaphores*(i-1))]),
			//~Ack:
			.SEMAPHOREUNIT_BLOCKING(_SEMAPHOREARRAY_BLOCKING[(NumberOfCores*NumberOfSemaphores*(i))-1:((NumberOfCores*NumberOfSemaphores)*(i-1))]),

			//------------------- Data  ---------------------------
			//Data Semaphores - Router
			.SEMAPHOREARRAY_CntIn (_SEMAPHOREARRAY_CntIn [(4*(NumberOfSemaphores+NumberOfSemaphores*(i-1)) )-1: (4*NumberOfSemaphores*(i-1))]),
			.SEMAPHOREARRAY_CntOut(_SEMAPHOREARRAY_CntOut[(4*(NumberOfSemaphores+NumberOfSemaphores*(i-1)) )-1: (4*NumberOfSemaphores*(i-1))])
		);

/*----------------------------------------------------------------------------------------*/
//																				MEMORY ARBITERS
/*----------------------------------------------------------------------------------------*/	
			
		WORDCORE_ARBITER _WORDCORE_ARBITER
		(
			.CLK(CLK),
			
			//------------------- Carry in ------------------------
			.WORDCOREARBITER_Prev		(_WORDCOREARBITER_Carry		[i-1]),
			
			//---------------- Driving signals --------------------
			.WORDCOREARBITER_WE			(_WORDCOREARBITER_WR			[i-1]),
			.WORDCOREARBITER_RR			(_WORDCOREARBITER_RR			[i-1]),
			.WORDCOREARBITER_RAM_WE	(_WORDCOREARBITER_RAM_WE	[i-1]),
			//Ack:
			.WORDCOREARBITER_ACK		(_WORDCOREARBITER_RAM_ACK[i-1]),	
			
			//------------------- Data  ---------------------------
			//Core - Arbiter
			.WORDCOREARBITER_CORE_DATA	(_CPU_CORE_DATA	[i-1]),
			.WORDCOREARBITER_CORE_ADDR	(_CPU_CORE_ADDR	[i-1]),
			//Arbiter - Peripherals:
			.WORDCOREARBITER_RAM_DATA		(PERIPHERALS_RAM_DATA),
			.WORDCOREARBITER_RAM_ADDR		(PERIPHERALS_RAM_ADDR),		
			
			//----------------- Carry out -------------------------
			.WORDCOREARBITER_CarryOut(_WORDCOREARBITER_Carry[i])
		);
		
		BITCORE_ARBITER _BITCORE_ARBITER
		(
			.CLK(CLK),
			
			//------------------- Carry in ------------------------
			.BITCOREARBITER_WE_Prev(_BITCOREARBITER_WR_Carry[i-1]),
			.BITCOREARBITER_RR_Prev(_BITCOREARBITER_RR_Carry[i-1]),
			
			//---------------- Driving signals --------------------
			.BITCOREARBITER_WE			(_BITCOREARBITER_WR			[i-1]),
			.BITCOREARBITER_RR			(_BITCOREARBITER_RR			[i-1]),
			.BITCOREARBITER_RAM_WE	(_BITCOREARBITER_RAM_WE	[i-1]),
			//Ack:
			.BITCOREARBITER_ACK			(_BITCOREARBITER_RAM_ACK[i-1]),	
			
			//------------------- Data  ---------------------------
			//Core - Arbiter
			.BITCOREARBITER_CORE_WriteDATA(_CPU_CORE_DATA[0][i-1]),
			.BITCOREARBITER_CORE_ReadDATA(_CPU_CORE_DATA[0][i-1]),
			.BITCOREARBITER_CORE_ADDR			(_CPU_CORE_ADDR		[i-1]),
			//Arbiter - Peripherals:
			.BITCOREARBITER_RAM_WriteDATA	(PERIPHERALS_BIT_OutDATA),
			.BITCOREARBITER_RAM_WriteADDR	(PERIPHERALS_BIT_OutADDR),
			.BITCOREARBITER_RAM_ReadDATA	(PERIPHERALS_BIT_InDATA),
			.BITCOREARBITER_RAM_ReadADDR	(PERIPHERALS_BIT_InADDR),

			//----------------- Carry out -------------------------
			.BITCOREARBITER_WE_CarryOut(_BITCOREARBITER_WR_Carry[i]),
			.BITCOREARBITER_RR_CarryOut(_BITCOREARBITER_RR_Carry[i])
		);
		
	end
endgenerate	


endmodule 