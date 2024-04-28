module RAM_CONTROLLER
(
	input wire 				CLK,

	input wire 				RAMCONTROLLER_EXE_RAMReqest,
	output wire 			RAMCONTROLLER_EXE_RAMHandled,
	
	//RAM - Read data:
	output wire [15:0] 	RAMCONTROLLER_InDataADDR,
	output wire				RAMCONTROLLER_InDataRR,
	
	input wire				RAMCONTROLLER_InDataACK,
	input wire 	[7:0] 	RAMCONTROLLER_InData,
	//RAM - Write data:
	output wire [15:0] 	RAMCONTROLLER_OutDataADDR,
	output wire [7:0] 	RAMCONTROLLER_OutData,
	output wire				RAMCONTROLLER_OutDataWR
	
	input wire				RAMCONTROLLER_OutDataACCESS,
);







endmodule 