module PC_COUNTER
#
(
	parameter CounterBits = 6
)
(
	//BASIC:
	input wire 		 											CLK,
	
	//JUMP:
	//Addr:
	input wire	[(CounterBits - 1):0] 	PC_JMPAddr,
	//Driver inputs:
	input wire 		 											CPU_SetReset,
	input wire 		 											PC_SetJmp,
	input wire 		 											PC_SetStop,
	
	//OUTPUT ADDRESS:
	output reg	[(CounterBits - 1):0] 	PC_Counter
);

wire [(CounterBits - 1):0] 	JMP_Addr;
wire [(CounterBits - 1):0] 	PC_Addr;
wire 												pcCounterEN;

assign pcCounterEN 	= !CPU_SetReset && !PC_SetStop;
assign JMP_Addr 		= (PC_SetJmp)    ? PC_JMPAddr : (PC_Counter + 1'b1);
assign PC_Addr  		= (pcCounterEN)  ? JMP_Addr   :  PC_Counter;
				
//LOGIC:
always @(posedge CLK or posedge CPU_SetReset)
begin 
	if(CPU_SetReset)
		PC_Counter <= 0;
	else
		PC_Counter <= PC_Addr;
end

//TESTBENCH INIT:
initial begin
	PC_Counter = 0;
end

endmodule 