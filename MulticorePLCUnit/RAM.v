module RAM
(
	input wire 		    CLK,
	
	//DRIVE Signals:
	input wire 		    RAM_EN,
	input wire 		    RAM_WE,
	
	//In data:
	input wire [15:0] RAM_ADDR,
	inout wire [7:0]  RAM_DATA
);


	reg [7:0] RAM[255:0];
	
	
	// CODE:
	assign RAM_DATA = (RAM_EN && !RAM_WE) ? RAM[RAM_ADDR] : 8'bzzzz_zzzz;
	
	always @ (posedge CLK)
	begin
		if (RAM_WE && RAM_EN) 
		begin
			RAM[RAM_ADDR] <= RAM_DATA;
		end 
	end
	
	
	//	TESTBENCH:
	integer i;
	
	initial
	begin
		for (i=0; i<(256); i=i+1)
		begin
			RAM[i] = 8'd0;
		end
	end
	
endmodule 