module FIFO
( 
	input wire 				CLK, 
	
	input wire 				FIFO_RD, 
	input wire 				FIFO_WR, 
	
	input wire 				FIFO_RST,
	
	input wire [3:0]	FIFO_Memory_Addr,
	input wire 				FIFO_Memory_WR,
	input wire				FIFO_Memory_EN,
	output wire [7:0] FIFO_Memory_DataOut, 
	
	input wire [7:0] 	FIFO_DataIn, 
	
	output wire 			FIFO_EMPTYSignal, 
	output wire 			FIFO_FULLSignal,
	
	output reg [7:0] 	FIFO_DataOut
); 


//Registers:
reg [7:0] FIFO_Memory [3:0];

wire [3:0]	_FIFO_Memory_Addr;
//Assign:
assign FIFO_EMPTYSignal = (FIFO_Counter == 2'b00) ? 1'b1 : 1'b0; 
assign FIFO_FULLSignal  = (FIFO_Counter == 2'b11) ? 1'b1 : 1'b0; 
assign _FIFO_Memory_Addr = (FIFO_Memory_EN) ? FIFO_Memory_Addr : FIFO_WR_Pointer;

always @(posedge CLK)
begin
	if( (FIFO_WR && !FIFO_EMPTYSignal) || FIFO_Memory_WR)
		FIFO_Memory[_FIFO_Memory_Addr] <= FIFO_DataIn;
		
	if( FIFO_RD && !FIFO_FULLSignal )
		FIFO_DataOut <= FIFO_Memory[FIFO_RD_Pointer];
end

assign FIFO_Memory_DataOut = FIFO_Memory[FIFO_Memory_Addr];


//FIFO_Counter::
wire [1:0] FIFO_Counter;

FIFO_COUNTER _FIFO_Counter
( 
	//Basic:
	.CLK(CLK), 
	
	.FIFOCOUNTER_RST(FIFO_RST),
	
	//Input:
	.FIFOCOUNTER_CntUpEnable(FIFO_FULLSignal),
	.FIFOCOUNTER_CntDownEnable(FIFO_EMPTYSignal),
	
	.FIFOCOUNTER_CntUpSignal(FIFO_WR), 
	.FIFOCOUNTER_CntDownSignal(FIFO_RD), 
	
	//Output:
	.FIFOCOUNTER_Counter(FIFO_Counter)
); 

//RD_Pointer:
wire [1:0] FIFO_RD_Pointer;

FIFO_POINTER _RD_Pointer
( 
	//Basic:
	.CLK(CLK), 
	
	.FIFOPOINTERS_RST(FIFO_RST),
	//Input:
	.FIFOPOINTERS_EnablingSignal(FIFO_EMPTYSignal),
	.FIFOPOINTERS_CntSignal(FIFO_RD), 
	//Output:
	.FIFOPOINTERS_CntPointer(FIFO_RD_Pointer)
); 

//WR_Pointer:
wire [1:0] FIFO_WR_Pointer;

FIFO_POINTER _WR_Pointer
( 
	//Basic:
	.CLK(CLK), 
	
	.FIFOPOINTERS_RST(FIFO_RST),
	//Input:
	.FIFOPOINTERS_EnablingSignal(FIFO_FULLSignal),
	.FIFOPOINTERS_CntSignal(FIFO_WR), 
	//Output:
	.FIFOPOINTERS_CntPointer(FIFO_WR_Pointer)
); 

endmodule 
