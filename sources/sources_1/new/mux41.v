module mux41 #(parameter WIDTH = 8) ( 
input [WIDTH-1:0] a, b, c, d,
input [1:0] s,
output [WIDTH-1:0] out); 

 assign out = s[1] ? (s[0] ? d : c) : (s[0] ? b : a); 

endmodule
