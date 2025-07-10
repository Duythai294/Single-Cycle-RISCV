module DMEM (
    input clk,
    input [31:0] addr,
    input [31:0] mem_write_data,
    input mem_write,
    input mem_read,
    output reg [31:0] mem_read_data
);
    reg [31:0] memory [0:255]; 

    always @(posedge clk) begin
        if (mem_write)
            memory[addr[31:2]] <= mem_write_data;
    end

    always @(*) begin
        if (mem_read)
            mem_read_data = memory[addr[31:2]];
        else
            mem_read_data = 32'd0;
    end
endmodule
