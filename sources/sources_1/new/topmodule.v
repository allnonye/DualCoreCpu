`timescale 1ns / 1ps
module topmodule(
    input clk,
    input reset,
    input [15:0] switches,
    input [3:0] buttons,
    output [15:0] lights,
    output [3:0] AN,
    output [6:0] CA
    );
    
    parameter WIDTH = 8, REGBITS = 5;
    
    wire [1:0] memread_sb, memwrite_sb;
    wire [WIDTH-1:0] adr0, adr1,  writedata0, writedata1, memdata;
    wire [1:0] request, grant;
    wire [WIDTH-1:0] writedata, adr, memdatafull;
    wire memwrite;
    wire [15:0] digits;
    
    assign memdata = memdatafull[WIDTH-1:0];
    assign request[0] = memread_sb[0] | memwrite_sb[0];
    assign request[1] = memread_sb[1] | memwrite_sb[1];
    
    mips #(WIDTH, REGBITS, 0) m0 (.clk(clk), .reset(reset), .grant(grant[0]), .memdata(memdata),
     .memread(memread_sb[0]), .memwrite(memwrite_sb[0]), .adr(adr0), .writedata(writedata0));
     
    mips #(WIDTH, REGBITS, 0) m1 (.clk(clk), .reset(reset), .grant(grant[1]), .memdata(memdata),
     .memread(memread_sb[1]), .memwrite(memwrite_sb[1]), .adr(adr1), .writedata(writedata1));
    
    
    systembus #(WIDTH) s0 (.clk(clk), .reset(1'b0), .request(request),.adr0(adr0), .adr1(adr1),
                    .writedata0(writedata0), .writedata1(writedata1),
                    .memwrite0(memwrite_sb[0]), .memwrite1(memwrite_sb[1]), .grant(grant),
                    .writedata(writedata), .adr(adr), .memwrite(memwrite) );
                    
    extememory #(WIDTH) e0 (.clk(clk), .memwrite(memwrite), .adr(adr), .writedata(writedata), .memdata(memdatafull),
                                .lights(lights), .switches(switches), .buttons(buttons), .digits(digits));
           
    Sevseg s1(.clk(clk), .clr(1'b0), .Dig0(digits[3:0]), .Dig1(digits[7:4]), .Dig2(digits[11:8]), .Dig3(digits[15:12]), .CA(CA), .AN(AN));
endmodule
