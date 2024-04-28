module CPU
#
(
	parameter CounterBits = 6,
	parameter FetchBits   = 8
)
(
	input	wire					CLK,
	
	input wire					CPU_HOLD,
		
	//--------- PROGRAMMER ----------------
	//Data;
	input wire	[3:0]		PROGRAMMER_Addr,
	input wire	[7:0]		PROGRAMMER_Data,
	//In:
	input wire					CPU_EN,
	input wire					CPU_WE,
	input wire 					CPU_WE_ADDR,
	input wire 					CPU_Reset,
	input wire 					CPU_ProgramReset,
	//Out:
	output wire 				CPU_END_Detected,	
	
	
	//--------- DATA BUS ------------------
	output wire [15:0] 	RAM_ADDR,
	//Word:
	inout wire  [7:0] 	RAM_Data,
	//Bit:
	inout  wire 				BITRAM_BIT_DATA,

	//--------- WORD MEMORY ---------------
	output wire					RAM_WR,
	output wire					RAM_RR,
	
	input wire					RAM_ACK,
	//--------- BIT MEMORY ----------------
	output wire 				BITRAM_WR,
	output wire 				BITRAM_RR,
	//Ack:
	input wire 					BITRAM_RAM_ACK,

	//------ EXTERNAL INTERRUPT -----------
	
	input wire					INT1_Signal,
	
	//--------- SEMAPHORES ----------------
	output wire 				SEMAPHORE_EN,
	output wire 				SEMAPHORE_CREATE,
	output wire 				SEMAPHORE_ACQUIRE,
	output wire 				SEMAPHORE_RELEASE,
	//Ack:
	input  wire					SEMAPHORE_ACK
);



wire [(FetchBits - 1) : 0] 		_DATA_BUS;

/*----------------------------------------------------------------------------------------*/
//																				 DATA ROUTER
/*----------------------------------------------------------------------------------------*/
wire 													_DATABUSBUFFER_SetBusOutput;
/*----------------------------------------------------------------------------------------*/
//																				ROM
/*----------------------------------------------------------------------------------------*/	
wire [(FetchBits - 1) : 0] 		_CPU_ROM_OutputData;
/*----------------------------------------------------------------------------------------*/
//																		PROGRAM COUNTER
/*----------------------------------------------------------------------------------------*/
wire [(CounterBits - 1) : 0] 	_PC_Counter;
/*----------------------------------------------------------------------------------------*/
//																		INTERNAL MEMORY
/*----------------------------------------------------------------------------------------*/
//REGISTERS:
wire [(FetchBits - 1) : 0] 		_REGISTERS_OutputData;

wire 													_FIFO_RD;
wire													_FIFO_WR;

//BIT UNIT:
wire _BIT_UNIT_A;

//WORD UNIT:
wire [(FetchBits - 1) : 0] 		_WORD_UNIT_A;
wire 							 				 		_WORD_UNIT_OV;
wire 											 		_WORD_UNIT_ComparatorResoult;



/*----------------------------------------------------------------------------------------*/
//																		INTERNAL MEMORY
/*----------------------------------------------------------------------------------------*/
wire _TIMER1_EN;
wire _TIMER_WR_MSB;
wire _TIMER_WR_LSB;
	
wire _TIMER_SET_REGISTER;
	
wire _TIMER1_OV_Read;
wire _TIMER1_OV_Flag;

/*----------------------------------------------------------------------------------------*/
//																		CONTROL UNIT
/*----------------------------------------------------------------------------------------*/
//WORD UNIT:
wire _OV_EN;
wire _EXE_WORDUNIT_A_WE;
wire _EXE_WORDUNIT_B_WE;
wire _EXE_COMPARATORREG_EN;
wire _EXE_OV_CLR;

//BIT UNIT:
wire _EXE_BITUNIT_A_WE;

//Program JMP:
wire _EXE_CPU_SetStop;
wire _EXE_PC_COUNTER_Set_JMP;

//MEMORY DATA:
wire _EXE_SetBitData;

//INTERNAL MEMORY:
wire _EXE_RegisterWE;


	

/*

	WYKONYWANIE ROZKAZOW:
	[DATA] -> [ADDR >> 8] -> [ADDR] 

*/
	
	
	
/*----------------------------------------------------------------------------------------*/
//																				 DATA ROUTER
/*----------------------------------------------------------------------------------------*/
	
DATABUS_BUFFER _DATABUS_BUFFER
(
	// ---- INPUT ----
	//Control:
	.DATABUSBUFFER_SetBusOutput(_DATABUSBUFFER_SetBusOutput),
	.DATABUSBUFFER_SetBitData(_EXE_SetBitData),
	
	//Data:
	.DATABUSBUFFER_WordData(_WORD_UNIT_A),
	.DATABUSBUFFER_BitData(_BIT_UNIT_A),
	// --- OUTPUT ---
	.DATABUSBUFFER_RAMData(RAM_Data)
);
	
