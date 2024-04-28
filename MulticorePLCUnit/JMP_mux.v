module JMP_MUX
(
	input wire [7:0] 		ROM_InputData,
	
	input wire 					BIT_UNIT_A,
	input wire 					WORD_UNIT_OV,
	input wire 					WORD_UNIT_ComparatorResoult,
	input wire 					WORD_UNIT_SEMAPHORE_Flag,
	input wire 					WORD_UNIT_TIMER_Flag,
	
	output wire 				JMPMUX_JMP_EN
);


	wire jmpc  =  BIT_UNIT_A;
	wire jmpcn = !BIT_UNIT_A;
	wire jcmp  =  WORD_UNIT_ComparatorResoult;
	wire jcmpn = !WORD_UNIT_ComparatorResoult;
	wire jov	 =  WORD_UNIT_OV;
	wire jovn	 = !WORD_UNIT_OV;
	wire jmps	 =  WORD_UNIT_SEMAPHORE_Flag;
  wire jmpsn = !WORD_UNIT_SEMAPHORE_Flag;
	wire jmpt	 =  WORD_UNIT_TIMER_Flag;
  wire jmptn = !WORD_UNIT_TIMER_Flag;
		
	wire [10:0] mux_input = {1'b1, jmpc, jmpcn, jcmp, jcmpn, jov, jovn, jmps, jmpsn, jmpt, jmptn};


	assign JMPMUX_JMP_EN = mux_input[ROM_InputData[3:0]];



endmodule 