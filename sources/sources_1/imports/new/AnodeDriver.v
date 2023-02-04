module AnodeDriver(
    input clk_en,
    output reg [3:0] AN = 0,
    output reg [1:0] S = 0
     );
    
    reg [1:0] count = 0;
    
    always @ (S)
     case (S)
          2'b00: AN <= 4'b1110;
          2'b01: AN <= 4'b1101;
          2'b10: AN <= 4'b1011;
          2'b11: AN <= 4'b0111;
     endcase   
    
    always @ (posedge clk_en)
        S = S + 1;
            
  
endmodule
