`timescale 1ns / 1ps
module traffic_light_controller(clk,reset,enable,red,yellow,green,state_out);
input clk,reset,enable;
output reg red,yellow,green;
output [1:0]state_out;
parameter [1:0] off= 2'b00,
                red_state= 2'b01,
                yellow_state= 2'b10,
                green_state = 2'b11;
reg [1:0]ps;
reg [1:0]ns;
reg [5:0] timer;
reg timer_clear;

always @ (*)
begin
ns = off;
red=0;
yellow=0;
green=0;
timer_clear=0;
if(!enable)
ns = off;
else
begin
case (ps)
 off: begin
 if(enable)
 ns= red_state;
 else
 ns= off;
 end
 red_state: begin
 red = 1;
  if(timer==6'd50)
  begin
  ns= yellow_state;
  timer_clear=1;
  end
  else
  ns= red_state;
 end
 yellow_state:begin
 yellow = 1;
  if(timer==6'd10)
  begin
  ns=green_state;
  timer_clear=1;
  end
  else
  ns =yellow_state;
 end
 green_state:begin
 green=1;
  if(timer==6'd30)
  begin
  ns= red_state;
  timer_clear=1;
  end
  else
  ns= green_state;
 end
default: ns= off;
endcase
end
end

always @(posedge clk or negedge reset)
begin
if(!reset)
ps<= off;
else
ps<=ns;
end
assign state_out = ps;
always @ (posedge clk or negedge reset)
begin
if(!reset)
timer<=0;
else if ((timer_clear==1)||(enable==0))
timer<=0;
else if (ps!=off)
timer <=timer+1;
end
endmodule

  
  




