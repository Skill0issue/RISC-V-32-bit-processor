module program_counter (
    input clk,
    input reset,
    input [31:0] pc_in,
    input enable,
    output reg [31:0] pc_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc_out <= 32'b0;
    else if (enable)
        pc_out <= pc_in;
end

endmodule
