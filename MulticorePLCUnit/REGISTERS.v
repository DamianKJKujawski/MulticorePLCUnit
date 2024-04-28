module REGISTERS
#
(
	parameter MemorySize = 2,
	parameter FetchBits  = 8
)
(
	//BASIC:
	input wire			  									CLK,
	
	input wire													CPU_Reset,
	
	//FIFO:
	input  wire			  									FIFO_EN,
	input  wire			  									FIFO_PUSH_REG,
	input  wire			  									FIFO_RD,
	input  wire			  									FIFO_WR,
	output wire			  									FIFO_EmptySignal,
	output wire			  									FIFO_FullSignal,
	
	input  wire	 												FIFO_Memory_WR,
	input  wire													FIFO_Memory_EN,
	
	//INPUT:
	//Push pull
	input wire													REGISTERS_PUSHtoStack,
	input wire													REGISTERS_PULLfromStack,
	
	//
	input wire			  									REGISTERS_WE,
	input wire													REGISTERS_SetBitData,
	
	input wire	  							[3:0] 	REGISTERS_ADDR,
	
	input wire	  											REGISTERS_BitData,
	
	
	input wire	  [(FetchBits - 1):0] 	REGISTERS_WordData,
	
	//OUTPUT:
	output wire   [(FetchBits - 1):0] 	REGISTERS_OutData
);

//	WIRES & REGS
reg  [FetchBits   - 1 :0]  REGISTERS[((2**MemorySize) - 1):0];
	
wire [(FetchBits - 1) :0] REGISTERS_InData_buffer;
wire [(FetchBits - 1) :0] _FIFO_OutData;
wire [(FetchBits - 1) :0] _STACK_InData;
wire [(FetchBits - 1) :0] _REGISTERS_OutData;

assign REGISTERS_InData_buffer[0] 	= (REGISTERS_SetBitData) ? REGISTERS_BitData : REGISTERS_WordData[0];
assign REGISTERS_InData_buffer[7:1] = REGISTERS_WordData[7:1];
assign _STACK_InData 								= (FIFO_PUSH_REG) ? _REGISTERS_OutData : REGISTERS_InData_buffer;
assign _REGISTERS_OutData 					= REGISTERS[REGISTERS_ADDR[1:0]];
assign REGISTERS_OutData 						= (FIFO_EN) ? _FIFO_OutData : _REGISTERS_OutData;

wire [7:0] _FIFO_Data;
wire [7:0] _FIFO_Memory_DataOut;
	
//	DESCRIPTION
always @ (posedge CLK)
begin
	if (REGISTERS_WE)
	begin
		if(FIFO_EN)
			REGISTERS[REGISTERS_ADDR] <= _FIFO_Data;	
		else
			REGISTERS[REGISTERS_ADDR] <= REGISTERS_InData_buffer;
	end
end
	
assign _FIFO_Data = (FIFO_Memory_EN) ? _FIFO_Memory_DataOut : _FIFO_OutData;


//STACK:
FIFO _STACK
( 
	.CLK(CLK), 
	
	.FIFO_RD(FIFO_RD), 
	.FIFO_WR(FIFO_WR), 
	
	.FIFO_RST(CPU_Reset),
	
	.FIFO_Memory_Addr(REGISTERS_ADDR),
	.FIFO_Memory_WR(FIFO_Memory_WR),
	.FIFO_Memory_EN(FIFO_Memory_EN),
	.FIFO_Memory_DataOut(_FIFO_Memory_DataOut), 
	
	.FIFO_DataIn(_STACK_InData), 
	
	.FIFO_EMPTYSignal(FIFO_EmptySignal), 
	.FIFO_FULLSignal(FIFO_FullSignal),
	
	.FIFO_DataOut(_FIFO_OutData)
); 




//	TESTBENCH
integer i;

initial
begin
	for (i=0; i<(2^MemorySize); i=i+1)
	begin
		REGISTERS[i] = {(FetchBits-1) {1'b0}};
	end
end
	
endmodule
