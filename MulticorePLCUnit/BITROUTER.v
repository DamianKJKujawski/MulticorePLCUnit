/*
module BIT_ROUTER
(
	//BASIC:
	input wire			  		CLK,
	
	input wire					BITROUTER_WriteData,
	
	//Input:
	input wire 				 	BITROUTER_ARG,
	input wire 					BITROUTER_ACU,
	
	//OUTPUT:
	//Addr:
	input wire					BITROUTER_Addr,
	//Data:
	output wire					BITROUTER_CPUData,
	//IO:
	inout wire					BITROUTER_REGISTERData
);

wire 		BITROUTER_RAMData_buffer = (BITROUTER_Addr) ? BITROUTER_ACU : BITROUTER_ARG;

assign 	BITROUTER_RAMData = ( BITROUTER_WriteData) ? BITROUTER_RAMData_buffer 	: 1'bz;
assign 	BITROUTER_CPUData = (!BITROUTER_WriteData) ? BITROUTER_RAMData 			: 1'bz; 
	
endmodule
*/