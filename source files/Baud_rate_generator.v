module Baud_rate_generator 
    #(parameter BITS=4)(
    input clk,
    input rst,
    input enable,
    input [BITS-1:0] FINAL_VALUE,
    output s_tick
    );
    reg [BITS-1:0] count;
    
    always @ (posedge clk or negedge rst) begin
        if(!rst)
            count<=0;
        else if (enable)
            count<=count+1;
        else
            count<=count;
    end
    assign s_tick= count==FINAL_VALUE;
endmodule