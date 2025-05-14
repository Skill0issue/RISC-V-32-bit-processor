`include "ALU.v"
`include "control_unit.v"
`include "alu_control.v"
`include "program_counter.v"
`include "immediate_generator.v"
`include "library/instruction_memory.v"
`include "library/ram.v"
`include "library/register_bank.v"



module cpu (
    input clk,
    input reset,
    output [31:0] pc,                  // Expose the program counter (pc)
    output [31:0] regs[31:0],        // Expose the 32 registers
    output [31:0] memory_data [2047:0]
);

    // === Wires and internal signals ===
    output wire [31:0] pc_current, pc_next, instruction;
    wire [4:0]  rs1, rs2, rd;
    wire [31:0] read_data1, read_data2;
    wire [31:0] imm;
    wire [31:0] alu_input2, alu_result;
    wire [31:0] mem_read_data;
    wire [31:0] write_back_data;
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire        alu_zero;

    // === Control signals ===
    wire alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch;
    wire [1:0] alu_op;
    wire [4:0] alu_control_signal;

    // === Instruction Fetch ===
    program_counter pc_reg(
        .clk(clk),
        .reset(reset),
        .pc_in(pc_next),
        .enable(1'b1),
        .pc_out(pc_current)
    );

    instruction_memory imem(
        .address(pc_current),
        .instruction(instruction)
    );

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    // === Decode & Register File ===
    reg_bank registers(
        .write_data(write_back_data),
        .source_1(rs1),
        .source_2(rs2),
        .des_reg(rd),
        .clk(clk),
        .write(reg_write),
        .reset(reset),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Expose the 32 registers to the testbench
    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin : reg_output
            assign regs[i] = registers.reg_file[i];  // Connecting registers to the output
        end
    endgenerate

    // === Immediate Generation ===
    immediate_generator immediate_unit(
        .instr(instruction),
        .imm_out(imm)
    );

    // === Control Unit ===
    control_unit ctrl(
        .opcode(opcode),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .alu_op(alu_op)
    );

    // === ALU Control Logic ===
    alu_control alu_ctrl(
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control_signal)
    );

    // === ALU Execution ===
    assign alu_input2 = (alu_src) ? imm : read_data2;

    ALU #(.BUS_WIDTH(32)) alu_main(
        .A(read_data1),
        .B(alu_input2),
        .CARRY_IN(1'b0),
        .ALU_OP(alu_control_signal),
        .ALU_RES(alu_result),
        .CARRY_OUT(),
        .BORROW(),
        .ZERO(alu_zero),
        .PARITY(),
        .INVALID_OP()
    );

    // === Data Memory ===
    ram #(.BUS_WIDTH(32), .MEMSIZE(4096)) data_mem(
        .data_in(read_data2),
        .addr(alu_result),
        .write(mem_write),
        .cs(1'b1),
        .clk(clk),
        .data_out(mem_read_data)
    );
    
    //acessing memory data to the testbenchclear
    
    genvar j;
    generate
        for (j = 0; j < 2048; j = j + 1) begin : mem_output
            assign memory_data[j] = data_mem.memory[j];
        end
    endgenerate

    // === Write Back ===
    assign write_back_data = (mem_to_reg) ? mem_read_data : alu_result;

    // === Branch Logic ===
    assign pc_next = (branch && alu_zero) ? (pc_current + imm) : (pc_current + 4);

    // Expose the program counter to the testbench
    assign pc = pc_current;

endmodule
