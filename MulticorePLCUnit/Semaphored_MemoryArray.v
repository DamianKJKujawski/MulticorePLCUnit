module Semaphored_MemoryArray
(
input  wire clk,

input  wire [$clog2(SemaphoreArraySize)-1:0] WR_Addr,
input  wire [$clog2(SemaphoreArraySize)-1:0] RD_Addr, 

input  wire WR,
input  wire WR_EN,
output wire WR_RDY,

input  wire RD_Release,
input  wire RD,
input  wire RD_EN,
output wire RD_RDY
);

localparam SemaphoreArraySize = 15;

reg [SemaphoreArraySize:0] wWR_EN;
reg [SemaphoreArraySize:0] wRD_EN;
reg [$clog2(SemaphoreArraySize)-1:0] eWR_Addr;
reg [$clog2(SemaphoreArraySize)-1:0] eRD_Addr;




integer l;

always @(*)
begin
	for(l=0; l<=($clog2(SemaphoreArraySize)-1); l=l+1)
		begin
			eWR_Addr[l] = (WR_EN)? WR_Addr[l]: 1'b0;
			eRD_Addr[l] = (RD_EN)? RD_Addr[l]: 1'b0;
		end
end


integer j;

always @(*)
begin
	for(j=1; j<=SemaphoreArraySize; j=j+1)
	begin
		if(eWR_Addr[$clog2(SemaphoreArraySize)-1:0] == j[$clog2(SemaphoreArraySize)-1:0]) 
			wWR_EN[j] <= 1'b1;
	else
			wWR_EN[j] <= 1'b0;
	end
end




integer k;

always @(*)
begin
	for(k=1; k<=SemaphoreArraySize; k=k+1)
	begin
		if(eRD_Addr[$clog2(SemaphoreArraySize)-1:0] == k[$clog2(SemaphoreArraySize)-1:0]) 
			wRD_EN[k] <= 1'b1;
	else
			wRD_EN[k] <= 1'b0;
	end
end


genvar i;
generate
	for (i=1; i<=SemaphoreArraySize; i=i+1) 
	begin 
		: generate_Semaphored_BitMemory_Instance
		Semaphored_BitMemory Semaphored_BitMemory_Instance
		(
			.clk(clk),

			.WR(WR),
			.WR_EN(wWR_EN[i]),
			.WR_RDY(WR_RDY),

			.RD_Release(RD_Release),
			.RD(RD),
			.RD_EN(wRD_EN[i]),
			.RD_RDY(RD_RDY)
		);
	end
endgenerate





endmodule 