/*----------------------------------------------------------------------------------------*/
//																				PROGRAM COUNTER
/*----------------------------------------------------------------------------------------*/	

PC_COUNTER #
(
	.CounterBits(CounterBits)
)
_PC_COUNTER
(
	.CLK(CLK),
	
	.CPU_SetReset(CPU_ProgramReset),											//		STATES CONTROLLER
	
	//JUMP:
	//Addr:
	.PC_JMPAddr(_DATA_BUS),
	//Driver inputs: 
	.PC_SetJmp(_EXE_PC_COUNTER_Set_JMP),									//EXE

	.PC_SetStop(_EXE_CPU_SetStop || !CPU_EN || CPU_HOLD),	//EXE, STATES CONTROLLER
	
	//OUTPUT ADDRESS:
	.PC_Counter(_PC_Counter)
);


/*----------------------------------------------------------------------------------------*/
//																				PROGRAM MEMORY
/*----------------------------------------------------------------------------------------*/	

//ROM:
CPU_ROM #
(
	.CounterBits(CounterBits)
)
_CPU_ROM
(
	//BASIC:
	.CLK(CLK),
	
	//PROGRAMMER:
	.PCRam_WE(CPU_WE_ADDR),											//PROGRAMMER
	.PCRam_EN(CPU_WE),													//PROGRAMMER

	.PCRam_ProgrammerData(PROGRAMMER_Data),
	.PCRam_ProgrammerAddr(PROGRAMMER_Addr),
	
	//CPU
	//Addr:
	.PCRam_InstructionAddr(_PC_Counter),
	//Data:
	.PCRAM_OutputData(_CPU_ROM_OutputData)
);

/*----------------------------------------------------------------------------------------*/
//																				INTERNAL MEMORY
/*----------------------------------------------------------------------------------------*/	
TIMERS _TIMERS
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),

	.TIMER1_EN(_TIMER1_EN),
	
	.TIMER_WR_MSB(_TIMER_WR_MSB),
	.TIMER_WR_LSB(_TIMER_WR_LSB),
	
	.TIMER_SET_REGISTER(_TIMER_SET_REGISTER),
	
	.TIMERS_DATA(_DATA_BUS),
	
	.TIMER1_OV_Read(_TIMER1_OV_Read),
	.TIMER1_OV_Flag(_TIMER1_OV_Flag)
);



REGISTERS _REGISTERS
(
	.CLK(CLK),
	
	.CPU_Reset(CPU_Reset),
	
	//STACK:
	.FIFO_RD(_FIFO_RD),
	.FIFO_WR(_FIFO_WR),
	.FIFO_EmptySignal(),//NC
	.FIFO_FullSignal(),//NC
	
	
	//INPUT:
	.REGISTERS_WE(_EXE_RegisterWE),							//EXE
	.REGISTERS_SetBitData(_EXE_SetBitData),			//EXE
	
	.REGISTERS_ADDR			(_DATA_BUS[1:0]),
	
	.REGISTERS_BitData	(_BIT_UNIT_A),					
	.REGISTERS_WordData	(_WORD_UNIT_A),					
	
	//OUTPUT:
	.REGISTERS_OutData	(_REGISTERS_OutputData)
);

/*----------------------------------------------------------------------------------------*/
//																		LOGIC - ARITHMETIC UNIT
/*----------------------------------------------------------------------------------------*/	
	
BIT_UNIT _BIT_UNIT
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),
	
	//LU
	.BITUNIT_LU_OPCode(_DATA_BUS[1:0]),		//OPCODE
	
	//A INPUT:
	.BITUNIT_A_WE(_EXE_BITUNIT_A_WE),								//EXE
	.BITUNIT_A_OPCode(_DATA_BUS[2:0]),		//OPCODE
	
	//B INPUT:
	.BITUNIT_B_OPCode(_DATA_BUS[1:0]),		//OPCODE
	
	//Word Unit:
	//OV:
	.BITUNIT_OVResoult(_WORD_UNIT_OV),							
	
	//Comparator:
	.BITUNIT_ComparatorResoult(_WORD_UNIT_ComparatorResoult),
	
	//DATA INPUT:
	//ProgMem:
	.BITUNIT_ArgToSet(_DATA_BUS[3]),			
	//RAM:
	.BITUNIT_RAMData(RAM_Data[0]),
	//Registers:
	.BITUNIT_Registers(_REGISTERS_OutputData[0]),
	//Semaphore:
	.BITUNIT_Semaphore(BITRAM_BIT_DATA),
	
	// Outputs:	
	//A:
	.BITUNIT_A(_BIT_UNIT_A)
);

