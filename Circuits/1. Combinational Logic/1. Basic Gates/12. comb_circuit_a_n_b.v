module module_a (input x, input y, output z);
    assign  z = (x^y) & x;
endmodule

module module_b ( input x, input y, output z );
	//00 1	10 0	01 0	11 1
    assign z = (~x & ~y) | (x & y);
endmodule

module top_module (input x, input y, output z);
    wire z_tmp[3:0];
    wire z_tmp1[1:0];

        
        module_a A1 (x ,y ,z_tmp[0] );
        module_b B1 (x ,y ,z_tmp[1] );
        module_a A2 (x ,y ,z_tmp[2] );
        module_b B2 (x ,y ,z_tmp[3] );
    assign z_tmp1[0] = z_tmp[1] | z_tmp[0];
    assign z_tmp1[1] = z_tmp[3] & z_tmp[2];
    assign z = z_tmp1[1] ^ z_tmp1[0];
    
endmodule
