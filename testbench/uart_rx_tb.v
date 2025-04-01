`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2023 11:22:04 AM
// Design Name: 
// Module Name: uart_rx_tb
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


module uart_rx_tb ;
reg clk,rst,rx,stick;
wire [7:0] rx_dout;
wire done;
integer i;

uart_rx dut(clk,rst,rx,stick,rx_dout,done);

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
    {rx,stick}=1;
    reset;
    for(i=0;i<8;i=i+1) begin
        @(negedge clk)
        rx=0;
    end
    repeat (2) begin
    for(i=0;i<16;i=i+1) begin
        @(negedge clk)
        rx=1;
        end    
    end    
    repeat (3) begin
    for(i=0;i<16;i=i+1) begin
        @(negedge clk)
        rx=0;
        end    
    end    
    repeat (1) begin
    for(i=0;i<16;i=i+1) begin
        @(negedge clk)
        rx=1;
        end    
    end    
    repeat (1) begin
    for(i=0;i<16;i=i+1) begin
        @(negedge clk)
        rx=0;
        end    
    end    
    repeat (1) begin
    for(i=0;i<40;i=i+1) begin
        @(negedge clk)
        rx=1;
        end    
    end    
end

endmodule
