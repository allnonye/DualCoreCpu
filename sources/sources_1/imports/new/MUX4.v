

module MUX4(
    input [3:0] dig0,
    input [3:0] dig1,
    input [3:0] dig2,
    input [3:0] dig3,
    input [1:0] sel,
    output reg[3:0] X
    );
    
    always @(sel or dig0 or dig1 or 
    dig2 or dig3)
    begin
    case(sel)
    2'b00: X <= dig0;
    2'b01: X <= dig1;
    2'b10: X <= dig2;
    2'b11: X <= dig3;    
    endcase
    end
    
endmodule
