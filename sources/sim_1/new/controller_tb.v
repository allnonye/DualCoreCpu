module controller_tb;
    reg clk = 0;
    wire [31:0] instr;
    wire alusrca, memtoreg, lord, pcen, regwrite, regdst;
    wire [1:0] aluop, pcsource, alusrcb;
    wire [3:0] irwrite;
    wire [2:0] alucont;
    reg zero;
    wire memread, memwrite;
    
    always #1 clk = ~clk;
    
    alucontroller ac(.aluop(aluop), .funct(instr[5:0]), .alucont(alucont));
    
    controller cont(.clk(clk), .reset(reset), .op(instr[31:26]), .zero(zero),
    .memread(memread), .memwrite(memwrite), .alusrca(alusrca), .memtoreg(memtoreg),
    .lord(lord), .pcen(pcen), .regwrite(regwrite), .regdst(regdst),
    .pcsource(pcsource), .alusrcb(alusrcb), .aluop(aluop), .irwrite(irwrite));
    
    datapath2 d0 (
    .clk(clk),
    .reset(reset),
    .memdata(8'b01010101),
    .alusrca(alusrca),
    .memtoreg(memtoreg),
    .lord(lord),
    .regwrite(regwrite),
    .regdst(regdst),
    .pcsource(pcsource),
    .alusrcb(alusrcb),
    .irwrite(irwrite),
    .alucont(alucont),
    .zero(zero),
    .instr(instr),
    .adr(0),
    .writedata(8'b00100100),
    .pcen(pcen)
    );
    initial begin
        {zero} = 0;
        #5;
        $display("Hello");
        #30;
        $finish;
    end
endmodule
