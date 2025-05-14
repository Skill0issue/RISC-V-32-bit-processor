module register (
    input clk,
    input [31:0] in,
    input reset,
    input enable,
    output reg [31:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        out <= 32'b0;
    else if (enable)
        out <= in;
end

endmodule // register
