/**
* FSM - outputs current state.
    * clk - clock
    * ld_select - select whether to load values or keys
    * codec - select to encrypt / decrypt
    * next - push button input
    * state - output: current state
*/
module fsm(clk, load, codec, next, data, state);
    input clk, load, codec, next;
    input reg [7..0] data;
    output reg [3..0] state = 0; // Not sure if this is allowed.
                                  // Or if it's in the right place.

    // Maybe prefix with STATE
    parameter LOAD_K0   = 4'b0000;
    parameter LOAD_K1   = 4'b0001;
    parameter LOAD_K2   = 4'b0010;
    parameter LOAD_K3   = 4'b0011;
    parameter LOAD_V0   = 4'b0100;
    parameter LOAD_V1   = 4'b0101;
    parameter DO_CRYPTO = 4'b0110;
    parameter SHOW_V0   = 4'b0111;
    parameter SHOW_V1   = 4'b1000;

    parameter LOAD_KEY = 1;
    parameter LOAD_VALUE = 0;

    reg [4:0] tmp_wa, tmp_rap, tmp_raq;
    reg [7:0] tmp_ld, p_out, q_out;
    reg tmp_wr, codec_done, codec_rst, codec_op;  // init to 0?

    regfile registers(.wa(tmp_wa), .rap(tmp_rap), .raq(tmp_raq), .ld(data), 
        .wr(tmp_wr), .p(p_out), .q(q_out), .clk(clk));
    codec tea_codec(.wa(tmp_wa), .rap(tmp_rap), .raq(tmp_raq), .ld(data), .wr(tmp_wr),
        .p(p_out), .q(q_out), .op(codec_op), .done(codec_done), .rst(codec_rst), .clk(clk));

    begin
        always @(posedge clk)
            // Not sure if this needs to be in a block or not.
            // I think it's considered a block.
            case (state)
                case LOAD_K0: begin
                    tmp_wr <= 0;
                    if (load == LOAD_KEY && next == 1) begin
                        state <= LOAD_K1;
                        tmp_wr <= 1;
                        tmp_wa <= LOAD_K1;
                    end
                    else if (load == LOAD_VALUE)
                        state <= LOAD_V0;
                end
                case LOAD_K1: begin
                    tmp_wr <= 0;
                    if (load == LOAD_KEY && next == 1) begin
                        state <= LOAD_K2;
                        tmp_wr <= 1;
                        tmp_wa <= LOAD_K2;
                    end
                    else if (load == LOAD_VALUE)
                        state <= LOAD_V0;
                end
                case LOAD_K2: begin
                    tmp_wr <= 0;
                    if (load == LOAD_KEY && next == 1) begin
                        state <= LOAD_K3;
                        tmp_wr <= 1;
                        tmp_wa <= LOAD_K3;
                    end
                    else if (load == LOAD_VALUE)
                        state <= LOAD_V0;
                end
                case LOAD_K3: begin
                    tmp_wr <= 0;
                    if (load == LOAD_KEY && next == 1) begin
                        state <= LOAD_V0;
                        tmp_wr <= 1;
                        tmp_wa <= LOAD_K2;
                    end
                    else if (load == LOAD_VALUE)
                        state <= LOAD_V0;
                end
                case LOAD_V0: begin
                    tmp_wr <= 0;
                    if (load == LOAD_VALUE && next == 1) begin
                        state <= LOAD_V1;
                        tmp_wr <= 1;
                        tmp_wa <= LOAD_V1;
                    end
                    else if (load == LOAD_KEY)
                        state <= LOAD_K0;
                end
                case LOAD_V1: begin
                    tmp_wr <= 0;
                    if (load == LOAD_VALUE && next == 1) begin
                        state <= DO_CRYPTO;
                        tmp_wr <= 1;
                        tmp_wa <= LOAD_V1;
                    end
                    else if (load == LOAD_KEY)
                        state <= LOAD_K0;
                end
                case DO_CRYPTO: begin
                    if (codec_done == 1)
                        state <= SHOW_V0;
                end
                case SHOW_V0: begin
                end
                case SHOW_V1: begin
                end
                // How should this be handled?
                default: begin
                end
            endcase
endmodule
