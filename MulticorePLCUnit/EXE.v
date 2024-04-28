module CONTROL_UNIT
(	
	input wire 					CLK,
	
	input wire					CPU_HOLD,
	
	//Programmer:
	input wire					CPU_Reset,

/*----------------------------------------------------------------------------------------*/
//																 CONTROL UNIT SIGNALS
/*----------------------------------------------------------------------------------------*/
	
	//Input ROM data:
	input wire [7:0] 		ROM_InputData,
	
	output wire					EXE_CPU_SetStop,	//Stops CPU and block control unit registers:
	
/*----------------------------------------------------------------------------------------*/
//																		 CPU SIGNALS
/*----------------------------------------------------------------------------------------*/

	// ------------------------ INPUTS ------------------------
	
	//ACK
	input wire					RAM_ACK,
	input wire					BITRAM_RAM_ACK,
	input wire					EXE_SEMAPHORE_ACK,

	//JMP MUX: 
	input wire 					BIT_UNIT_A,
	input wire 					WORD_UNIT_OV,
	input wire 					WORD_UNIT_ComparatorResoult,
	
	//PC Counter
	input wire 					PC_Counter,
	
	// ------------------------ OUT ADDR ------------------------
	
	output wire [15:0] 	CONTROLUNIT_RAM_ADDR,
	
	// ------------------------ OUTPUTS ------------------------

	//RAM memory:
	output wire					CONTROLUNIT_RAM_WR,
	output wire					CONTROLUNIT_RAM_RR,
	
	//Bit memory:
	output wire 				BITRAM_WR,
	output wire 				BITRAM_RR,
	
	//Semaphores:
	output wire 				EXE_SEMAPHORE_EN,
	
	output wire 				EXE_SEMAPHORE_CREATE,
	output wire 				EXE_SEMAPHORE_ACQUIRE,
	output wire 				EXE_SEMAPHORE_RELEASE,
	
	//Comparator:
	output wire 				CONTROLUNIT_COMPARATORREG_EN,
	
	//OV Flag:
	output wire					CONTROLUNIT_OV_EN,
	
	//Word Unit:
	output wire 				CONTROLUNIT_WORD_UNIT_B_WE,
	output wire 				CONTROLUNIT_WORD_UNIT_A_WE,

	//BIT UNIT:
	output wire 				CONTROLUNIT_BIT_UNIT_A_WE,
	
	//CORE REGISTERS:
	output wire 				CONTROLUNIT_REGISTERS_WE,
	output wire 				CONTROLUNIT_SetBitData,				//Choose to save BIT data instead of WORD
	//Stack:
	output wire 				CONTROLUNIT_FIFO_RD,
	output wire					CONTROLUNIT_FIFO_WR,
	
	//END
	output wire 				CONTROLUNIT_CPU_END_Detected,

	// ----------------------- OUTPUT BUS ----------------------
	output wire					DATABUSBUFFER_SetBusOutput,
	
	// ------------------------- EXTERNAL INTERRUPT -------------
	input wire	INT1,
	
	// ------------------------- TIMERS ------------------------
	input wire 	TIMER1_OV_Flag,
	
	output wire TIMER1_EN,
	output wire TIMER_WR_MSB,
	output wire TIMER_WR_LSB,
		
	output wire TIMER_SET_REGISTER,

	output wire TIMER1_OV_Read,
	
	output wire DATA_BUS
);		


/*----------------------------------------------------------------------------------------*/
//																		 REGISTERS
/*----------------------------------------------------------------------------------------*/

	wire [7:0] I_Stage  = ROM_InputData;
	reg  [7:0] II_Stage;
	reg  [7:0] III_Stage;
	

	//ADDRESSING:
	reg [7:0] RAM_ADDR_MSB;
	reg [7:0] RAM_ADDR_LSB;
	
	assign CONTROLUNIT_RAM_ADDR[15:8] = RAM_ADDR_MSB; 
	assign CONTROLUNIT_RAM_ADDR[ 7:0] = RAM_ADDR_LSB;

/*----------------------------------------------------------------------------------------*/
//																		   FLAGS
/*----------------------------------------------------------------------------------------*/

	reg _WORD_UNIT_SEMAPHORE_Flag;

/*----------------------------------------------------------------------------------------*/
//																	  TESTBENCH INIT
/*----------------------------------------------------------------------------------------*/
	
	initial begin
		_WORD_UNIT_SEMAPHORE_Flag = 0;
		RAM_ADDR_MSB = 0;
		RAM_ADDR_LSB = 0;
		II_Stage  = 0;
		III_Stage = 0;
		_TIMER1_INT = 0;
		_INT1_INT = 0;
		_INTERRUPT_SIGNAL = 0;
	end
	
/*----------------------------------------------------------------------------------------*/
//															 INTERRUPT CONTROLLER
/*----------------------------------------------------------------------------------------*/	

	reg  _TIMER1_INT;
	wire CLR_TIMER1_INT;
	reg  _INT1_INT;
	wire CLR_INT1_INT;
	
	reg _INTERRUPT_SIGNAL;
	
	//Timer:
	always @(posedge CLK)
	begin
		if(TIMER1_OV_Flag)
			_TIMER1_INT = 1'b1;
		else if(CLR_TIMER1_INT)
			_TIMER1_INT = 1'b0;
	end
	//External interrupt;
	always @(posedge CLK)
	begin
		if(INT1)
				_INT1_INT = 1'b1;
		else if(CLR_INT1_INT)
				_INT1_INT = 1'b0;
	end
	
	
/*----------------------------------------------------------------------------------------*/
//																	JMP Controller
/*----------------------------------------------------------------------------------------*/
	
	//JMP controller:
		wire _JMPMUX_JMP_EN;
	JMP_MUX _JMP_MUX
	(
		.ROM_InputData(ROM_InputData),

		.BIT_UNIT_A(BIT_UNIT_A),
		.WORD_UNIT_OV(WORD_UNIT_OV),
		.WORD_UNIT_ComparatorResoult(WORD_UNIT_ComparatorResoult),
		.WORD_UNIT_SEMAPHORE_Flag(_WORD_UNIT_SEMAPHORE_Flag),

		.JMPMUX_JMP_EN(_JMPMUX_JMP_EN)
	);

/*----------------------------------------------------------------------------------------*/
//																	I STAGE
/*----------------------------------------------------------------------------------------*/

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
/*----------------------------------------------------------------------------------------*/
//																	II STAGE
/*----------------------------------------------------------------------------------------*/



















/*----------------------------------------------------------------------------------------*/
//																III STAGE
/*----------------------------------------------------------------------------------------*/
	
	
	
endmodule 