module ClockEnable(
input clk,
input reset,
output reg clk_en = 0
    );
parameter max_count = 19999;
integer count = 0;


    always @(posedge clk) begin
    if (reset)
        count <= 0;
    else begin
        if(count == max_count)
            begin
                count <= 0;
                clk_en <= 1;
            end
        else
            begin
               count <= count + 1;
               clk_en <= 0;
            end  
            end
    end
endmodule
