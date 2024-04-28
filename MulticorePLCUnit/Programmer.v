module PROGRAMMER
#
(
	parameter 	NumberOfCores 	= 2,
	parameter 	AddrMSB 		 		= (NumberOfCores>1)? ($clog2(NumberOfCores)-1) 	: 0,
	parameter 	AddrMSB2 		 		= (NumberOfCores>1)? ($clog2(NumberOfCores)  ) 	: 0
)
(
	input wire												CLK,
	
	input	wire												PROGRAMMER_RESET,
	
	input	wire		[7:0]								PROGRAMMER_InputData,
	input	wire												PROGRAMMER_PCK,
	input	wire												PROGRAMMER_SCK,
	
	output wire 	[7:0]								PROGRAMMER_OutputData,
	output reg 		[3:0]								PROGRAMMER_ROMAddr,
	
	output wire 											CPU_Reset,
	output wire												CPU_WE,
	output wire		[AddrMSB2:0]				CPU_WE_ADDR
);

reg [AddrMSB:0] PROGRAMMER_CPUAddr;

assign PROGRAMMER_OutputData = PROGRAMMER_InputData;
assign CPU_WE = PROGRAMMER_SCK;
assign CPU_Reset = PROGRAMMER_RESET;
assign CPU_WE_ADDR = (1'b1 << (PROGRAMMER_CPUAddr));

always @(posedge CLK)
begin
	if(PROGRAMMER_RESET)
		if(PROGRAMMER_PCK)
		begin
			case(PROGRAMMER_InputData[2:0])			
				3'b001:
				begin
					PROGRAMMER_ROMAddr 	= 1'b0;
				end
				3'b010:	//Programmer_ExternalAddr++:
				begin
					PROGRAMMER_ROMAddr 	= PROGRAMMER_ROMAddr + 1'b1;
				end
				3'b011:	//Programmer_ExternalAddr--:
				begin
					PROGRAMMER_ROMAddr 	= PROGRAMMER_ROMAddr - 1'b1;
				end
							
				3'b101:	//Save to Programmer_CPUAddr:
				begin
					PROGRAMMER_CPUAddr 	= 1'b0;
				end
				3'b110:	//Programmer_CPUAddr++:
				begin
					PROGRAMMER_CPUAddr	= PROGRAMMER_CPUAddr + 1'b1;
				end
				3'b111:	//Programmer_CPUAddr--:
				begin
					PROGRAMMER_CPUAddr	= PROGRAMMER_CPUAddr - 1'b1;
				end
					
			endcase
		end
		else if(PROGRAMMER_SCK)
		begin
			PROGRAMMER_ROMAddr 	= PROGRAMMER_ROMAddr + 1'b1;
		end
end

//TESTBENCH INIT:
initial begin
	PROGRAMMER_CPUAddr = 0;
	PROGRAMMER_ROMAddr = 0;
end

endmodule 