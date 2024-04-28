module ACCU
(
	input  wire 				CLK,
	input  wire 				CPU_Reset,

	input  wire					ACCU_WE,
	input  wire 	[1:0] ACCU_OPCode,
	

	input  wire 	[7:0]	ACCU_ArgToSet,
	input  wire 	[7:0]	ACCU_RAMData,
	input  wire 	[7:0]	ACCU_AnyDataInput,
	input  wire 	[7:0]	ACCU_Register,
	
	output reg 		[7:0]	ACCUMULATOR
);


always @(posedge CLK or posedge CPU_Reset)
begin
	if(CPU_Reset)
		ACCUMULATOR <= 0;
	else
		if(ACCU_WE)
		begin
			case(ACCU_OPCode)
				2'b00:
					ACCUMULATOR <= ACCU_ArgToSet;
				2'b01:
					ACCUMULATOR <= ACCU_AnyDataInput;
				2'b10:
					ACCUMULATOR <= ACCU_Register;	
				2'b11:
					ACCUMULATOR <= ACCU_RAMData;
			endcase
		end
end

//TESTBENCH INIT:
initial begin
	ACCUMULATOR = 0;
end

endmodule 