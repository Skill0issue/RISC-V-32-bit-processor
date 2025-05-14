module reg_bank (
    input [31:0] write_data,
    input [4:0] source_1, source_2, des_reg,
    input clk, write, reset,
    output [31:0] read_data1, read_data2
);

    reg [31:0] reg_file [0:31]; // 32 registers

    assign read_data1 = reg_file[source_1];
    assign read_data2 = reg_file[source_2];

    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                reg_file[i] <= 32'd0;
            end
        end else if (write) begin
            reg_file[des_reg] <= write_data;
        end
    end

endmodule
