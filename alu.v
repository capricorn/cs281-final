module alu(a, b, op, f, clk);
    input [7:0] a, b;
    input [2:0] op;
    input clk;
    output reg [7:0] f;
 
    parameter OP_XOR   = 0;
    parameter OP_ADD   = 1;
    parameter OP_SUB   = 2;
    parameter OP_LSHFT = 3;
    parameter OP_RSHFT = 4;
 
    always @(posedge clk)
        begin
            case (op)
                OP_XOR: f <= a ^ b;
                OP_ADD: f <= a + b;
                OP_SUB: f <= a - b;
                OP_LSHFT: f <= a << b;
                OP_RSHFT: f <= a >> b;
            endcase
        end
endmodule
