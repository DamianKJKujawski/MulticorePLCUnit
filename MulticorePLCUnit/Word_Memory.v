module Word_Memory
(
	input wire 							clk,

	input wire							WriteEnable,
	input wire 							chip_enable,
	input wire 							enable,
	
	input wire 	[DataBits-1:0] 	InputData,
	input wire 	[AddrBits-1:0] 	Addr,
	
	output wire [DataBits-1:0] 	OutputData
);




localparam AddrBits 	= 10;
localparam DataBits   = 8;



//				WIRES & REGS
reg  [DataBits   - 1 :0] RAM[((2^AddrBits) - 1):0];
	
	
//				DESCRIPTION
always @ (posedge clk)
begin
	if (WriteEnable && chip_enable)
	begin
		RAM[Addr] <= InputData;
	end
end
	
assign OutputData = (chip_enable)? RAM[Addr]:8'bzzzz_zzzz;


//				TESTBENCH
initial
begin
	integer i;
	
	for (i=0; i<(2^AddrBits); i=i+1)
	begin
		RAM[i] = {(DataBits-1) {1'b0}};
	end
end

endmodule 