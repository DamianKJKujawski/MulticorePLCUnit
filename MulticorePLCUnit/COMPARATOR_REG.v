module COMPARATOR_REG
(
	input wire			CLK,
	input wire			CPU_Reset,
	input wire 			COMPARATORREG_Comparatore_EN,

	input 		[3:0]	ALUMUX_OPCode,
	
	input 					COMPARATORREG_Result,
	
	output reg			COMPARATORREG_ComparatorResoult
);

wire _enable = (ALUMUX_OPCode[3] && !(ALUMUX_OPCode[2] && !ALUMUX_OPCode[1] && !ALUMUX_OPCode[0])) && COMPARATORREG_Comparatore_EN;

always @(posedge CLK or posedge CPU_Reset)
begin
	if(CPU_Reset)
		COMPARATORREG_ComparatorResoult <= 0;
	else
		if(_enable)
		begin
			COMPARATORREG_ComparatorResoult = COMPARATORREG_Result;
		end
end

//TESTBENCH INIT:
initial begin
	COMPARATORREG_ComparatorResoult = 0;
end

endmodule 