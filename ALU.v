module ALU #(
    parameter BUS_WIDTH = 32
)(
    input signed [BUS_WIDTH-1:0] A,
    input signed [BUS_WIDTH-1:0] B,
    input CARRY_IN,
    input [4:0] ALU_OP, 
    output reg signed [BUS_WIDTH-1:0] ALU_RES,
    output reg CARRY_OUT,
    output reg BORROW,
    output ZERO,
    output PARITY,
    output reg INVALID_OP
);

    reg signed [BUS_WIDTH:0] temp;
// local opcodes

// 15 operator ALU 
//     - 0 addition = A+B
//     - 1 addition in increment = A + B + carry
//     - 2 subraction A - B
//     - 3 increment A
//     - 4 decrement A
//     - 5 multipication
//     - 6 division
//     - 7 << logical left shift
//     - 8 >> logical right shift
//     - 9 rotate left
//     - 10 rotate right
//     - 11 and
//     - 12 or
//     - 13 xor
//     - 14 nor
//     - 15 nand
//     - 16 xnor
//     - 17 > comparision
//     - 18 < comparision
//     - 19 = comparision
//     - default error

/*  // TODO: set flags for GT,LT,EQ instead of alu_res
/   // make the bus 32 bit wide and use encoding for flags and registers
*/


localparam OP_ADD = 0;
localparam OP_ADD_CARRY = 1;
localparam OP_SUB = 2;
localparam OP_INC = 3;
localparam OP_DEC = 4;
localparam OP_MUL = 5;
localparam OP_DIV = 6;
localparam OP_LS = 7;
localparam OP_RS = 8;
localparam OP_LR = 9;
localparam OP_RR = 10;
localparam OP_AND = 11;
localparam OP_OR = 12;
localparam OP_XOR = 13;
localparam OP_NOR = 14;
localparam OP_NAND = 15;
localparam OP_XNOR = 16;
localparam OP_GT = 17;
localparam OP_LT = 18;
localparam OP_EQ = 19;

always @(*) begin
        ALU_RES = 0;
        CARRY_OUT = 0;
        BORROW = 0;
        INVALID_OP = 0;

        case (ALU_OP)
            OP_ADD: begin
                temp = A + B;
                ALU_RES = temp[BUS_WIDTH-1:0];
                CARRY_OUT = temp[BUS_WIDTH];
            end
            OP_ADD_CARRY: begin
                temp = A + B + CARRY_IN;
                ALU_RES = temp[BUS_WIDTH-1:0];
                CARRY_OUT = temp[BUS_WIDTH];
            end
            OP_SUB: begin
                ALU_RES = A - B;
                BORROW = (A < B);
            end
            OP_INC: begin
                temp = A + 1;
                ALU_RES = temp[BUS_WIDTH-1:0];
                CARRY_OUT = temp[BUS_WIDTH];
            end
            OP_DEC: begin
                ALU_RES = A - 1;
                BORROW = (A == -((1 << (BUS_WIDTH - 1)))); // underflow detection
            end
            OP_MUL: begin
                ALU_RES = A * B; // truncates to BUS_WIDTH bits
            end
            OP_DIV: begin
                if (B == 0) begin
                    INVALID_OP = 1;
                    ALU_RES = 'bx;
                end else begin
                    ALU_RES = A / B;
                end
            end
            OP_LS:        ALU_RES = A <<< 1; // arithmetic shift
            OP_RS:        ALU_RES = A >>> 1; // arithmetic right shift
            OP_LR:        ALU_RES = {A[BUS_WIDTH-2:0], A[BUS_WIDTH-1]};
            OP_RR:        ALU_RES = {A[0], A[BUS_WIDTH-1:1]};
            OP_AND:       ALU_RES = A & B;
            OP_OR:        ALU_RES = A | B;
            OP_XOR:       ALU_RES = A ^ B;
            OP_NOR:       ALU_RES = ~(A | B);
            OP_NAND:      ALU_RES = ~(A & B);
            OP_XNOR:      ALU_RES = ~(A ^ B);
            OP_GT:        ALU_RES = (A > B);
            OP_LT:        ALU_RES = (A < B);
            OP_EQ:        ALU_RES = (A == B);

            default: begin
                INVALID_OP = 1;
                ALU_RES = 0;
                CARRY_OUT = 0;
                BORROW = 0;
            end
        endcase
    end

// Even parity
assign PARITY = ~^ALU_RES;

// Zero flag
assign ZERO = (ALU_RES == 0);

endmodule
