`define BUS_WIDTH 32
`define MEMSIZE 2048

module ram #(
    parameter BUS_WIDTH = `BUS_WIDTH,
    parameter MEMSIZE = `MEMSIZE
)(
    input [BUS_WIDTH-1:0] data_in,
    input [BUS_WIDTH-1:0] addr,
    input write, cs, clk,
    output reg [BUS_WIDTH-1:0] data_out
);

    reg [BUS_WIDTH-1:0] memory [MEMSIZE-1:0]; 

    always @(*) begin
        if (cs && !write)
            data_out = memory[addr];
        else
            data_out = {BUS_WIDTH{1'bz}};
    end

    always @(posedge clk) begin
        if (cs && write)
            memory[addr] <= data_in;
    end

endmodule
