module RLO_REG
(
	// Basic:
	input wire 				CLK,
	input wire				CPU_Reset,

	//Control:
	input wire 				RLO_EN,
	input wire 	[2:0]	RLO_OPCode,
	
	//Input data:
	input wire 				RLO_ArgToSet,
	input wire 				RLO_RAMData,
	input wire 				RLO_Registers,
	input wire 				RLO_LU_Resoult,
	input wire 				RLO_OVResoult,
	input wire 				RLO_ComparatorResoult,
	input wire				RLO_Semaphore,
	
	//Output data:
	output reg				RLO
);


always @(posedge CLK or posedge CPU_Reset)
begin
	if(CPU_Reset)
		RLO <= 0;
	else
	begin
		if(RLO_EN)
		begin
			case(RLO_OPCode)
				3'b000:
					RLO <= RLO_ArgToSet;
				3'b001:
					RLO <= RLO_RAMData;
				3'b010:
					RLO <= RLO_Registers;	
				3'b011:
					RLO <= RLO_LU_Resoult;
				3'b100:
					RLO <= RLO_OVResoult;
				3'b101:
					RLO <= RLO_ComparatorResoult;
				3'b110:
					RLO <= RLO_Semaphore;
				3'b111:
					RLO <= RLO_ArgToSet;
			endcase
		end
	end
end

//TESTBENCH INIT:
initial begin
	RLO = 0;
end


endmodule 