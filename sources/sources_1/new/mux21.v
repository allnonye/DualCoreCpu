module mux21 #(parameter WIDTH = 8)(D0, D1, S, Y);
    output [WIDTH-1:0] Y;
    input [WIDTH-1:0] D0, D1;
    input S;
    assign Y=(S)?D1:D0;
endmodule
