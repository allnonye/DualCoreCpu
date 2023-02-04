typedef enum {ADD, SUB, AND_, OR_, SLT, ADDI, BEQ, LB, SB, J} opcode_e;

class Instruction;
    rand opcode_e op;
    rand bit [5:0] real_op = 6'b000000;
    rand bit [4:0] rs, rt, rd;
    rand bit [5:0] funct;
    rand bit [7:0] imm;
    
    bit [31:0] op_w [10] = '{default:1};
    
    constraint op_c {
        op dist {
            ADD := op_w[ADD], SUB := op_w[SUB], AND_ := op_w[AND_], OR_:= op_w[OR_], SLT := op_w[SLT], 
            ADDI := op_w[ADDI], BEQ := op_w[BEQ], J := op_w[J], LB := op_w[LB], SB := op_w[SB]};
    }
    
    constraint r_c {
        rs inside {[0:7]};
        rt inside {[0:7]};
        rd inside {[1:7]};
    };

    function void post_randomize();
        case (op)
            ADD: funct = 6'b100000;
            SUB: funct = 6'b100010;
            AND_: funct = 6'b100100;
            OR_: funct = 6'b100101;
            SLT: funct = 6'b101010;
        endcase
        case (op)
            LB: real_op = 6'b100000;
            SB: real_op = 6'b101000;
            BEQ: real_op = 6'b000100;
            J: real_op = 6'b000010;
            ADDI: real_op = 6'b001000;
            default: real_op = 6'b000000;
        endcase
    endfunction
    
    function string get();
        bit [31:0] instr;
        if (op inside {[0:4]})
            instr = {6'd0, rs, rt, rd, 5'd0, funct};
        else if (op inside {[5:8]})
            instr = {real_op, rs, rt, 8'd0, imm};
        else
            instr = {real_op, 20'd0, imm};

        return $sformatf("%8h", instr);

    endfunction
    
    function void display;
        if (op inside {[0:4]})
            $display("%s, r%0d, r%0d, r%0d", op, rd, rs, rt);
        else if (op inside {[5:8]})
            $display("%s, r%0d, r%0d, %0d", op, rt, rs, imm);
        else
            $display("%s, %0d", op, imm);

    endfunction
endclass

task automatic create_memory(Instruction i, input int num_instr, string filename);
    int fd = $fopen(filename, "w");
    $display("Creating Memory");
    
    init_regs(i, fd);
    
    repeat(num_instr) begin
        i.randomize();
        $fwrite(fd, "%s\n", i.get());
//        i.display();
    end
    $fwrite(fd, "08000000\n");
    $fwrite(fd, "@20 ");
    repeat(num_instr) begin
        i.randomize();
        $fwrite(fd, "%s\n", i.get());
//        i.display();
    end
    $fwrite(fd, "08000000\n");
    $display("Wrote %0d instructions to %s", num_instr, filename);
    $fclose(fd);
endtask

task automatic init_regs(Instruction i, int fd, val=3);
    i.op = ADDI;
    i.real_op = 6'b001000;
    i.rs = 0;
    i.imm = val; 
    
    for (int j = 1; j < 8; j++) begin
        i.rt = j; 
        $fwrite(fd, "%s\n", i.get());
    end
   
endtask

module topmodule_tb2;
    Instruction i;
    reg clk = 0, reset = 0;
    wire [15:0] switches, lights;
    reg [7:0] lowerswitches = 0, upperswitches = 0;
    assign switches = {upperswitches, lowerswitches};
    topmodule t0(.clk(clk), .reset(1'b0), .switches(switches), .lights(lights), .buttons(4'b0000));
    
    initial begin
        i = new();
        i.op_w[J] = 0;
        i.op_w[BEQ] = 0;
        i.op_w[SB] = 0;
        i.op_w[LB] = 0;
        create_memory(i, 20, "C:/Users/Allen/Documents/VivadoNew/final.srcs/sources_1/new/memfile_tb.mem");
        
        #5;
        $readmemh("memfile_tb.mem", t0.e0.RAM);
        #5;
        forever #1 clk = ~clk;
        #400;
        $finish;
    end
endmodule
