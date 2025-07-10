module PC (
    input clk,
    input rst_n,
    input [31:0] pc_next,
    input pc_write,
    output reg [31:0] pc_current
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc_current <= 32'd0;
        else if (pc_write)
            pc_current <= pc_next;
    end
endmodule
