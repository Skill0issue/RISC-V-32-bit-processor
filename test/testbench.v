`timescale 1ns / 1ps
`include "cpu.v"

module testbench;

    reg clk;
    reg reset;

    // Declare the signals for the CPU module
    wire [31:0] pc;
    wire [31:0] regs[31:0];      // 32 registers
    wire [31:0] memory_data[2047:0];  // 1024 memory locations (8KB of memory)

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .regs(regs),
        .memory_data(memory_data)    // Expose memory to testbench
    );

    // Clock generation: 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz clock
    end

    // Simulation control
    initial begin
        $dumpfile("cpu.vcd");        // for GTKWave or waveform viewer
        $dumpvars(0, testbench);     // dump all variables

        // Monitor the CPU's internal state during the simulation
        $monitor("Time: %t, PC: %h, Reg0: %h, Reg1: %h, Reg2: %h, Reg3: %h, Mem[0]: %h, Mem[1]: %h, Mem[2]: %h",
                 $time, pc, regs[0], regs[1], regs[2], regs[3], memory_data[0], memory_data[1], memory_data[2]);

        // Initialize the reset signal
        reset = 1;
        #20;     // Reset for 20ns
        reset = 0;

        // Run the simulation for a period of time
        #500;    // Run for 500ns

        $finish; // End simulation
    end

endmodule
