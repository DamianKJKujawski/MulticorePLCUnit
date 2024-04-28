module CPU_UNIT
#
(
	parameter NumberOfSemaphores = 4,
	parameter NumberOfCores      = 4
)
(
	input wire					CLK,
	
	input wire					CPU_HOLD,
	
	// -------- POWER SUPPLY -----------
	input wire					PS,
	
	// -------------- IO ---------------
	input	 wire	[15:0] 	INPUTS,
	output wire	[15:0] 	OUTPUTS,
	
	// --------- PROGRAMMER ------------
	input  wire					PROGRAMMER_Reset,
	input	 wire	[7:0]		PROGRAMMER_InputData,
	input	 wire					PROGRAMMER_PCK,
	input	 wire					PROGRAMMER_SCK,
	//Ack:
	output wire 				PROGRAMMER_ACK,
	
	// --------- DIAGNOSTICS -----------
	input  wire					DIAGNOSTIC_WAIT
);


/*----------------------------------------------------------------------------------------*/
//																		STATES CONTROLLER
// STATES CONTROLLER, allows to stop processor during programming or reset program cyckle
/*----------------------------------------------------------------------------------------*/

wire _STATESCONTROLLER_CPU_Reset;						//Reset CPU
wire _STATESCONTROLLER_CPU_ProgramReset;		//Reset program, and update IO
wire _STATESCONTROLLER_BITPERIPHERALS_READ;	//IO update: Inputs
wire _STATESCONTROLLER_BITPERIPHERALS_WRITE;//IO update: Outputs
wire _STATESCONTROLLER_CPU_EN;							//Stop CPU:

/*----------------------------------------------------------------------------------------*/
//																			   CORES
/*----------------------------------------------------------------------------------------*/

wire _CORES_CPU_END_Detected;
	
/*----------------------------------------------------------------------------------------*/
//																			 PERIPHERALS
/*----------------------------------------------------------------------------------------*/

//Bit bus:
wire				 _PERIPHERALS_BIT_WE;
wire  [15:0] _PERIPHERALS_BIT_InADDR;
wire  			 _PERIPHERALS_BIT_InDATA;
wire  [15:0] _PERIPHERALS_BIT_OutADDR;
wire 				 _PERIPHERALS_BIT_OutDATA;
//Word bus:
wire 				 _PERIPHERALS_RAM_WE;
wire  [15:0] _PERIPHERALS_RAM_ADDR;
wire  [7 :0] _PERIPHERALS_RAM_DATA;
	
/*----------------------------------------------------------------------------------------*/
//																		 STATES CONTROLLER
/*----------------------------------------------------------------------------------------*/

STATES_CONTROLLER _STATES_CONTROLLER
(
	.CLK(CLK),
	
	// ----------- INPUTS ----------------
	//Power supply:
	.PS(PS),
	
	//Programmer:
	.PROGRAMMMER_Reset(PROGRAMMER_Reset),
	
	//Diagnostics:
	.STATESCONTROLLER_WAIT(DIAGNOSTIC_WAIT), //WAIT Signal - Stop for diagnostics -> If WAIT = 1 -> Program stops (Diagnostic procedure

	//Cores:
	.STATESCONTROLLER_CPU_END_Detected(_CORES_CPU_END_Detected), //END Signal from Cores -> (If END detected, processor shall go to IO_UPDATE state and then reset cycle if WAIT = 0 / END signal also allows to detect CPU Stuc
	
	// ----------- OUTPUTS ---------------
	//CPU:
	.STATESCONTROLLER_CPU_ProgramReset(_STATESCONTROLLER_CPU_ProgramReset),
	.STATESCONTROLLER_CPU_Reset(_STATESCONTROLLER_CPU_Reset),
	.STATESCONTROLLER_CPU_EN(_STATESCONTROLLER_CPU_EN),
	
	//IO:
	.STATESCONTROLLER_BITPERIPHERALS_READ(_STATESCONTROLLER_BITPERIPHERALS_READ),
	.STATESCONTROLLER_BITPERIPHERALS_WRITE(_STATESCONTROLLER_BITPERIPHERALS_WRITE),
	
	//Programmer:
	.STATESCONTROLLER_ACK(PROGRAMMER_ACK) //If programmer is connected -> ACK = 1 tells that programming mode is available
);

