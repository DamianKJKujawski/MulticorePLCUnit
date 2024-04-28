module ARG_REG
(	
//Control:
	input wire 	[1:0]	ARG_OPCode,
	
	//Input data:
	input wire 				ARG_ArgToSet,
	input wire 				ARG_RAMData,
	input wire 				ARG_Register,
	
	//Output data:
	output reg				ARG
);

always @(*)
begin
	case(ARG_OPCode)
		2'b00:
			ARG <= ARG_ArgToSet;
		2'b01:
			ARG <= ARG_RAMData;
		2'b10:
			ARG <= ARG_Register;
		default:
			ARG <= ARG_ArgToSet;
	endcase
end

endmodule
