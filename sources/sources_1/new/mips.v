module mips #(parameter WIDTH = 8, REGBITS = 3, PCSTART = 0) 
(input clk, reset, grant, input [WIDTH-1:0] memdata, output memread, memwrite, 
output [WIDTH-1:0] adr, writedata);
    
    wire [31:0] instr;
    wire zero, alusrca, memtoreg, lord, pcen, regwrite, regdst, pcsource, irenable, hit, add4pc;
    wire [1:0] aluop, alusrcb;
    wire [3:0] irwrite;
    wire [2:0] alucont;
    wire [WIDTH-1:0] nextaddr, aluout, pc;
    
    controller cont(.clk(clk), .reset(reset), .op(instr[31:26]), .zero(zero), .grant(grant),
        .memread(memread), .memwrite(memwrite), .alusrca(alusrca), .memtoreg(memtoreg),
        .lord(lord), .pcen(pcen), .regwrite(regwrite), .regdst(regdst),
        .pcsource(pcsource), .alusrcb(alusrcb), .aluop(aluop), .irwrite(irwrite), .irenable(irenable), .hit(hit), .add4pc(add4pc));
        
    alucontroller ac(.aluop(aluop), .funct(instr[5:0]), .alucont(alucont));
    
    pccontroller #(WIDTH, PCSTART) p0(.pcen(pcen), .pc(pc), .nextaddr(nextaddr), .clk(clk));
    
    mux21 #(WIDTH) ADDRESS(.D0(pc), .D1(aluout), .S(lord), .Y(adr));
    
    datapath2 #(WIDTH, REGBITS)
        dp(.clk(clk), .memdata(memdata), .alusrca(alusrca), .memtoreg(memtoreg), .lord(lord),
        .regwrite(regwrite), .regdst(regdst), 
        .pcsource(pcsource), .alusrcb(alusrcb), .irwrite(irwrite), .alucont(alucont), .zero(zero), 
        .instr(instr), .pc(pc), .result(nextaddr), .aluout(aluout), .memwritedata(writedata),
         .irenable(irenable), .hit(hit), .add4pc(add4pc));
endmodule