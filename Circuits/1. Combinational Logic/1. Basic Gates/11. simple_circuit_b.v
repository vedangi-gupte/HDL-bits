module top_module ( input x, input y, output z );
	//00 1	10 0	01 0	11 1
    assign z = (~x & ~y) | (x & y);
endmodule
