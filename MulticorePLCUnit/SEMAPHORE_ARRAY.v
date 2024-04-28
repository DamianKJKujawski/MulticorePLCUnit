module SEMAPHORE_ARRAY
#
(
	parameter NumberOfSemaphores = 4,
	parameter NumberOfCores = 2
)
(
	//Basic:
	input wire 			  																				CLK,
	input wire  																							SEMAPHOREARRAY_RESET,
	//Input:
	input wire 	[(NumberOfSemaphores*NumberOfCores)-1:  0]		SEMAPHOREARRAY_EN,
	
	input wire 	[NumberOfSemaphores-1:  0]										SEMAPHOREARRAY_WR,
	output wire	[(NumberOfSemaphores*NumberOfCores)-1:  0]		SEMAPHOREUNIT_BLOCKING,
	//Control Signals:
	input wire 	[(4*NumberOfSemaphores)-1:  0] 								SEMAPHOREARRAY_CntIn,
	output wire [(4*NumberOfSemaphores)-1:  0] 								SEMAPHOREARRAY_CntOut
);


wire	[(NumberOfSemaphores*NumberOfCores)-1:  0]		_SEMAPHOREUNIT_BLOCKING;
wire	[(NumberOfSemaphores*NumberOfCores)-1:  0]		_SEMAPHOREARRAY_EN;

//Wiring:
genvar i;
genvar j;

// --- Output ---
generate
for (i=0; i<NumberOfCores; i=i+1) 
begin
	: generate_BLOCKING_i
	for (j=0; j<NumberOfSemaphores; j=j+1) 
	begin
		: generate_BLOCKING_j
		
		assign SEMAPHOREUNIT_BLOCKING [(i*NumberOfSemaphores)+j] = _SEMAPHOREUNIT_BLOCKING [i+j*NumberOfCores];
	end
end
endgenerate

// --- Input ---
generate
for (i=0; i<NumberOfCores; i=i+1) 
begin
	: generate_ENABLING_i
	for (j=0; j<NumberOfSemaphores; j=j+1) 
	begin
		: generate_ENABLING_j
		
		assign _SEMAPHOREARRAY_EN [i+(j*NumberOfCores)] = SEMAPHOREARRAY_EN [(i*NumberOfSemaphores)+j];
	end
end
endgenerate
		

generate
	for (i=0; i<NumberOfSemaphores; i=i+1) 
	begin 
		: generate_SEMAPHORE_ARRAY_identifier
		
		SEMAPHORE_UNIT # 
		(
			.NumberOfCores(NumberOfCores)
		)
		_SEMAPHORE_UNIT
		(
			.CLK(CLK),

			.SEMAPHOREUNIT_RESET(SEMAPHOREARRAY_RESET),
	
			.SEMAPHOREUNIT_CntIn (SEMAPHOREARRAY_CntIn [ (((4*i) + 4)-1) :  (4*i)] ),
			.SEMAPHOREUNIT_CntOut(SEMAPHOREARRAY_CntOut[ (((4*i) + 4)-1) :  (4*i)] ),
	
			.SEMAPHOREUNIT_EN(_SEMAPHOREARRAY_EN[((NumberOfCores*(i+1))-1) : NumberOfCores*(i)]),
			.SEMAPHOREUNIT_WR(SEMAPHOREARRAY_WR[i]),		//-1
	
			.SEMAPHOREUNIT_BLOCKING(_SEMAPHOREUNIT_BLOCKING[((NumberOfCores*(i+1))-1) : NumberOfCores*(i)])	//+1
			
		);
		
	end
endgenerate
		
endmodule
