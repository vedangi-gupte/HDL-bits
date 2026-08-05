`timescale 1ns / 1ps
module deccounter (
	input clk,
	input reset,
    input ena,
  	input clear,
    output [3:0] dec_out
);
  reg [3:0] dec_out_reg;
  always@(posedge clk) begin
    if(reset) dec_out_reg <= 4'd0;
    else begin 
      if(ena) begin 
        if(clear) dec_out_reg <= 4'd0;
        else if(dec_out_reg == 4'd9) dec_out_reg <= 4'd0;
        else dec_out_reg <= dec_out_reg + 4'd1;
      end
      else dec_out_reg <= dec_out_reg;
       
    end
  end
  assign dec_out = dec_out_reg;
endmodule

module twodigitbcd (
	input clk,
    input reset,
    input ena,
    input [7:0] limit,
    input toggle,
    output [7:0] bcd_out
);
    reg ena_1, clear;
    deccounter counter0 (clk, reset, ena, clear, bcd_out [3:0]);
    deccounter counter1 (clk, reset, ena_1, clear, bcd_out [7:4]);
    
    always@(*) begin
      if({bcd_out[7:4], bcd_out[3:0]} == limit) begin 
        	clear = 1'b1;
      end
      else clear = 1'b0;
      //ena_1 = (bcd_out [3:0] == 4'd9)? 1'b1 : 1'b0;
      ena_1 = (toggle)? 1'b1: 1'b0;
    end
endmodule

module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
	
    wire [1:0] ena_2;
    wire [7:0] hh_wire;
    wire [2:0] toggle;
  reg pm_reg;
  twodigitbcd counter0 (clk, reset, ena, {4'd5,4'd9}, toggle[0], ss);
  twodigitbcd counter1 (clk, reset, ena_2[0], {4'd5,4'd9}, toggle[1], mm);
  twodigitbcd counter2 (clk, reset, ena_2[1], {4'd1,4'd1}, toggle[2], hh_wire);
  
  assign ena_2[0] = (ss == {4'd5, 4'd9})? 1'b1 : 1'b0;
  assign ena_2[1] = ({mm,ss} == {4'd5, 4'd9, 4'd5, 4'd9})? 1'b1 : 1'b0;
  assign hh = (hh_wire == {4'd0,4'd0})? {4'd1,4'd2}: hh_wire;
  assign toggle[0] = ((ss[3:0] == 4'd9)&&(ena))? 1'b1 : 1'b0;
  assign toggle[1] = ((ss == {4'd5, 4'd9})&&(mm[3:0] == 4'd9)&&(ena))? 1'b1 : 1'b0;
  assign toggle[2] = (((ss == {4'd5, 4'd9})&&(mm == {4'd5, 4'd9})&&(hh[3:0] == 4'd9)&&(ena))||((ss == {4'd5, 4'd9})&&(mm == {4'd5, 4'd9})&&(hh == {4'd1, 4'd1})&&(ena)))? 1'b1 : 1'b0;
  
  always @(posedge clk) begin
    if (reset)
        pm_reg <= 1'b0;
    else if ({hh_wire,mm,ss} == {4'd1, 4'd1, 4'd5, 4'd9, 4'd5, 4'd9})
        pm_reg <= ~pm_reg;   // Toggle state if T is high
    else
        pm_reg <= pm_reg;    // Hold state if T is low
  end
	assign pm = pm_reg;
endmodule
