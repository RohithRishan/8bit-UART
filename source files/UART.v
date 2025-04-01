`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2023 06:34:56 PM
// Design Name: 
// Module Name: UART
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


module UART 
    #(parameter DBIT=8, SB_Tick=16)(
    input clk,rst,
    
    //transmitter ports
    input wr_uart,
    input [DBIT-1:0] w_data,
    //output tx_full,
    //output tx,
    
    //receiver ports
    //input rx,
    input rd_uart,
    output [DBIT-1:0] r_data
   // output rx_empty,
   // output ready,
    //baud input
  //  input [10:0] baud_final_value
    );
    reg delay;
    wire tx;
    assign ready=rx_empty & delay;
    
    always @(posedge clk or posedge rst)begin
    if(rst)
        delay<=0;
    else
        delay<=!rx_empty;
    end
    //baud rate generator instant
    wire tick;
    Baud_rate_generator #(.BITS(11))timer(clk,rst,1'b1,11'd9600,tick);
    
    //Receiver
    wire [DBIT-1:0] rx_dout;
    wire rx_done_tick;
    uart_rx #(DBIT, SB_Tick) receiver(clk,rst,tx,tick,rx_dout,rx_done_tick);
    seq_mem fifo_rx (clk,rst,rx_done_tick,rd_uart,rx_dout,r_data,rx_empty);
   
    
    //transmitter
    wire tx_fifo_empty,tx_done_tick;
    wire [DBIT-1:0] tx_din;
    uart_tx #(DBIT, SB_Tick) transmitter(clk,rst,tick,~tx_fifo_empty,tx_din,tx_done_tick,tx);
    seq_mem fifo_tx (clk,rst,wr_uart,tx_done_tick,w_data,tx_din,tx_fifo_empty,tx_full);
    
endmodule