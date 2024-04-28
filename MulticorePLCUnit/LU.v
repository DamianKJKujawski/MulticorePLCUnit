module LU
(
	input wire  [1:0] LU_OPCode,
	input wire  			LU_A,
	input wire  			LU_B,
	output reg 	 			LU_Resoult
);

 always @(*)
 begin
	case(LU_OPCode)
          4'b00: //  And 
				LU_Resoult <=  LU_A & LU_B;
          4'b01: //  Or
				LU_Resoult <=  LU_A | LU_B;
          4'b10: //  Not
				LU_Resoult <= ~LU_A;
			    4'b11: //  Xor
				LU_Resoult <=  LU_A ^ LU_B;
	endcase
end
	 
endmodule 