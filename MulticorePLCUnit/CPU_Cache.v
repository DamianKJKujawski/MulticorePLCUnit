module CPU_Cache
(
	input clk,

	input prev,
	output out,
	output next,
	
	input 	[15:0]	CACHE_Addr,
	
	
	
	
	//Bit
	input					CACHE_Bit_ReadRequest,
	output 				CACHE_Bit_ReadReadyStatus,
	output 				CACHE_Bit_InputData,
	

	input  				CACHE_Bit_WriteRequest,
	output 				CACHE_Bit_WriteReadyStatus,
	input 				CACHE_Bit_0utputData,
	
	
	

	

	
	output 	[15:0]	GloablRAM_Addr_Output,
	input		[15:0]	CACHE_Addr_Input,
	output	[15:0]	CACHE_Addr_Output,
	
	
	//Word
	input					CACHE_Word_ReadRequest,
	output 				CACHE_Word_ReadReadyStatus,
	
	input 				CACHE_Word_WriteRequest,
	output 				CACHE_Word_WriteReadyStatus,
	
	
	
	
	output 		[7:0]	CACHE_Word_InputData,
	input    	[7:0]	CACHE_Word_OutputData,
	
	
	output wire GloablRAM_Bit_InputData,
	input wire GloablRAM_Bit_OutputData,

	output wire [7:0] GloablRAM_Word_InputData,
	input wire  [7:0] GloablRAM_Word_OutputData,
	
	
	output 				GloablRAM_Bit_ReadReadyStatus,
	input 				GloablRAM_Bit_WriteReadyStatus,
	
	output				GloablRAM_Bit_ReadRequest,
	input 				GloablRAM_Bit_WriteRequest,
		
	output 				GloablRAM_Word_ReadReadyStatus,
	input 				GloablRAM_Word_WriteReadyStatus,
	
	output				GloablRAM_Word_ReadRequest,
	input 				GloablRAM_Word_WriteRequest


);

parameter MaxStackValue = 8;

reg [7:0] stack_WordData;
reg [7:0] tmp_WordData[3:0];

reg [7:0] stack_BitData;
reg [7:0] tmp_BitData[3:0];

reg [7:0] stack_Addr;
reg [7:0] tmp_Addr[3:0];


integer stackCounter = 0;





Cache_Desactiver Cache_Desactiver_Instance
(
.prev(prev),
.in(),

.out(out),
.next(next)
);








always @(posedge clk)
begin
	if(CACHE_Word_WriteRequest && stackCounter != MaxStackValue)
	  begin
		 stackCounter 			<= stackCounter + 1;
		 stack_WordData 		<= tmp_WordData[stackCounter];
		 stack_Addr 			<= tmp_Addr[stackCounter];
	  end
	if(CACHE_Bit_WriteRequest && stackCounter != MaxStackValue)
	  begin
		 stackCounter 			<= stackCounter + 1;
		 stack_BitData 		<= tmp_BitData[stackCounter];
		 stack_Addr 			<= tmp_Addr[stackCounter];
	  end

	if(GloablRAM_Word_ReadRequest && stackCounter != 0)
	  begin
		 stackCounter 			<= stackCounter - 1;
		 stack_WordData 		<= tmp_WordData[stackCounter];
		 stack_Addr 			<= tmp_Addr[stackCounter]; 
	  end
	if(GloablRAM_Bit_ReadRequest && stackCounter != 0)
	  begin
		 stackCounter 			<= stackCounter - 1;
		 stack_BitData 		<= tmp_BitData[stackCounter];
		 stack_Addr 			<= tmp_Addr[stackCounter]; 
	  end
	 
end










endmodule 