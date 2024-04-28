 module CPU_WORLD(OUTPUTS,PROGRAMMER_ACK);

/* --------------------------------------------------------------------------------------- */
//																		CPU PARAMETERS
/* ----------------------------------------------------------------------------------------*/

	parameter NumberOfCores 			= 2;
	parameter NumberOfSemaphores 	= 4;

/* --------------------------------------------------------------------------------------- */
//																		    INPUTS
/* ----------------------------------------------------------------------------------------*/

	// ------------------- INPUTS -----------------------
	reg 			 CLK;
	
	reg				 CPU_HOLD;
	
	//Undervoltage reset:
	reg				 PS;
	
	//Programmer:
	reg				 PROGRAMMER_Reset;
	reg	[7:0]	 PROGRAMMER_InputData;
	reg				 PROGRAMMER_PCK;
	reg				 PROGRAMMER_SCK;
	
	//Diagnostics stop after program execution:
	reg				 DIAGNOSTIC_WAIT;	
	
	// IO:
	reg	[15:0] INPUTS;
	
	// -------------------- OUTPUTS ---------------------
	
	output wire	[15:0] 	OUTPUTS;
	output wire 				PROGRAMMER_ACK;
	
/* --------------------------------------------------------------------------------------- */
//																		    TESTBENCH
/* ----------------------------------------------------------------------------------------*/

integer i;

always begin
	#1 CLK = !CLK;
end

initial begin
	CLK 						 			= 0;
	INPUTS 					 			= 0;
	PROGRAMMER_Reset 			= 1;
	PROGRAMMER_InputData 	= 0;
	PROGRAMMER_PCK 				= 0;
	PROGRAMMER_SCK 				= 0;
	DIAGNOSTIC_WAIT 			= 0;
	CPU_HOLD						  = 0;
	PS = 0;
	
	#100
	//START:
	PS = 1; // Voltage threshold

	#100;
	
	PROGRAMMER_InputData 	= 8'b0001_1000;		//Set RLO
	#1  PROGRAMMER_SCK 		= 1;
	#1 PROGRAMMER_SCK 		= 0;
	
	PROGRAMMER_InputData 	= 8'b1100_0000;		//Save to semaphore
	#1  PROGRAMMER_SCK 		= 1;
	#1 PROGRAMMER_SCK 		= 0;
	
	PROGRAMMER_InputData 	= 8'b0000_0001;		//Addr: 1
	#1  PROGRAMMER_SCK 		= 1;
	#1 PROGRAMMER_SCK 		= 0;
	
	PROGRAMMER_InputData 	= 8'b1101_1110;		//Read from semaphore
	#1  PROGRAMMER_SCK 		= 1;
	#1 PROGRAMMER_SCK 		= 0;
	
	PROGRAMMER_InputData 	= 8'b0000_0001;		//Addr: 1
	#1  PROGRAMMER_SCK 		= 1;
	#1  PROGRAMMER_SCK 		= 0;
	
	#20
	PROGRAMMER_Reset = 0;
end


















/* --------------------------------------------------------------------------------------- */
//																		CPU UNIT
/* ----------------------------------------------------------------------------------------*/

	CPU_UNIT #
	(
		.NumberOfCores(NumberOfCores),
		.NumberOfSemaphores(NumberOfSemaphores)
	)
	_CPU_UNIT
	(
		.CLK(CLK),
		
		.CPU_HOLD(CPU_HOLD),
		
		// ------ POWER SUPPLY -----
		.PS(PS),
	
		// ---------- IO -----------
		.INPUTS(INPUTS),
		.OUTPUTS(OUTPUTS),
		
		// ------ PROGRAMMER -------
		.PROGRAMMER_Reset(PROGRAMMER_Reset),
		.PROGRAMMER_InputData(PROGRAMMER_InputData),
		.PROGRAMMER_PCK(PROGRAMMER_PCK),
		.PROGRAMMER_SCK(PROGRAMMER_SCK),
		//Ack:
		.PROGRAMMER_ACK(PROGRAMMER_ACK),
		
		// ------ DIAGNOSTICS -------
		.DIAGNOSTIC_WAIT(DIAGNOSTIC_WAIT)
	);

endmodule 