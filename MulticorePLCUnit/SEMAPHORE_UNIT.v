module SEMAPHORE_UNIT
#
(
	parameter NumberOfCores = 2
)
(
	//BASIC:
	input  wire	  									CLK,
	input  wire											SEMAPHOREUNIT_RESET,
	
	input  wire [3:0]								SEMAPHOREUNIT_CntIn,
	output wire [3:0]								SEMAPHOREUNIT_CntOut,
	
	input  wire	[NumberOfCores-1:0]	SEMAPHOREUNIT_EN,
	input  wire											SEMAPHOREUNIT_WR,				//-1
																		
	output wire [NumberOfCores-1:0]	SEMAPHOREUNIT_BLOCKING	//+1
);

reg [3:0] semaphore_cnt;

wire [NumberOfCores:0] _BLOCKER_Carry;
assign _BLOCKER_Carry[0] = 1'b0;

genvar i;

generate
	for (i=1; i<=NumberOfCores; i=i+1) 
	begin 
		: generate_BLOCKER_identifier
		
	//AVAILABLE FLAG:
	SEMAPHORE_BLOCKER _SEMAPHORE_BLOCKER
	(
			.SEMAPHOREBLOCKER_CarryIn(_BLOCKER_Carry[i-1]),
			.SEMAPHOREBLOCKER_EN(SEMAPHOREUNIT_EN[i-1]),
			
			.SEMAPHOREBLOCKER_BLOCKING(SEMAPHOREUNIT_BLOCKING[i-1]),
			.SEMAPHOREBLOCKER_CarryOut(_BLOCKER_Carry[i])
	);
	end
endgenerate	

//Write:
always @ (posedge CLK or posedge SEMAPHOREUNIT_RESET)
begin
	if(SEMAPHOREUNIT_RESET)
		semaphore_cnt <= 1'b0;
	else if(SEMAPHOREUNIT_WR)
			semaphore_cnt <= SEMAPHOREUNIT_CntIn;
end




assign SEMAPHOREUNIT_CntOut = semaphore_cnt;

initial
begin
	semaphore_cnt = 0;
end
	
	
endmodule
