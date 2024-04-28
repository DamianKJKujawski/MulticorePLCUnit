module ALU_MUX
(
	input wire				CLK,
	input wire				CPU_Reset,
	
	input wire 				COMPARATORREG_EN,
	
	input wire	[3:0]	ALUMUX_OPCode,
	
	input	wire	[7:0] ALUMUX_A,
	input	wire 	[7:0] ALUMUX_B,
		
	input wire	[7:0] ALUMUX_Adder,
	input	wire	[7:0] ALUMUX_Subtractor,
	
	output reg	[7:0] ALUMUX_Result,
	
	output wire				ALUMUX_ComparatorResoult
);


COMPARATOR_REG _COMPARATOR_REG
(
	.CLK(CLK),
	.CPU_Reset(CPU_Reset),
	.COMPARATORREG_Comparatore_EN(COMPARATORREG_EN),
	
	.ALUMUX_OPCode(ALUMUX_OPCode),
	.COMPARATORREG_Result(ALUMUX_Result[0]),
	.COMPARATORREG_ComparatorResoult(ALUMUX_ComparatorResoult)
);


always @(*)
begin
	case(ALUMUX_OPCode)
		//Logic operations:
		4'b0000:  
			ALUMUX_Result <= ALUMUX_A & ALUMUX_B;
		4'b0001: 
			ALUMUX_Result <= ALUMUX_A | ALUMUX_B;
		4'b0010: 
			ALUMUX_Result <=~ALUMUX_A;
		4'b0011: 
			ALUMUX_Result <= ALUMUX_A ^ ALUMUX_B;
		//Shifting:
		4'b0100: 
			ALUMUX_Result <= ALUMUX_A<<1;
		4'b0101: 
			ALUMUX_Result <= ALUMUX_A>>1;
		4'b0110: 
			ALUMUX_Result <= {ALUMUX_A[6:0],ALUMUX_A[7]};
		4'b0111: 
			ALUMUX_Result <= {ALUMUX_A[0],ALUMUX_A[7:1]};
		//Arithmetic operations:
		4'b1000: 
			ALUMUX_Result <= ALUMUX_Adder;
		4'b1001: 
			ALUMUX_Result <= ALUMUX_Subtractor;
		//Comparator:
		4'b1010:
			ALUMUX_Result <= (ALUMUX_A==ALUMUX_B) ? 8'd1:8'd0;
		4'b1011:   
			ALUMUX_Result <= (ALUMUX_A> ALUMUX_B) ? 8'd1:8'd0;
		4'b1100:
			ALUMUX_Result <= (ALUMUX_A>=ALUMUX_B) ? 8'd1:8'd0;
		4'b1101:
			ALUMUX_Result <= (ALUMUX_A!=ALUMUX_B) ? 8'd1:8'd0;
		4'b1110:
			ALUMUX_Result <= (ALUMUX_A<=ALUMUX_B) ? 8'd1:8'd0;
		4'b1111:
			ALUMUX_Result <= (ALUMUX_A< ALUMUX_B) ? 8'd1:8'd0;	
	endcase
end
	 

endmodule 