module regfile #(parameter WIDTH = 8, REGBITS = 5) (rd1, rd2, clk, regwrite, ra1, ra2, wa, wd);
    input clk;
    input regwrite;
    input [REGBITS-1:0] ra1, ra2, wa;
    input [WIDTH-1:0] wd;
    output [WIDTH-1:0] rd1, rd2;
    
    reg [WIDTH-1:0] CPURegs [7:0];
    
    
    
    always @(posedge clk) begin
            if (regwrite) CPURegs[wa] <= wd;
            CPURegs[0] <= 0;
    end
        
    assign rd1 = ra1 ? CPURegs[ra1] : 0;
    assign rd2 = ra2 ? CPURegs[ra2] : 0;
endmodule
