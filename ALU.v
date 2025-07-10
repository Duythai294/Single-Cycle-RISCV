// ALU.v
module ALU (
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] alu_op,
    output reg [31:0] alu_result,
    output reg zero
);
    always @(*) begin
        case (alu_op)
            4'b0000: alu_result = in1 + in2; // ADD
            4'b0001: alu_result = in1 - in2; // SUB
            4'b0010: alu_result = in1 & in2; // AND
            4'b0011: alu_result = in1 | in2; // OR
            4'b0100: alu_result = in1 ^ in2; // XOR
            4'b0101: alu_result = in1 << in2[4:0]; // SLL
            4'b0110: alu_result = in1 >> in2[4:0]; // SRL
            4'b0111: alu_result = $signed(in1) >>> in2[4:0]; // SRA
            4'b1000: alu_result = ($signed(in1) < $signed(in2)) ? 32'h1 : 32'h0; // SLT
            4'b1001: alu_result = (in1 < in2) ? 32'h1 : 32'h0; // SLTU
            default: alu_result = 32'd0;
        endcase
        zero = (alu_result == 32'd0);
    end
endmodule
