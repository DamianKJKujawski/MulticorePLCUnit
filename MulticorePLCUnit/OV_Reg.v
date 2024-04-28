module OV_REG
(
	input wire					CLK,
	input wire					CPU_Reset,
	
	input wire					OV_EN,
	
	input wire		[3:0]	OVREG_OV_OPCode,
	
	input	wire		[8:0] OVREG_Adder,
	input	wire		[8:0] OVREG_Subtractor,

	output reg 					OVREG_OV
);

wire _enable = OV_EN && ( OVREG_OV_OPCode[3] && !OVREG_OV_OPCode[2] && !OVREG_OV_OPCode[1]);
wire _reset  = OV_EN && (!OVREG_OV_OPCode[3] && !OVREG_OV_OPCode[2]);

always @(posedge CLK or posedge CPU_Reset) 
begin
	if(CPU_Reset)
		OVREG_OV <= 0;
	else begin
		if(_enable)
		begin
			if(_reset)
				OVREG_OV <= 0;
			else begin
				if(OVREG_OV_OPCode[0])
					OVREG_OV <= OVREG_Adder[8];
				else
					OVREG_OV <= OVREG_Subtractor[8];
			end
		end
	end
end

//TESTBENCH INIT:
initial begin
	OVREG_OV = 0;
end
	 
endmodule 