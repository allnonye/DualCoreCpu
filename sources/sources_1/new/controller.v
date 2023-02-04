`timescale 1ns / 1ps

module controller(
    input clk,
    input reset,
    input [5:0] op,
    input zero,
    input grant,
    input hit,
    output reg add4pc = 0,
    output reg irenable = 1,
    output reg memread = 0,
    output reg memwrite = 0,
    output reg alusrca = 0,
    output reg memtoreg = 0,
    output reg lord = 0,
    output pcen,
    output reg regwrite = 0, 
    output reg regdst = 0,
    output reg pcsource = 0,
    output reg [1:0] alusrcb = 2'b00, 
    output reg [1:0] aluop = 2'b00,
    output reg [3:0] irwrite = 4'b0000);
    

    parameter CACHE = 4'b0000;
    parameter FETCH1 = 4'b0001;
    parameter FETCH2 = 4'b0010;
    parameter FETCH3 = 4'b0011;
    parameter FETCH4 = 4'b0100;
    parameter DECODE = 4'b0101;
    parameter MEMADR = 4'b0110;
    parameter LBRD = 4'b0111;
    parameter LBWR = 4'b1000;
    parameter SBWR = 4'b1001;
    parameter RTYPEEX = 4'b1010;
    parameter RTYPEWR = 4'b1011;
    parameter BEQEX = 4'b1100;
    parameter JEX = 4'b1101;
    parameter ADDIWR = 4'b1110;
    parameter BEQNEXT = 4'b1111;
    
    
    parameter LB = 6'b100000;
    parameter SB = 6'b101000;
    parameter RTYPE = 6'b000000;
    parameter BEQ = 6'b000100;
    parameter J = 6'b000010;
    parameter ADDI = 6'b001000;
    
    reg [3:0] state = FETCH1, nextstate =  FETCH1;
    reg pcwrite = 0, pcwritecond = 0;
    
//    assign pcen = (pcwritecond & zero) ^ pcwrite;
    assign pcen = pcwrite;
    
    always @(negedge clk)
        begin
        case(state)
            FETCH1: begin
//                if (hit)
//                    nextstate <= DECODE;
                if(grant)
                    nextstate <= FETCH2;
            end
            FETCH2: if(grant) nextstate <= FETCH3;
            FETCH3: if(grant) nextstate <= FETCH4;
            FETCH4: if(grant) nextstate <= DECODE;
            DECODE: 
                case(op)
                    LB: nextstate <= MEMADR;
                    SB: nextstate <= MEMADR;
                    ADDI: nextstate <= ADDIWR;
                    RTYPE: nextstate <= RTYPEEX;
                    BEQ: nextstate <= BEQEX;
                    J: nextstate <= JEX;
                    default: nextstate <= FETCH1;
                endcase
            MEMADR: 
                case(op)
                    LB: nextstate <= LBRD;
                    SB: nextstate <= SBWR;
                    ADDI: nextstate <= ADDIWR;
                    default: nextstate <= FETCH1;
                endcase
            LBRD: if(grant) nextstate <= LBWR;
            LBWR: nextstate <= FETCH1;
            SBWR: if(grant) nextstate <= FETCH1;
            RTYPEEX: nextstate <= RTYPEWR;
            RTYPEWR: nextstate <= FETCH1;
            BEQEX: nextstate <= BEQNEXT;
            BEQNEXT: nextstate <= FETCH1;
            JEX: nextstate <= FETCH1;
            ADDIWR: nextstate <= FETCH1;
            default: nextstate <= FETCH1;
        endcase
    end
    
    always @(*) begin
        irwrite <= 4'b0000;
        pcwrite <= 0;
        pcwritecond <= 0;
        regwrite <= 0;
        regdst <= 0;
        memread <= 0;
        memwrite <= 0;
        alusrca <= 0;
        alusrcb <=2'b01;
        aluop <= 2'b00;
        pcsource <= 0;
        lord <= 0;
        memtoreg <= 0;
        irenable <= 0;
        add4pc <= 0;
        case(state)
            FETCH1:
                begin
                    irenable <= 1;
                    memread <= 1;
                    alusrcb <= 2'b01;
                    pcwrite <= grant ;//| hit;
//                    add4pc <= hit;
                    if (grant)
                        irwrite <= 4'b0001;
                        
                end
            FETCH2:
                begin
                    irenable <= 1;
                    memread <= 1;
                    pcwrite <= grant;
                    alusrcb <= 2'b01;
                    if (grant) 
                        irwrite <= 4'b0010;
                        
                end
            FETCH3:
                begin
                    irenable <= 1;
                    memread <= 1;
                    pcwrite <= grant;
                    alusrcb <= 2'b01;
                  if (grant) 
                        irwrite <= 4'b0100;
                end
            FETCH4:
                begin
                    irenable <= 1;
                    memread <= 1;
                    pcwrite <= grant;
                    alusrcb <= 2'b01;
                    if (grant) 
                        irwrite <= 4'b1000;
                end
            DECODE: begin end
            MEMADR:
                begin
                    alusrca <= 1;
                    aluop <= 2'b00;
                    alusrcb <= 2'b10;
                    lord <= 1;
                    memwrite <= (nextstate == SBWR);
                    memread <= (nextstate == LBRD);
                end
           LBRD:
                begin
                    alusrca <= 1;
                    aluop <= 2'b00;
                    alusrcb <= 2'b10;
                    lord <= 1;
                    memread <= 1;
                    memtoreg <= 1;
                end
           LBWR:
                begin
                    
                    regwrite <= 1;
                    regdst <= 0;
                    memtoreg <= 1;
                end
           SBWR:
                begin
                    alusrca <= 1;
                    aluop <= 2'b00;
                    alusrcb <= 2'b10;
                    lord <= 1;
                    memwrite <= 1;
                end
           RTYPEEX:
                begin
                    alusrca <= 1;
                    alusrcb <= 2'b00;
                    aluop <= 2'b11;
                    regwrite <= 1;
                    regdst <= 1;
                end
           RTYPEWR:
                begin
//                    regwrite <= 1;
                    regdst <= 1;
                    memtoreg <= 0;
                end
           BEQEX:
                begin
                    alusrca <= 1;
                    alusrcb <= 2'b00;
                    aluop <= 2'b01;
                end
           BEQNEXT:
                begin
                    alusrca <= 0;     
                    alusrcb <= 2'b11; 
                    aluop <= 2'b00;
                    pcwrite <= zero; // grant??  
                end
           ADDIWR:
               begin
                    alusrca <= 1;
                    regwrite <= 1;
                    memtoreg <= 0;
                    alusrcb <= 2'b10;
                    aluop <= 2'b00;
               end
           JEX:
                begin
                   pcsource <= 1;
                   pcwrite <= 1;
                end       
            
        endcase
    end
    
    always @(posedge clk) begin
        if (reset)
            state <= FETCH1;
        else
            state <= nextstate;
    end
    
    

    
endmodule
