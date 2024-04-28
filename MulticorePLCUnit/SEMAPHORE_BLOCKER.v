module SEMAPHORE_BLOCKER
(
		input wire SEMAPHOREBLOCKER_CarryIn,
		input wire SEMAPHOREBLOCKER_EN,
		
		output wire SEMAPHOREBLOCKER_BLOCKING,
		output wire SEMAPHOREBLOCKER_CarryOut
);


assign SEMAPHOREBLOCKER_BLOCKING = SEMAPHOREBLOCKER_CarryIn;

assign SEMAPHOREBLOCKER_CarryOut = SEMAPHOREBLOCKER_EN || SEMAPHOREBLOCKER_CarryIn;


endmodule 