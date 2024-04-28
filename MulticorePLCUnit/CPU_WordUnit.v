module WORD_UNIT
(
	// Basic:
	input  wire 				CLK,
	input  wire					CPU_Reset,
	
	//ALU  
	input  wire 				COMPARATORREG_EN,	
	input  wire 	[3:0] WORDUNIT_ALU_OPCode,
	//OV:
	input  wire					OV_EN,	
	
	//A INPUT:
	input  wire					WORDUNIT_A_WE,
	input  wire 	[1:0] WORDUNIT_A_OPCode,
	
	//B INPUT:
	input  wire					WORDUNIT_B_WE,
	input  wire 	[1:0]	WORDUNIT_B_OPCode,
	
	//DATA INPUT:
	//ProgMem:
	input  wire 	[7:0]	WORDUNIT_ArgToSet,
	//RAM
	input  wire 	[7:0]	WORDUNIT_RAMData,
	//REGISTERS:
	input  wire 	[7:0]	WORDUNIT_Register,
	
	// Outputs:	
	//OV:
	output wire 	      WORDUNIT_OV,
	//Comparator:
	output wire 				WORDUNIT_ComparatorResoult,
	//A:
	output wire 	[7:0]	WORDUNIT_A 
);


// REGs
//_B:
wire [7:0] B;
//_ALU:
wire [7:0] ALU_Resoult;


ACCU _A
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),

	.ACCU_WE(WORDUNIT_A_WE),
	.ACCU_OPCode(WORDUNIT_A_OPCode),
	
	.ACCU_ArgToSet(WORDUNIT_ArgToSet),
	.ACCU_RAMData(WORDUNIT_RAMData),
	.ACCU_Register(WORDUNIT_Register),
	.ACCU_AnyDataInput(ALU_Resoult),
	
	.ACCUMULATOR(WORDUNIT_A)
);


ACCU _B
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),

	.ACCU_WE(WORDUNIT_B_WE),
	.ACCU_OPCode(WORDUNIT_B_OPCode),
	
	.ACCU_ArgToSet(WORDUNIT_ArgToSet),
	.ACCU_RAMData(WORDUNIT_RAMData),
	.ACCU_Register(WORDUNIT_Register),
	.ACCU_AnyDataInput(WORDUNIT_A),
	
	.ACCUMULATOR(B)
);



ALU _ALU
(
	//Basic:
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),
	
	.COMPARATORREG_EN(COMPARATORREG_EN),
	
	//ALU Input:
	.ALU_OPCode(WORDUNIT_ALU_OPCode),
	.ALU_A(WORDUNIT_A),
	.ALU_B(B),

	.OV_EN(OV_EN),
	
	//ALU Output:
	.ALU_Resoult(ALU_Resoult),
	.ALU_ComparatorResoult(WORDUNIT_ComparatorResoult),
	.ALU_OV(WORDUNIT_OV)
	
);


endmodule 