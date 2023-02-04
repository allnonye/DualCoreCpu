module extememory #(parameter WIDTH = 8) (clk, memwrite, adr, writedata, memdata, switches, buttons, lights, digits);
    input clk;
    input memwrite;
    input [WIDTH-1:0] adr, writedata;
    output reg [WIDTH-1:0] memdata;
    input [15:0] switches;
    input [3:0] buttons;
    output [15:0] lights;
    output [15:0] digits;
    
    localparam MEMSIZE = (1<<WIDTH-2)-1;
    localparam CPU1HIGHADDR = MEMSIZE;
    localparam CPU0HIGHADDR = MEMSIZE/2;

    reg [31:0] RAM[(MEMSIZE):0];
    wire [31:0] word;
    
    initial begin
        $readmemh("memfile.mem", RAM);
        end
    
    always @(posedge clk) begin
        if (memwrite)
            case (adr[1:0])
                2'b00: RAM[adr>>2][7:0] <= writedata;
                2'b01: RAM[adr>>2][15:8] <= writedata;
                2'b10: RAM[adr>>2][23:16] <= writedata;
                2'b11: RAM[adr>>2][31:24] <= writedata;
            endcase
        else begin
            RAM[CPU1HIGHADDR][15:8]<= {1'b0, switches[14:8]};
            RAM[CPU0HIGHADDR][15:8]<= switches[7:0];
            RAM[CPU1HIGHADDR][17:16]<= buttons[3:2];
            RAM[CPU0HIGHADDR][17:16]<= buttons[1:0];
        end   
    end
    
    assign word = RAM[adr>>2];
    
    always @(*)
        case (adr[1:0])
            2'b00: memdata <= word[7:0];
            2'b01: memdata <= word[15:8];
            2'b10: memdata <= word[23:16];
            2'b11: memdata <= word[31:24];
        endcase
       
    mux21 #(16) DIGITS(.D0({switches[7:0], RAM[CPU0HIGHADDR-1][7:0]}), 
    .D1({{1'b0, switches[14:8]}, RAM[CPU1HIGHADDR-1][7:0]}), .S(switches[15]), .Y(digits));
    assign lights = switches; //{RAM[CPU1HIGHADDR][7:0], RAM[CPU0HIGHADDR][7:0]};
endmodule