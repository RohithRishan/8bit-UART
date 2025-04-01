`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2023 12:04:24 PM
// Design Name: 
// Module Name: uart_tx_tb
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


module uart_tx_tb ;

reg clk,rst,stick,tx_start;
reg [7:0] tx_din;
wire done;
wire tx;
integer i;

uart_tx dut(clk,rst,stick,tx_start,tx_din,done,tx);

initial begin
clk=1'b0;
forever #5 clk=~clk;
end

task reset ;
begin
@(negedge clk)
rst=1'b1;
@(negedge clk)
rst=1'b0;
end
endtask

initial begin
    rst=0;
    {stick,tx_start}=2'b11;
    reset;
    tx_din=8'b111000101;
end

endmodule
