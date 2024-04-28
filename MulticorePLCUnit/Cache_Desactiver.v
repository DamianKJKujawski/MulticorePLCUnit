module Cache_Desactiver
(
input wire prev,
input wire in,

output wire out,
output wire next
);

//Description
assign out = in && ~prev;
assign next = in && prev;

//







endmodule 