/*----------------------------------------------------------------------------------------*/
//																		    CORES  
/*----------------------------------------------------------------------------------------*/

CORES #
(
	.NumberOfCores(NumberOfCores),
	.NumberOfSemaphores(NumberOfSemaphores)
)
_CORES
(
	.CLK(CLK),
	
	// ----------- INPUTS ----------------
	//States controller:
	.CPU_ProgramReset(_STATESCONTROLLER_CPU_ProgramReset),
	.CPU_EN(_STATESCONTROLLER_CPU_EN),
	.CPU_HOLD(CPU_HOLD),
	
	//Programmer:
	.PROGRAMMER_RESET(_STATESCONTROLLER_CPU_Reset),
	.PROGRAMMER_DIN(PROGRAMMER_InputData),
	.PROGRAMMER_PCK(PROGRAMMER_PCK),
	.PROGRAMMER_SCK(PROGRAMMER_SCK),
	
	// ----------- OUTPUTS ---------------
	.CORES_CPU_END_Detected(_CORES_CPU_END_Detected),
	
	// --------- PERIPHERALS ---------------				
	//BIT and WORD peripherals are separated:
	
	// --- WORD ---
	//Out:
	.PERIPHERALS_RAM_WE(_PERIPHERALS_RAM_WE),
	.PERIPHERALS_RAM_ADDR(_PERIPHERALS_RAM_ADDR),
	//Bus:
	.PERIPHERALS_RAM_DATA(_PERIPHERALS_RAM_DATA),
	
	// --- BIT --- 
	//Out:
	.PERIPHERALS_BIT_WE(_PERIPHERALS_BIT_WE),
	.PERIPHERALS_BIT_OutADDR(_PERIPHERALS_BIT_OutADDR),
	.PERIPHERALS_BIT_OutDATA(_PERIPHERALS_BIT_OutDATA),
	//In:
	.PERIPHERALS_BIT_InADDR(_PERIPHERALS_BIT_InADDR),
	.PERIPHERALS_BIT_InDATA(_PERIPHERALS_BIT_InDATA)

);

/*----------------------------------------------------------------------------------------*/
//																		   PERIPHERALS  
/*----------------------------------------------------------------------------------------*/

PERIPHERALS _PERIPHERALS
(
	.CLK(CLK),

	// ------------ INPUTS -----------------
	//States controller:
	.BITPERIPHERALS_READ(_STATESCONTROLLER_BITPERIPHERALS_READ),
	.BITPERIPHERALS_WRITE(_STATESCONTROLLER_BITPERIPHERALS_WRITE),
	
	// --------------- IO ------------------
	.INPUTS(INPUTS),
	.OUTPUTS(OUTPUTS),
	
	// -------- STATES CONTROLLER ----------
	.PERIPHERALS_BIT_EN(_STATESCONTROLLER_CPU_EN),
	.PERIPHERALS_EN(_STATESCONTROLLER_CPU_EN),
	
	// ------------- BIT -------------------
	//In:
	.PERIPHERALS_BIT_WE(_PERIPHERALS_BIT_WE),
	
	.PERIPHERALS_BIT_InADDR(_PERIPHERALS_BIT_InADDR),
	.PERIPHERALS_BIT_InDATA(_PERIPHERALS_BIT_InDATA),
	//Out:
	.PERIPHERALS_BIT_OutADDR(_PERIPHERALS_BIT_OutADDR),
	.PERIPHERALS_BIT_OutDATA(_PERIPHERALS_BIT_OutDATA),
	
	
	// ------------- WORD ------------------
	//In:
	.PERIPHERALS_WE(_PERIPHERALS_RAM_WE),
	.PERIPHERALS_ADDR(_PERIPHERALS_RAM_ADDR),
	//Bus:
	.PERIPHERALS_DATA(_PERIPHERALS_RAM_DATA)
);





endmodule 