`timescale 1ns/1ps
module testbench;
reg clk=0,reset,enable;
wire red,yellow,green;
wire [1:0]state_out;
parameter [1:0] off= 2'b00,
                red_state= 2'b01,
                yellow_state= 2'b10,
                green_state = 2'b11;

traffic_light_controller FSM(clk,reset,enable,red,yellow,green,state_out);
initial
begin
forever #1 clk= ~clk;
end
initial
begin
$monitor($time ,"clk=%b,reset=%b,enable=%b,red=%b,yellow=%b,green=%b,state_out=%b",clk,reset,enable,red,yellow,green,state_out);
reset = 0;
#2.5 reset = 1; enable =0;
repeat(10)
@(posedge clk);
enable = 1;

repeat(2)
begin
wait (state_out==green_state);
@(state_out);
end

wait (state_out==yellow_state);
@ (posedge clk);
enable = 0;

repeat (10)
@(posedge clk);
@(posedge clk);
enable = 1;
#40 $finish;
end
endmodule

