module ALU
(
	//Basic:
	input  wire 			CLK,
	input  wire				CPU_Reset,
	
	input  wire				COMPARATORREG_EN,
	
	//ALU Input:
	input  wire [3:0] ALU_OPCode,
	input  wire [7:0] ALU_A,
	input  wire [7:0] ALU_B,

	input  wire 			OV_EN,
	
	//ALU Output:
	output wire [7:0] ALU_Resoult,
	output wire 			ALU_ComparatorResoult,
	
	output wire	 			ALU_OV
);

wire [8:0] adder;
wire [8:0] subtractor;
	 
assign adder      = {1'b0,ALU_A} + {1'b0,ALU_B};	
assign subtractor = {1'b0,ALU_A} - {1'b0,ALU_B}; 
	
	
ALU_MUX _ALU_MUX
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),
	
	.COMPARATORREG_EN(COMPARATORREG_EN),

	.ALUMUX_OPCode(ALU_OPCode),
	
	.ALUMUX_A(ALU_A),
	.ALUMUX_B(ALU_B),
		
	.ALUMUX_Adder(adder[7:0]),
	.ALUMUX_Subtractor(subtractor[7:0]),
	
	.ALUMUX_Result(ALU_Resoult),
	
	.ALUMUX_ComparatorResoult(ALU_ComparatorResoult)
);
	 
	 
OV_REG _OV_REG
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),
	.OV_EN(OV_EN),
	
	.OVREG_OV_OPCode(ALU_OPCode),
	
	.OVREG_Adder(adder),
	.OVREG_Subtractor(subtractor),

	.OVREG_OV(ALU_OV)
);
	 

endmodule 