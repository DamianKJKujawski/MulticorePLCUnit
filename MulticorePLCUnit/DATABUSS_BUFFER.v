module DATABUS_BUFFER
(
	input  wire 			DATABUSBUFFER_SetBusOutput,
	
	input  wire 			DATABUSBUFFER_SetBitData,
	
	input  wire [7:0]	DATABUSBUFFER_WordData,
	input  wire 			DATABUSBUFFER_BitData,
	
	output wire	[7:0]	DATABUSBUFFER_RAMData
);

wire [7:0] _DATABUSBUFFER_RAMData;

assign _DATABUSBUFFER_RAMData[0] = (DATABUSBUFFER_SetBitData) ? DATABUSBUFFER_BitData : DATABUSBUFFER_WordData[0];
assign _DATABUSBUFFER_RAMData[7:1] = DATABUSBUFFER_WordData[7:1];
assign DATABUSBUFFER_RAMData = (DATABUSBUFFER_SetBusOutput) ? _DATABUSBUFFER_RAMData : 8'bzzzz_zzzz;

endmodule 