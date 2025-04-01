module uart_rx
    #(parameter DBIT=8, SB_Tick=16)(
    input clk, rst,
    input rx, s_tick,
    output [7:0] rx_dout,
    output reg rx_done_tick
    );
    //local parameters
    parameter idle=0, start=1, data=2, stop=3;
    
    //internal varialbles
    reg [1:0] state, nxt_state;
    reg [3:0] s_reg, s_nxt;
    reg [$clog2(DBIT)-1:0] n_reg, n_nxt;
    reg [DBIT-1:0] b_reg, b_nxt;
    
    always @ (posedge clk or negedge rst) begin
        if(!rst)begin
            state<=idle;
            s_reg<=0;
            n_reg<=0;
            b_reg<=0;
        end
        else begin
            state<=nxt_state;
            s_reg<=s_nxt;
            n_reg<=n_nxt;
            b_reg<=b_nxt;
        end
    end
    
    always @ (*) begin
    nxt_state=state;
    s_nxt=s_reg;
    n_nxt=n_reg;
    b_nxt=b_reg;
    rx_done_tick=1'b0;
        case(state)
        idle:begin
            if(rx)
                nxt_state=idle;
            else
                begin
                    s_nxt=0;
                    nxt_state=start;
                end
        end
        start:begin
            if(s_tick) begin
                if(s_reg==7) begin
                    s_nxt=0;
                    n_nxt=0;
                    nxt_state=data;
                end
                else 
                    s_nxt=s_reg+1;
                end
        end
        data:begin
            if(s_tick)
                if(s_reg==15) begin
                    s_nxt=0;
                    b_nxt={rx,b_reg[DBIT-1:1]};
                    if(n_reg==(DBIT-1))
                        nxt_state=stop;
                    else 
                        n_nxt=n_reg+1;
                end
                else 
                    s_nxt=s_reg+1;
                   
        end
        stop:begin
            if(s_tick)
                if(s_reg==(SB_Tick-1))begin
                    rx_done_tick=1;
                    nxt_state=idle;
                    end
                else
                    s_nxt=s_reg+1;
                
        end
        default: nxt_state=idle;
        endcase
    end
    
    
    assign rx_dout=b_reg;
endmodule
