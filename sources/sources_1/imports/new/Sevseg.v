`timescale 1ns / 1ps

module Sevseg(
    input [3:0] Dig0,
    input [3:0] Dig1,
    input [3:0] Dig2,
    input [3:0] Dig3,
    input clr,
    input clk,
    output [3:0] AN,
    output [6:0] CA
    );
    
    
    wire [1:0] select;
    wire clk_en_wire;
    wire [3:0] X_wire;

    
    ClockEnable ce0 (.clk(clk), .clk_en(clk_en_wire), .reset(clr));
    AnodeDriver a0 (.clk_en(clk_en_wire), .AN(AN), .S(select));
    MUX4 m0 (.dig0(Dig0), .dig1(Dig1), .dig2(Dig2), .dig3(Dig3), .sel(select), .X(X_wire));
    HexDecoder x0 (.x(X_wire), .CA(CA));
    
endmodule
