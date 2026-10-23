module top_module (
    input too_cold,
    input too_hot,
    input mode,
    input fan_on,
    output heater,
    output aircon,
    output fan
); 
    assign heater = mode ? (too_cold ? 1'b1:1'b0 ): (1'b0);
  assign aircon = mode ? (1'b0): (too_hot? 1'b1:1'b0);        // if u don't use 1'b1 and use just 1, you'll get a warning as that 1 would be considered 32 bits long in verilog.
    assign fan = heater | aircon | fan_on ; 
endmodule
