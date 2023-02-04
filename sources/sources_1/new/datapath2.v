module datapath2 #(parameter WIDTH = 8, REGBITS = 5)(
    input clk,
    input [WIDTH-1:0] memdata,
    input alusrca,
    input memtoreg,
    input lord,
    input regwrite,
    input regdst,
    input pcsource,
    input irenable,
    input add4pc,
    input [1:0] alusrcb,
    input [3:0] irwrite,
    input [2:0] alucont,
    output hit,
    output reg zero,
    output reg [31:0] instr = 0,
    output [WIDTH-1:0] result, aluout, 
    output [WIDTH-1:0] memwritedata,
    input [WIDTH-1:0] pc
    );
    
    wire [WIDTH-1:0] rd1, rd2, A, B, writedata, B1;
    wire [15:0] immediate;
    wire [WIDTH-1:0] jumpaddr;
    wire [REGBITS-1:0] writereg;
    wire zerobuff;
    
    reg [WIDTH-1:0] memdatareg = 0;
    reg [31:0] one = 32'd1;
    
    wire [31:0] cacheinstr;
    wire ircachewrite;
    
    ircache i0(.clk(clk), .data(instr), .adr(pc), .wenable(ircachewrite), .instr(cacheinstr), .hit(hit));
    assign ircachewrite = irwrite == 4'b1000;
    
    always @(posedge clk) begin
        if (zerobuff)
            zero <= 1;
        else
            zero <= 0;
            
        if(lord)
            memdatareg <= memdata;
        if (irenable) begin
//            if (hit)
//                instr <= cacheinstr;
//            else
         begin
                case(irwrite)
                    4'b0001: instr[7:0] <= memdata;
                    4'b0010: instr[15:8] <= memdata;
                    4'b0100: instr[23:16] <= memdata;
                    4'b1000: instr[31:24] <= memdata; 
                    default: ;
                endcase
            end
        end
    end
    
    assign immediate = instr[15:0];
    assign zerobuff = (aluout == 8'b00000000);
    assign jumpaddr = instr[WIDTH-1:0] << 2;
    assign memwritedata = rd2;
    
    regfile #(WIDTH, REGBITS) r0(.clk(clk), .ra1(instr[25:21]), .ra2(instr[20:16]), .wa(writereg),
     .regwrite(regwrite), .wd(writedata), .rd1(rd1), .rd2(rd2));
     
    alu #(WIDTH) a0(.a(A), .b(B), .alucont(alucont), .result(aluout));
    mux21 #(WIDTH) ALUA(.D0(pc), .D1(rd1), .S(alusrca), .Y(A));
    mux21 #(5) WRITEREG(.D0(instr[20:16]), .D1(instr[15:11]), .S(regdst), .Y(writereg));
    mux21 #(WIDTH) PCSOURCE(.D0(aluout), .D1(jumpaddr), .S(pcsource), .Y(result));
    mux21 #(WIDTH) WRITEDATA(.D0(aluout), .D1(memdatareg), .S(memtoreg), .Y(writedata));
    mux41 #(WIDTH) ALUB(.a(rd2), .b(one[WIDTH-1:0]), .c(immediate[WIDTH-1:0]), .d(immediate[WIDTH-1:0] << 2), .s(alusrcb), .out(B1));
    mux21 #(WIDTH) CACHEHIT(.D0(B1), .D1(8'd4), .S(1'b0), .Y(B));
    
endmodule
