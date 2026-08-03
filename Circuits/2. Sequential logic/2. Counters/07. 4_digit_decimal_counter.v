module deccount (
	input clk,
	input reset,
	input ena,
    output reg [3:0] q);
    
    int i;
    always@(posedge clk) begin
        if(reset) q <= 4'b0000;   
        else begin
        	if (ena) begin
            	if (q == 4'b1001) q <= 4'b0000;
                else q <= q + 4'b0001;
            end
            else q <= q;
        end   
    end
endmodule

module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
    
    deccount counter0 (clk, reset, 1'b1, q[3:0]);
    deccount counter1 (clk, reset, ena[1], q[7:4]);
    deccount counter2 (clk, reset, ena[2], q[11:8]);
    deccount counter3 (clk, reset, ena[3], q[15:12]);
	assign ena[1] = (q[3:0] == 4'b1001)?1'b1:1'b0;
    assign ena[2] = (q[7:0] == 8'b10011001)?1'b1:1'b0;
    assign ena[3] = (q[11:0] == 12'b100110011001)?1'b1:1'b0;
endmodule

