`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/21/2023 02:06:32 PM
// Design Name: 
// Module Name: fifo_generator_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_generator_tb();
reg clk,srst,wr_en,rd_en;
reg [7:0] din;
wire [7:0] dout;
wire full,empty;

fifo_generator_0 dut (
  .clk(clk),      // input wire clk
  .srst(srst),    // input wire srst
  .din(din),      // input wire [7 : 0] din
  .wr_en(wr_en),  // input wire wr_en
  .rd_en(rd_en),  // input wire rd_en
  .dout(dout),    // output wire [7 : 0] dout
  .full(full),    // output wire full
  .empty(empty)  // output wire empty
);
integer i;
initial begin
clk=1'b0;
forever #5 clk=~clk;
end

task reset;
begin
@(negedge clk)
srst=1'b1;
@(negedge clk)
srst=1'b0;
end
endtask

initial begin
{srst,din,wr_en,rd_en}=0;
reset;
{wr_en,rd_en}=2'b11;
for(i=0;i<16;i=i+1)begin
    @(negedge clk)
    din=$random%256;
end
{wr_en,rd_en}=2'b00;
end
endmodule
