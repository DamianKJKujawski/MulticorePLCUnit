module DATA_ROUTER
(
	//BASIC:
	input wire			  		CLK,
	
	input wire					DATAROUTER_WriteData,
	
	//Input:
	input wire [ 7 : 0 ] 	DATAROUTER_WORDUNIT,
	input wire  				DATAROUTER_BITUNIT,
	
	//OUTPUT:
	//Addr:
	input wire					DATAROUTER_Addr,
	//Data:
	output wire	[ 7 : 0 ] 	DATAROUTER_CPUData,
	//IO:
	inout wire	[ 7 : 0 ] 	DATAROUTER_RAMData
);


wire [ 7 : 0 ] 	DATAROUTER_RAMData_buffer;

assign 	DATAROUTER_RAMData_buffer[7:1] 	= DATAROUTER_WORDUNIT[7:1];
assign 	DATAROUTER_RAMData_buffer[0] 		= (DATAROUTER_Addr) ? DATAROUTER_BITUNIT : DATAROUTER_WORDUNIT[0];

assign 	DATAROUTER_RAMData = ( DATAROUTER_WriteData) ? DATAROUTER_RAMData_buffer 	: 8'bzzzzzzzz;
assign 	DATAROUTER_CPUData = (!DATAROUTER_WriteData) ? DATAROUTER_RAMData 			: 8'bzzzzzzzz; 
	
endmodule
