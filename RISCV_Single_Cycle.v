module RISCV_Single_Cycle (
    input clk,
    input rst_n,
    output [31:0] PC_out_top,
    output [31:0] Instruction_out_top
);
    // Internal wires
    wire [31:0] pc_current, pc_next, instruction;
    wire [31:0] immediate, reg_out1, reg_out2;
    wire [31:0] alu_operand2, alu_result, mem_read_data, wb_data;
    wire [31:0] pc_plus_4, branch_target, jalr_target;

    wire ctrl_reg_write, mem_read, mem_write, mem_to_reg;
    wire alu_src, branch, jump, zero;
    wire [3:0] ctrl_alu_op;
    wire [1:0] pc_src;
    wire pc_write;

    // PC logic
    assign pc_write = 1'b1;
    assign pc_plus_4 = pc_current + 4;
    assign branch_target = pc_current + immediate;
    assign jalr_target = reg_out1 + immediate;

    assign pc_next = (pc_src == 2'b00) ? pc_plus_4 :
                     (pc_src == 2'b01) ? branch_target :
                     (pc_src == 2'b10) ? jalr_target : pc_plus_4;

    // PC module
    PC pc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .pc_next(pc_next),
        .pc_write(pc_write),
        .pc_current(pc_current)
    );

    // Instruction Memory
    IMEM IMEM_inst (
        .addr(pc_current),
        .instruction(instruction)
    );

    // Control Unit
    ControlUnit ctrl_inst (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .ctrl_reg_write(ctrl_reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .ctrl_alu_op(ctrl_alu_op),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .pc_src(pc_src)
    );

    // Register File
    RegisterFile Reg_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .write_data(wb_data),
        .reg_write(ctrl_reg_write),
        .reg_out1(reg_out1),
        .reg_out2(reg_out2)
    );

    // Immediate Generator
    ImmGen immgen_inst (
        .instruction(instruction),
        .immediate(immediate)
    );

    // ALU operand selection
    assign alu_operand2 = alu_src ? immediate : reg_out2;

    // ALU
    ALU alu_inst (
        .in1(reg_out1),
        .in2(alu_operand2),
        .alu_op(ctrl_alu_op),
        .alu_result(alu_result),
        .zero(zero)
    );

    // Data Memory
    DMEM DMEM_inst (
        .clk(clk),
        .addr(alu_result),
        .mem_write_data(reg_out2),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_read_data(mem_read_data)
    );

    // Write Back
    assign wb_data = mem_to_reg ? mem_read_data : (jump ? pc_plus_4 : alu_result);

    // Outputs
    assign PC_out_top = pc_current;
    assign Instruction_out_top = instruction;
endmodule
