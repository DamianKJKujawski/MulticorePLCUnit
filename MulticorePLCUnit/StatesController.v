module STATES_CONTROLLER
(
	input wire	CLK,
	input wire 	PS,

	input wire 	PROGRAMMMER_Reset,
	
	input wire	STATESCONTROLLER_WAIT,							//Stop for diagnostics
	input wire	STATESCONTROLLER_CPU_END_Detected,	//Trigger for diagnostics
	
	output reg 	STATESCONTROLLER_CPU_ProgramReset,
	output reg 	STATESCONTROLLER_CPU_Reset,
	output reg 	STATESCONTROLLER_CPU_EN,
	
	output reg	STATESCONTROLLER_BITPERIPHERALS_READ,
	output reg	STATESCONTROLLER_BITPERIPHERALS_WRITE,
	
	//Ack:
	output wire STATESCONTROLLER_ACK
);

reg [2:0] _state_machine;

parameter INIT  						= 3'b000;	//StartUp
parameter BEGIN						 	= 3'b001;	//Work
parameter WORK  						= 3'b010;	//Work
parameter END   						= 3'b011;	//Work
parameter PROGRAMMING_RESET = 3'b100;

assign STATESCONTROLLER_ACK = (_state_machine == PROGRAMMING_RESET) ? 1'b1 : 1'b0;

always @(posedge CLK)
if(!PS)
	_state_machine <= 0;
else
begin
	case(_state_machine)
	INIT:
	begin
		STATESCONTROLLER_BITPERIPHERALS_READ		<= 1'b0;
		STATESCONTROLLER_BITPERIPHERALS_WRITE 	<= 1'b0;
		//
		STATESCONTROLLER_CPU_Reset 							<= 1'b1;
		STATESCONTROLLER_CPU_EN  								<= 1'b0;	
		STATESCONTROLLER_CPU_ProgramReset 			<= 1'b1;
		
		if(PROGRAMMMER_Reset)
			_state_machine = PROGRAMMING_RESET;
		else
			_state_machine = WORK;
	end
	BEGIN:
	begin
		STATESCONTROLLER_BITPERIPHERALS_READ <= 1'b1; 
		//
		STATESCONTROLLER_CPU_Reset 					 <= 1'b1;
		STATESCONTROLLER_CPU_EN  						 <= 1'b0;	
		STATESCONTROLLER_CPU_ProgramReset 	 <= 1'b1;
		
		if(PROGRAMMMER_Reset)
			_state_machine = PROGRAMMING_RESET;
		else
			_state_machine = WORK;
	end
	WORK:
	begin
		STATESCONTROLLER_BITPERIPHERALS_WRITE 	<= 1'b0;
		STATESCONTROLLER_BITPERIPHERALS_READ 		<= 1'b0; 
		//
		STATESCONTROLLER_CPU_Reset 			 				<= 1'b0;
		STATESCONTROLLER_CPU_EN  				 				<= 1'b1;	
		STATESCONTROLLER_CPU_ProgramReset 	 		<= 1'b0;
		
		if(STATESCONTROLLER_CPU_END_Detected)
			_state_machine = END;
		else if(PROGRAMMMER_Reset)
			_state_machine = PROGRAMMING_RESET;
	end
	END:
	begin
		STATESCONTROLLER_BITPERIPHERALS_WRITE 	<= 1'b1;
		//
		STATESCONTROLLER_CPU_EN 			 	 		 		<= 1'b0;
		STATESCONTROLLER_CPU_ProgramReset  	 		<= 1'b1;	
		
		if(!STATESCONTROLLER_CPU_END_Detected && !STATESCONTROLLER_WAIT)
			_state_machine = WORK; 
	end
	
	
	/* --------------------------------------------------------------------------------------- */
	//																		    INPUTS
	/* ----------------------------------------------------------------------------------------*/

	
	PROGRAMMING_RESET:	//Programming:
	begin
		STATESCONTROLLER_CPU_Reset 			 		<= 1'b1;
		STATESCONTROLLER_CPU_EN  				 		<= 1'b0;	
		STATESCONTROLLER_CPU_ProgramReset 	<= 1'b1;
		
		if(!PROGRAMMMER_Reset)
			_state_machine = INIT;
	end
	endcase
end

endmodule 