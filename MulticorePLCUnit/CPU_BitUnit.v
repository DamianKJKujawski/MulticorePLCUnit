module BIT_UNIT
(
	// Basic:
	input  wire 				CLK,
	input  wire 				CPU_Reset,
	
	//LU 
	input  wire 	[1:0] BITUNIT_LU_OPCode,

	//A INPUT:
	input wire 					BITUNIT_A_WE,
	input wire 		[2:0] BITUNIT_A_OPCode,
	
	//B INPUT:
	input wire 	 	[1:0]	BITUNIT_B_OPCode,
	
	//Word Unit:
	//OV:
	input  wire					BITUNIT_OVResoult,
	
	//Comparator:
	input  wire 				BITUNIT_ComparatorResoult,
	
	//DATA INPUT:
	//ProgMem:
	input  wire 		  	BITUNIT_ArgToSet,
	//RAM:
	input  wire 		  	BITUNIT_RAMData,
	//Semaphore:
	input  wire 				BITUNIT_Semaphore,
	//Registers:
	input  wire 				BITUNIT_Registers,

	// Outputs:	
	//A:
	output wire 				BITUNIT_A
);


// REGs:
//_B:
wire 	B;
//_LU:
wire 	LU_Resoult;


RLO_REG _A
(
	// Basic:
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),

	//Control:
	.RLO_EN(BITUNIT_A_WE),
	.RLO_OPCode(BITUNIT_A_OPCode),
	
	//Input data:
	.RLO_ArgToSet(BITUNIT_ArgToSet),
	.RLO_RAMData(BITUNIT_RAMData),
	.RLO_Registers(BITUNIT_Registers),
	.RLO_LU_Resoult(LU_Resoult),
	.RLO_OVResoult(BITUNIT_OVResoult),
	.RLO_ComparatorResoult(BITUNIT_ComparatorResoult),
	.RLO_Semaphore(BITUNIT_Semaphore),
	
	//Output data:
	.RLO(BITUNIT_A)
);


ARG_REG _B
(
	//Control:
	.ARG_OPCode(BITUNIT_B_OPCode),
	
	//Input data:
	.ARG_ArgToSet(BITUNIT_ArgToSet),
	.ARG_RAMData(BITUNIT_RAMData),
	.ARG_Register(BITUNIT_Registers),
	
	//Output data:
	.ARG(B)
);


LU _LU
(
	.LU_OPCode(BITUNIT_LU_OPCode),
	.LU_A(BITUNIT_A),
	.LU_B(B),
	.LU_Resoult(LU_Resoult)
);


endmodule 