WORD_UNIT _WORD_UNIT
(
	//Basic:
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),
	
	//ALU 
	.COMPARATORREG_EN(_EXE_COMPARATORREG_EN),
	.WORDUNIT_ALU_OPCode(_DATA_BUS[3:0]),
	//OV:
	.OV_EN(_OV_EN),

	//A INPUT:
	.WORDUNIT_A_WE(_EXE_WORDUNIT_A_WE),
	.WORDUNIT_A_OPCode(_DATA_BUS[1:0]),
	
	//B INPUT:
	.WORDUNIT_B_WE(_EXE_WORDUNIT_B_WE),
	.WORDUNIT_B_OPCode(_DATA_BUS[1:0]),

	//DATA INPUT:
	//ProgMem:
	.WORDUNIT_ArgToSet(_DATA_BUS),
	//RAM
	.WORDUNIT_RAMData(RAM_Data),
	//REGISTERS
	.WORDUNIT_Register(_REGISTERS_OutputData),
	
	// Outputs:	
	//OV:
	.WORDUNIT_OV(_WORD_UNIT_OV),
	//Comparator:
	.WORDUNIT_ComparatorResoult(_WORD_UNIT_ComparatorResoult),
	//A:
	.WORDUNIT_A(_WORD_UNIT_A) 
);


/*----------------------------------------------------------------------------------------*/
//																				CONTROL UNIT
/*----------------------------------------------------------------------------------------*/	

CONTROL_UNIT _CONTROL_UNIT
(
	.CLK(CLK),
	
	.CPU_HOLD(CPU_HOLD),
	//Programmer:
	.CPU_Reset(CPU_Reset),
	
	// ---- CONTROL UNIT SIGNALS ----
	.ROM_InputData(_CPU_ROM_OutputData),
	
	.EXE_CPU_SetStop(_EXE_CPU_SetStop),
	
	// ------- CPU SIGNALS ----------
	//INPUTS:
	
	//ACK:
	.RAM_ACK(RAM_ACK),
	.BITRAM_RAM_ACK(BITRAM_RAM_ACK),
	.EXE_SEMAPHORE_ACK(SEMAPHORE_ACK),
	
	//JMP Mux:
	.BIT_UNIT_A(_BIT_UNIT_A),
	.WORD_UNIT_OV(_WORD_UNIT_OV),
	.WORD_UNIT_ComparatorResoult(_WORD_UNIT_ComparatorResoult),
	
	//PC Counter:
	.PC_Counter(_PC_Counter),
	
	//OUT ADDR:
	.CONTROLUNIT_RAM_ADDR(RAM_ADDR),
	
	//OUTPUTS:
	//RAM Memory:
	.CONTROLUNIT_RAM_WR(RAM_WR),
	.CONTROLUNIT_RAM_RR(RAM_RR),
	
	//Bit Memory:
	.BITRAM_WR(BITRAM_WR),
	.BITRAM_RR(BITRAM_RR),
	
	//Semaphores:
	.EXE_SEMAPHORE_EN(SEMAPHORE_EN),
	.EXE_SEMAPHORE_CREATE(SEMAPHORE_CREATE),
	.EXE_SEMAPHORE_ACQUIRE(SEMAPHORE_ACQUIRE),
	.EXE_SEMAPHORE_RELEASE(SEMAPHORE_RELEASE),
	
	//Comparator:
	.CONTROLUNIT_COMPARATORREG_EN(_EXE_COMPARATORREG_EN),

	//OV Flag:
	.CONTROLUNIT_OV_EN(_OV_EN),

	//Word Unit:
	.CONTROLUNIT_WORD_UNIT_B_WE(_EXE_WORDUNIT_B_WE),
	.CONTROLUNIT_WORD_UNIT_A_WE(_EXE_WORDUNIT_A_WE),
	
	//BIT UNIT:
	.CONTROLUNIT_BIT_UNIT_A_WE(_EXE_BITUNIT_A_WE),
	
	//CORE REGISTERS:
	.CONTROLUNIT_REGISTERS_WE(_EXE_RegisterWE),
	.CONTROLUNIT_SetBitData(_EXE_SetBitData),
	
	//Stack:
	.CONTROLUNIT_FIFO_RD(_FIFO_RD),
	.CONTROLUNIT_FIFO_WR(_FIFO_WR),

	//END:
	.CONTROLUNIT_CPU_END_Detected(CPU_END_Detected),
	
	// ------- OUTPUT BUS ---------
	.DATABUSBUFFER_SetBusOutput(_DATABUSBUFFER_SetBusOutput),
	
	//---------- EXTERNAL INTERRUPT
	
	.INT1(INT1_Signal),
	
	//---------- TIMERS -----------
	
	.TIMER1_OV_Flag(_TIMER1_OV_Flag),
	
	.TIMER1_EN(_TIMER1_EN),
	.TIMER_WR_MSB(_TIMER_WR_MSB),
	.TIMER_WR_LSB(_TIMER_WR_LSB),
		
	.TIMER_SET_REGISTER(_TIMER_SET_REGISTER),

	.TIMER1_OV_Read(_TIMER1_OV_Read),
	
	.DATA_BUS(_DATA_BUS)
);


endmodule 