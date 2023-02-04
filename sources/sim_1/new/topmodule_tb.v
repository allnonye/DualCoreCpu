module topmodule_tb;

    reg clk = 0, reset = 0;
    wire [15:0] switches;
    wire [15:0] lights;
    wire cpuselect;
    reg [3:0] buttons = 4'b0000;
    reg [7:0] lowerswitches = 0, upperswitches = 0;
    integer i = 0;
    wire [7:0] out, in;
    
    topmodule t0(.clk(clk), .reset(reset), .switches(switches), .lights(lights), .buttons(buttons));

    assign cpuselect = upperswitches[7];
    assign switches = {upperswitches, lowerswitches};
    assign in = t0.e0.digits[15:8];
    assign out = t0.e0.digits[7:0];
    
    always #1 clk = !clk;    
    initial begin
        upperswitches[7] <= 1'b1;
        #1000;
        for (i = 0; i < 12; i = i + 1) begin
            upperswitches[6:0] <= i;
             #2500;
        end
        
        upperswitches[7] <= ~upperswitches[7];
        
        for (i = 0; i < 12; i = i + 1) begin
            lowerswitches <= i*i;
             #2500;
        end
        
        #10000;
        $finish;
    end
    
endmodule