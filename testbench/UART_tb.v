`timescale 1ns/1ns
module UART_tb;
reg clk,rst;

reg wr_uart;
reg [7:0] w_data;
//wire tx_full;
//wire tx;
//reg rx;
reg rd_uart;
wire [7:0] r_data;
//wire rx_empty;
//reg [10:0] final_value;
//wire ready;
//instant dut
UART dut(clk,rst,wr_uart,w_data,rd_uart,r_data);

initial begin
clk=1'b0;
forever #5 clk=~clk;
end

task reset ;
begin
@(negedge clk)
rst=1'b0;
@(negedge clk)
rst=1'b1;
end
endtask

task write (input [7:0] i);
begin
@(negedge clk)
wr_uart=1'b1;
w_data=i;
end
endtask

task read ;
begin
@(negedge clk)
rd_uart=1'b1;
end
endtask

initial begin
    reset;
 //   final_value='d9600;
    write(8'd94);
    read ;
    #200000 $finish;
end

endmodule