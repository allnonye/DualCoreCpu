module alucontroller(input [1:0] aluop, input [5:0] funct, output reg [2:0] alucont);
    always @(*)
        case(aluop)
            2'b00: alucont <= 3'b010;
            2'b01: alucont <= 3'b110;
            default: case(funct)
                6'b100000: alucont <= 3'b010; // add
                6'b100010: alucont <= 3'b110; // subtract
                6'b100100: alucont <= 3'b000; // and
                6'b100101: alucont <= 3'b001; // 
                6'b101010: alucont <= 3'b111;
                default: alucont <= 3'b101;
            endcase
        endcase
endmodule
