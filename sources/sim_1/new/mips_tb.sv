module mips_tb;
    reg clk = 0, reset = 0;
    wire memread, memwrite;
    wire [7:0] adr, writedata;
    reg [31:0] memory [5] = '{32'b001000_00000_00011__0000000000001010,
                              32'b000000_00011_00011_00011_00000_100000,
                              32'b000000_00011_00011_00011_00000_100000,
                              32'b000000_00011_00011_00011_00000_100000,
                              32'b000000_00011_00011_00011_00000_100000};
    bit [7:0] bytememory [16] = '{8'h20,
                                  8'h00,
                                  8'h18,
                                  8'h0a,
                                  8'h00,
                                  8'h63,
                                  8'h18,
                                  8'h20,
                                  8'h00,
                                  8'h63,
                                  8'h18,
                                  8'h20,
                                  8'h00,
                                  8'h63,
                                  8'h18,
                                  8'h20
                                 };
    reg [7:0] mybyte = 0;
    
    always #1 clk = ~clk;
    
//    always @(posedge clk)
//        mybyte <= bytememory[m0.p0.pc % 16];
    
    mips #(8, 5) m0
    (.clk(clk), .reset(reset), .memdata(mybyte), .memread(memread), .memwrite(memwrite), .adr(adr), .writedata(writedata));
    
    task automatic execute(input [31:0] instr, ref [7:0] mem);
        mem = instr[31:24];
        #2;
        mem = instr[23:16];
        #2;
        mem = instr[15:8];
        #2;
        mem = instr[7:0];
        #4;
    endtask
    
    
    initial begin
        execute(memory[0],  mybyte);
        execute(memory[1],  mybyte);
        execute(memory[2],  mybyte);
        execute(memory[3],  mybyte);
        #10;
        
//        #300;
        
        $finish;
    end
    
endmodule

   