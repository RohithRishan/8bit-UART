module seq_mem #(parameter WIDTH=8, DEPTH=1024)(clk,rst,w_e,r_e,data_in,data_out,empty,full);
input clk, rst, w_e, r_e;
input [WIDTH-1:0] data_in;
output reg [WIDTH-1:0] data_out;
output empty, full;

integer i;
reg [WIDTH-1:0] mem [DEPTH-1:0];
reg [$clog2(DEPTH)-1:0] w_ptr,r_ptr;

always @ (posedge clk) begin
if(!rst) begin
	w_ptr<=0;
	for (i=0;i<16;i=i+1)
		mem[i]<=0;
end
else if (w_e && !full) begin
	mem[w_ptr]<=data_in;
	w_ptr<=w_ptr+1;
	end
else
    w_ptr<=w_ptr;
	
end

always @ (posedge clk) begin
if(!rst)begin
    r_ptr<=0;
    data_out<=0;
    end
else if (r_e && !empty) begin
    data_out<=mem[r_ptr];
    r_ptr=r_ptr+1;
end
else
    r_ptr<=r_ptr;
end

assign full=(r_ptr == w_ptr+1'b1);
assign empty=(r_ptr == w_ptr);

endmodule
