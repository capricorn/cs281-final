module codec(wa, rap, raq, ld, wr, p, q, op, done, rst, clk);
    // DEFINE the new inputs
    input op, rst, clk, wr;
    output done;
    reg i = 0;
    reg step = 0;

    reg [7:0] a, b, out;
    reg [2:0] op;

    alu codec_alu(.a(a), .b(b), .op(op), .f(out). clk(clk));
 
    parameter OP_ENCODE = 0;
    parameter OP_DECODE = 1;

    parameter REG_K0 = 0;
    parameter REG_K1 = 1;
    parameter REG_K2 = 2;
    parameter REG_K3 = 3;
    parameter REG_V0 = 4;
    parameter REG_V1 = 5;
    parameter REG_SUM  = 6;
    parameter REG_TMP0 = 7;
    parameter REG_TMP1 = 8;
    parameter REG_TMP2 = 9;

    parameter OP_XOR   = 0;
    parameter OP_ADD   = 1;
    parameter OP_SUB   = 2;
    parameter OP_LSHFT = 3;
    parameter OP_RSHFT = 4;
 
    always @(posedge clk)
        begin
            case (op)
                OP_ENCODE: begin
                    if (i <= 31) begin
                        case (step)
                            0: begin
                                // sum += 0xb7
                                wr <= 1;
                                wa <= REG_SUM;
                                // It's possible another clock cycle is
                                // required for f to be updated properly
                                a <= 2'hb7;
                                b <= 0;
                                op <= OP_ADD;
                                ld <= f;
                            end
                            1: begin
                                // Read v1 into p
                                wr <= 0;
                                rap <= REG_V1;
                            end
                            2: begin
                                // tmp0 = v1 << 4
                                wr <= 1;
                                wa <= REG_TMP0;
                                a <= p;
                                b <= 4;
                                op <= OP_LSHFT;
                                ld <= f;
                            end
                            3: begin
                                // Read tmp0 into p, k0 into q
                                wr <= 0;
                                rap <= REG_TMP0;
                                raq <= REG_K0;
                            end
                            4: begin
                                // tmp1 = tmp0 + k0
                                wr <= 1;
                                wa <= REG_TMP1;
                                a <= rap;
                                b <= raq;
                                op <= OP_ADD;
                                ld <= f;
                            end
                            5: begin
                                // Read v1 into p, sum into q  
                                wr <= 0;
                                rap <= REG_V1;
                                raq <= REG_SUM;
                            end
                            6: begin
                                // tmp0 = v1 + sum
                                wr <= 1;
                                wa <= REG_TMP0;
                                a <= rap;
                                b <= raq;
                                op <= OP_ADD;
                                ld <= f;
                            end
                            7: begin
                                // Read tmp1 into p, tmp0 into q
                                wr <= 0;
                                rap <= REG_TMP1;
                                raq <= REG_TMP0;
                            end
                            8: begin
                                // tmp2 = tmp1 ^ tmp0;
                                wr <= 1;
                                wa <= REG_TMP0;
                                a <= rap;
                                b <= raq;
                                op <= OP_XOR;
                                ld <= f;
                            end
                            9: begin
                                // Read v1 into p
                                wr <= 0;
                                rap <= REG_V1;
                            end
                            10: begin
                                // tmp0 = v1 >> 5
                                wr <= 1;
                                wa <= REG_TMP0;
                                a <= rap;
                                b <= 5;
                                op <= OP_RSHFT;
                                ld <= f;
                            end
                            11: begin
                                // Read tmp0 into p, k1 into q
                                wr <= 0;
                                rap <= REG_TMP0;
                                raq <= REG_K1;
                            end
                            12: begin
                                // tmp1 = tmp0 + k1
                                wr <= 1;
                                wa <= REG_TMP1;
                                a <= rap;
                                b <= raq;
                                op <= OP_ADD;
                                ld <= f;
                            end
                            13: begin
                                // Read tmp2 into p, tmp1 into q
                                wr <= 0;
                                rap <= REG_TMP2;
                                raq <= REG_TMP1;
                            end
                            14: begin
                                // tmp0 = tmp2 ^ tmp1
                                wr <= 1;
                                wa <= REG_TMP0;
                                a <= rap;
                                b <= raq;
                                op <= OP_XOR;
                                ld <= f;
                            end
                            15: begin
                                // Read v0 into p, tmp0 into q
                                wr <= 0;
                                rap <= REG_V0;
                                raq <= REG_TMP0;
                            end
                            16: begin
                                // tmp1 = v0 + t0
                                wr <= 1;
                                wa <= REG_TMP1;
                                a <= rap;
                                b <= raq;
                                op <= OP_ADD;
                                ld <= f;
                            end
                            17: begin
                                // Read tmp1 into p
                                wr <= 0;
                                rap <= REG_TMP1;
                            end
                            18: begin
                                // v0 = tmp1
                                wr <= 1;
                                wa <= REG_TMP1;
                                ld <= REG_V0;
                            end
                            19: begin
                                // sum += 0xb7
                                wr <= 1;
                                wa <= REG_SUM;
                                // It's possible another clock cycle is
                                // required for f to be updated properly
                                a <= 2'hb7;
                                b <= 0;
                                op <= OP_ADD;
                                ld <= f;
                            end
                            20: begin
                                // Read v1 into p
                                wr <= 0;
                                rap <= REG_V1;
                            end
                            21: begin
                                // tmp0 = v1 << 4
                                wr <= 1;
                                wa <= REG_TMP0;
                                a <= p;
                                b <= 4;
                                op <= OP_LSHFT;
                                ld <= f;
                            end
                            22: begin
                                // Read tmp0 into p, k0 into q
                                wr <= 0;
                                rap <= REG_TMP0;
                                raq <= REG_K0;
                            end
                            23: begin
                                // tmp1 = tmp0 + k0
                                wr <= 1;
                                wa <= REG_TMP1;
                                a <= rap;
                                b <= raq;
                                op <= OP_ADD;
                                ld <= f;
                            end
                            24: begin
                                // Read v1 into p, sum into q  
                                wr <= 0;
                                rap <= REG_V1;
                                raq <= REG_SUM;
                            end
                            25: begin
                                // tmp0 = v1 + sum
                                wr <= 1;
                                wa <= REG_TMP0;
                                a <= rap;
                                b <= raq;
                                op <= OP_ADD;
                                ld <= f;
                            end
                            26: begin
                                // Read tmp1 into p, tmp0 into q
                                wr <= 0;
                                rap <= REG_TMP1;
                                raq <= REG_TMP0;
                            end
                            27: begin
                                // tmp2 = tmp1 ^ tmp0;
                                wr <= 1;
                                wa <= REG_TMP0;
                                a <= rap;
                                b <= raq;
                                op <= OP_XOR;
                                ld <= f;
                            end
                            28: begin
                                // Read v1 into p
                                wr <= 0;
                                rap <= REG_V1;
                            end
                            29: begin
                                // tmp0 = v1 >> 5
                                wr <= 1;
                                wa <= REG_TMP0;
                                a <= rap;
                                b <= 5;
                                op <= OP_RSHFT;
                                ld <= f;
                            end
                            30: begin
                                // Read tmp0 into p, k1 into q
                                wr <= 0;
                                rap <= REG_TMP0;
                                raq <= REG_K1;
                            end
                            31: begin
                                // tmp1 = tmp0 + k1
                                wr <= 1;
                                wa <= REG_TMP1;
                                a <= rap;
                                b <= raq;
                                op <= OP_ADD;
                                ld <= f;
                            end
                            32: begin
                                // Read tmp2 into p, tmp1 into q
                                wr <= 0;
                                rap <= REG_TMP2;
                                raq <= REG_TMP1;
                            end
                            33: begin
                                // tmp0 = tmp2 ^ tmp1
                                wr <= 1;
                                wa <= REG_TMP0;
                                a <= rap;
                                b <= raq;
                                op <= OP_XOR;
                                ld <= f;
                            end
                            34: begin
                                // Read v0 into p, tmp0 into q
                                wr <= 0;
                                rap <= REG_V0;
                                raq <= REG_TMP0;
                            end
                            35: begin
                                // tmp1 = v0 + t0
                                wr <= 1;
                                wa <= REG_TMP1;
                                a <= rap;
                                b <= raq;
                                op <= OP_ADD;
                                ld <= f;
                            end
                            36: begin
                                // Read tmp1 into p
                                wr <= 0;
                                rap <= REG_TMP1;
                            end
                            37: begin
                                // v0 = tmp1
                                wr <= 1;
                                wa <= REG_TMP1;
                                ld <= REG_V0;
                            end
                        endcase
                        if (step == 37) begin
                            step <= 0;
                            i <= i + 1;
                        end
                        else 
                            step <= step + 1;
                    end
                end
                OP_DECODE: begin
                    if (i <= 31) begin
                    end
                end
            endcase
        end
 
    assign done = i & 31;
endmodule
