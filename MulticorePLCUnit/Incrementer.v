module Incrementer
(
	input  [3:0] InputValue,
	output [3:0] IncrementedValue

);

	wire middle_and;
		
	assign middle_and = InputValue[0] & InputValue[1];

	assign IncrementedValue [0] = ~ InputValue[0];
	assign IncrementedValue [1] = 	 InputValue[0] ^ InputValue[1];
	assign IncrementedValue [2] = 	 middle_and ^ InputValue[2];
	assign IncrementedValue [3] =   (middle_and & InputValue[2]) ^ InputValue[3]; 
	
	
	

endmodule 