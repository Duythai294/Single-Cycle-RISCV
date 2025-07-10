module RegisterFile (
    input clk,
    input rst_n,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input reg_write,
    output [31:0] reg_out1,
    output [31:0] reg_out2
);
    reg [31:0] registers [0:31];
    integer i;

    always @(negedge rst_n) begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'd0;
    end

    always @(posedge clk) begin
        if (reg_write && rd != 5'b00000)
            registers[rd] <= write_data;
    end

    assign reg_out1 = (rs1 == 5'b00000) ? 32'd0 : registers[rs1];
    assign reg_out2 = (rs2 == 5'b00000) ? 32'd0 : registers[rs2];
endmodule

