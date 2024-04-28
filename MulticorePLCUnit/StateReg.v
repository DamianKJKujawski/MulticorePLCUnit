module STATE_REG
#
(
	parameter FetchBits   = 8
)
(
	//Basic:
	input 			  						CLK,
	
	input wire								CPU_SetReset,
	input wire								STATEREG_SetReset,
	//INPUT:
	
	input wire	  							STATEREG_WE,

	input wire [(FetchBits - 1) : 0] STATEREG_InputData,
	
	//OUTPUT:
	output reg [(FetchBits - 1) : 0] STATEREG_OutputData
);

wire reset = ( CPU_SetReset || STATEREG_SetReset );

//	DESCRIPTION:
always @(posedge CLK)
begin
	if(reset)
		STATEREG_OutputData <= 8'b0;
	else if(STATEREG_WE)
		STATEREG_OutputData <= STATEREG_InputData;
	else
		STATEREG_OutputData <= STATEREG_OutputData;
end
	
endmodule 