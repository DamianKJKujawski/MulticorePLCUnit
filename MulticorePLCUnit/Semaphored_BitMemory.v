module Semaphored_BitMemory
(
input  wire clk,

input  wire WR,
input  wire WR_EN,
output wire  WR_RDY,

input  wire RD_Release,
input  wire RD,
input  wire RD_EN,
output wire  RD_RDY
);


reg [1:0] SemaphoreState;


wire RD_Gate;
wire WR_Gate;

reg rWR_RDY;
reg rRD_RDY;

assign RD_Gate = RD && RD_Release && RD_EN;
assign WR_Gate = WR && WR_EN;

assign WR_RDY = (WR_EN)? rWR_RDY:1'bz;
assign RD_RDY = (RD_EN)? rRD_RDY:1'bz;




always @(posedge clk)
begin
	case(SemaphoreState)
		2'b00:
		begin
			rWR_RDY <= 1'b0;
			rRD_RDY <= 1'b0;
		
			if(WR_Gate)
				SemaphoreState <= 2'b01;
		end
		2'b01:
		begin
			rWR_RDY <= 1'b1;
			rRD_RDY <= 1'b0;
		
			if(RD_Gate)
				SemaphoreState <= 2'b11;	
		end
		2'b10:
		begin
			rWR_RDY <= 1'b1;
			rRD_RDY <= 1'b0;
		
			if(RD_Gate)
				SemaphoreState <= 2'b00;	
		end
		2'b11:
		begin
			rWR_RDY <= 1'b1;
			rRD_RDY <= 1'b1;
		
			if(WR_Gate)
				SemaphoreState <= 2'b10;	
		end
	endcase
end

endmodule 