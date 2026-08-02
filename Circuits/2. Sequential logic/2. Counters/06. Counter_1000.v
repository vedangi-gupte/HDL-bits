module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //
    reg [11:0] Q;
    bcdcount counter0 (clk, reset, c_enable[0], Q [3:0]);
    bcdcount counter1 (clk, reset, c_enable[1], Q[7:4]);
    bcdcount counter2 (clk, reset, c_enable[2], Q[11:8]);
    assign c_enable = {((Q[7:0] == 8'b10011001)?1'b1:1'b0), ((Q[3:0] == 4'b1001)?1'b1:1'b0), (1'b1)};
    assign OneHertz = (Q == 12'b100110011001)?1'b1:1'b0;
endmodule
