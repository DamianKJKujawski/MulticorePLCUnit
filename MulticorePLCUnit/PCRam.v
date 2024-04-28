module CPU_ROM
#
(
	parameter CounterBits = 6,
	parameter FetchBits   = 8
)
(
	//BASIC:
	input wire			  								CLK,
	
	//PROGRAMMER:
	input  wire			  								PCRam_WE,
	input  wire												PCRam_EN,
	
	input  wire	[(FetchBits   - 1):0] PCRam_ProgrammerData,
	input  wire	[(CounterBits - 1):0] PCRam_ProgrammerAddr,
	
	//OUTPUT:
	//Addr:
	input  wire	[(CounterBits - 1):0] PCRam_InstructionAddr,
	//Data:
	output wire	[(FetchBits - 1)  :0] PCRAM_OutputData
);

reg  [(FetchBits - 1) :0] RAM[((2**CounterBits) - 1):0];
	
//	DESCRIPTION
always @ (posedge CLK)
begin
	if (PCRam_WE && PCRam_EN)
	begin
		RAM[PCRam_ProgrammerAddr] <= PCRam_ProgrammerData;
	end
end
	
assign PCRAM_OutputData = RAM[PCRam_InstructionAddr];

//	TESTBENCH
integer i;
initial
begin
	for (i=0; i<(2**CounterBits); i=i+1)
	begin
		RAM[i] = {(FetchBits) {1'b1}};
	end
end
	
endmodule
