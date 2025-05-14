module alu_control (
    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [4:0] alu_control
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 5'd0; // load/store -> ADD
            2'b01: alu_control = 5'd2; // branch -> SUB
            2'b10: begin // R-type
                case ({funct7, funct3})
                    10'b0000000000: alu_control = 5'd0;  // ADD
                    10'b0100000000: alu_control = 5'd2;  // SUB
                    10'b0000000111: alu_control = 5'd11; // AND
                    10'b0000000110: alu_control = 5'd12; // OR
                    10'b0000000100: alu_control = 5'd13; // XOR
                    10'b0000000001: alu_control = 5'd7;  // SLL
                    10'b0000000101: alu_control = 5'd8;  // SRL
                    default: alu_control = 5'd19;
                endcase
            end
            2'b11: begin // I-type
                case (funct3)
                    3'b000: alu_control = 5'd0;  // ADDI
                    3'b111: alu_control = 5'd11; // ANDI
                    3'b110: alu_control = 5'd12; // ORI
                    3'b100: alu_control = 5'd13; // XORI
                    default: alu_control = 5'd19;
                endcase
            end
            default: alu_control = 5'd19;
        endcase
    end

endmodule
