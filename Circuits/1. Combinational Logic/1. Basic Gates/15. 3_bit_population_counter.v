module top_module( 
    input [2:0] in,
    output [1:0] out );
	
    int i;
    reg [1:0] out_temp;
    
    always@(*) begin
        out_temp = 2'b00;
        for (i=0; i<3; i++) begin
            out_temp = out_temp +in[i];
        end      
    end
    assign out = out_temp;
endmodule
