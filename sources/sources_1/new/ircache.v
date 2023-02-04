`timescale 1ns / 1ps
module ircache #(parameter WIDTH = 8) (
    input clk,
    input [31:0] data,
    input [WIDTH-1:0] adr,
    input wenable,
    output reg [31:0] instr,
    output reg hit = 0
    );
    
    reg [35:0] cache [7:0];
    wire [3:0] tag;
    wire [2:0] line;
    reg [31:0] oldinstr = 32'h20000000;
    reg [WIDTH-1:0] oldadr = 0;
    reg dowrite = 1'b0;
    integer i;
    
    assign tag = {1'b0, oldadr[7:5]};
    assign line = oldadr[4:2];
    
     
    always @(posedge clk) begin
        if (wenable)
            dowrite <= 1'b1;
            
         oldadr <= adr;
         
         hit <= cache[line][35:32] == tag;
         instr <= oldinstr;
    end
    
    always @(negedge clk) begin
        if (hit)
            oldinstr <= cache[line][31:0];
        else
            oldinstr <= 32'h20000000;
        if (dowrite)
            cache[line] <= {1'b0, tag, data};
        
//        dowrite <= 1'b0;
    end       
            
     initial begin
        for (i=0; i < 8; i=i+1)
            cache[i] = 36'hFFFFFFFFF;
     end
endmodule
