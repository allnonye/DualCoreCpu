`timescale 1ns / 1ps
module systembus_tb;

    bit [1:0] request = 2'b00;
    bit [7:0] adr0 = 5, adr1 = 5, writedata0 = 207, writedata1 = 55;
    bit clk = 0, reset = 0;
    
    wire [1:0] grant;
    wire [7:0] memdata;
    
    always #1 clk = ~clk;
    
    systembus #(8) s0 (
                  .clk(clk),
                  .reset(reset),
                  .request(request),
                  .adr0(adr0), 
                  .adr1(adr1), 
                  .writedata0(writedata0),
                  .writedata1(writedata1),
                  .memwrite0(1'b0),
                  .memwrite1(1'b0),
                  .grant(grant),
                  .memdata(memdata));
    
    
    
    initial begin
        for(int i = 0; i < 40; i++) begin
            request <= i;
            #2;
        end


    
        
        $finish;
    end
    
endmodule
