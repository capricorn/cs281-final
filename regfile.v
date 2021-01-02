module regfile(wa, rap, raq, ld, wr, p, q, clk);
    input [3:0] wa, rap, raq;
    input wr, clk;
    output [7:0] p, q;
 
    reg [7:0] registers[10];
 
    always @(posedge clk)
        begin
            if (wa < 10)
                begin
                    if (wr == 1)
                        registers[wa] <= ld;
                    else
                        begin
                            p <= registers[rap];
                            q <= registers[raq];
                        end
                end
        end
endmodule
