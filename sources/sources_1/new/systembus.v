`timescale 1ns / 1ps

module systembus #(parameter WIDTH = 8) (input clk,
    input reset,
    input [1:0] request,
    input  [WIDTH-1:0] adr0, adr1, writedata0, writedata1,
    input memwrite0, memwrite1,
    output reg [1:0] grant = 2'b00,
    output reg [WIDTH-1:0] writedata, adr,
    output reg memwrite = 0);
    reg token = 0;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 2'b00; token <= 1'b0;
        end
        else begin
            case (request)
                2'b00: grant <= 2'b00;
                2'b01: grant <= 2'b01;
                2'b10: grant <= 2'b10;
                2'b11:
                    begin 
                        if (token)
                            grant <= 2'b10;
                        else
                            grant <= 2'b01;
                        token <= ~token;
                    end
            endcase     
        end
    end
    
    always @(*) begin
        case(grant)
            2'b01: 
                begin 
                    adr <= {1'b0, adr0[WIDTH-2:0]};
                    writedata <= {1'b0, writedata0};
                    memwrite <= memwrite0;
                end
            2'b10: 
                begin 
                    adr <=  {1'b1, adr1[WIDTH-2:0]};
                    writedata <= {1'b0, writedata1};
                    memwrite <= memwrite1;
                end
                
            default:
                begin
                    adr <= 0;
                    writedata <= 0; 
                    memwrite <= 0;
                end
        endcase
    end

endmodule
