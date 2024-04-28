module IO_Memory
(
	input  wire 								clk,
	input  wire 								chip_enable,
	
	input  wire									WriteEnable,
	input  wire 								enable,	

	input  wire 	[AddrBits-1:0]Addr,
	
	input  wire 	 							Input_BitData,
	output wire 								Output_BitData,
	
	
	input  wire									LoadInputs,
	input  wire									LoadOutputs,
	
	input  wire [IOBits-1:0] 		Inputs,
	output reg  [IOBits-1:0] 		Outputs
);

localparam IOBits   	= 16;
localparam AddrBits 	= 5;

//IO
reg 	[IOBits-1:0] 		InputsReg;
reg 	[IOBits-1:0] 		OutputsReg;


//MSB -> 1 - Inputs
//		-> 0 - Outputs
		
//				DESCRIPTION
always @ (posedge clk)
begin
	if (LoadInputs)
	begin
		InputsReg <= Inputs;
	end
	else if(chip_enable && enable && WriteEnable && ~Addr[AddrBits-1])
	begin
		InputsReg[Addr] <= Input_BitData;
	end
end


always @ (posedge clk)
begin
	if (LoadOutputs)
	begin
		Outputs <= OutputsReg;
	end
end

assign Output_BitData = (chip_enable && enable && WriteEnable && Addr[AddrBits-1])? OutputsReg[Addr]: 1'bz;

	

endmodule 