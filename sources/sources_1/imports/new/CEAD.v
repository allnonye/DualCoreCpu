`timescale 1ns / 1ps

module CEAD(
input clk,
input reset,
output wire [3:0] AN,
output wire [1:0] S,
output wire clk_enable
    );
wire clk_en_wire;
assign clk_enable = clk_en_wire;

ClockEnable ce0 (.clk(clk), .clk_en(clk_en_wire));
AnodeDriver a0 ( .reset(reset), .clk_en(clk_en_wire),
 .clk(clk), .AN(AN), .S(S));
    
endmodule
