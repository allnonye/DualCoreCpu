`timescale 1ns / 1ps

module pccontroller #(WIDTH = 8, PCSTART = 0) (
    input pcen,
    input clk,
    output reg [WIDTH-1:0] pc = PCSTART,
    input [WIDTH-1:0] nextaddr
    );
    
    always @(posedge clk)
            if(pcen)
                pc <= nextaddr;
endmodule
