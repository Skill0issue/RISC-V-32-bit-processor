module instruction_memory (
    input [31:0] address,
    output [31:0] instruction
);

    reg [31:0] mem [0:1023];

    initial begin
        // Replace with actual program or use $readmemh
        $readmemh("test/program4.mem", mem);
    end

    assign instruction = mem[address[11:2]]; // word-aligned

endmodule
