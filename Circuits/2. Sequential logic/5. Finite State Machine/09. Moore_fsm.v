module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    parameter [1:0] ABOVES3 = 2'b00, BTWS32 = 2'b01, BTWS21 = 2'b10, BS1 = 2'b11; 
    reg [1:0] state, next_state;
    always@(*) begin
        case(state)
            ABOVES3: begin
                if(s == 3'b011) next_state = BTWS32;
                else next_state = ABOVES3;	//111
            end
            BTWS32: begin
                if(s == 3'b001) next_state = BTWS21;
                else if(s == 3'b111) next_state = ABOVES3;
                else next_state = BTWS32;	//011
            end
            BTWS21: begin
                if(s == 3'b000) next_state = BS1;
                else if(s == 3'b011) next_state = BTWS32;
                else next_state = BTWS21;	//001
            end
            BS1: begin
                if(s == 3'b001) next_state = BTWS21;
                else next_state = BS1;		//000
            end 
        endcase
    end
    
    always@(posedge clk) begin
        if(reset) begin
            state <= BS1;
            //prev_state <= BS1;
            dfr <= 1'b1;
        end
        else begin
            //prev_state <= state;
            state <= next_state;
            dfr <= (state < next_state)? 1'b1 : ((state > next_state)? 1'b0: dfr);
        end
    end
    
    assign fr1 = (state == BTWS32) | (state == BTWS21) | (state == BS1);
    assign fr2 = (state == BTWS21) | (state == BS1);
    assign fr3 = (state == BS1);
    //assign dfr = (prev_state <= state);
endmodule
