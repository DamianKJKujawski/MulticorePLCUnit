module ACCU_A
(
	input  wire 			CLK,

	input  wire				ACCUA_WE,
	input  wire 	[1:0] ACCUA_OPCode,
	

	input  wire 	[7:0]	ACCUA_ArgToSet,
	input  wire 	[7:0]	ACCUA_RAMData,
	input  wire 	[7:0]	ACCU_Register,
	
	input  wire 	[7:0]	ACCUA_ALU_Resoult,
	
	output reg 		[7:0]	ACCUMULATOR
);


always @(posedge CLK)
begin
	if(ACCUA_WE)
	begin
		case(ACCUA_OPCode)
			2'b00:
				ACCUMULATOR <= ACCUA_ArgToSet;
			2'b01:
				ACCUMULATOR <= ACCUA_RAMData;
			2'b10:
				ACCUMULATOR <= ACCUA_ALU_Resoult;
		endcase
	end
end

endmodule 