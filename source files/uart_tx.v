
module uart_tx
    #(parameter DBIT=8, SB_Tick=16)(
    input clk,rst,
    input s_tick,
    input tx_start,
    input [DBIT-1:0] tx_din,
    output reg tx_done_tick,
    output tx
    );
    parameter idle=0, start=1, data=2, stop=3;
    
    reg [1:0] state, nxt_state;
    reg [3:0] s_reg, s_nxt;
    reg [DBIT-1:0] b_reg, b_nxt;
    reg [$clog2(DBIT)-1:0] n_reg, n_nxt;
    reg tx_reg, tx_nxt;
    
    always @ (posedge clk or negedge rst)begin
        if(!rst) begin
            state<=idle;
            s_reg<=0;
            n_reg<=0;
            b_reg<=0;
            tx_reg<=0;
        end
        else begin
            state<=nxt_state;
            s_reg<=s_nxt;
            n_reg<=n_nxt;
            b_reg<=b_nxt;
            tx_reg<=tx_nxt;
        end
    end
    
    always @ (*) begin
    nxt_state=state;
    s_nxt=s_reg;
    b_nxt=b_reg;
    n_nxt=n_reg;
    tx_done_tick=1'b0;
    case(state)
    idle:
    begin
        tx_nxt=1'b1;
        if(tx_start)
        begin
            tx_done_tick=1'b1;
            s_nxt=0;
            b_nxt=tx_din;    
            nxt_state=start;
            end
    end
    start:
    begin
        tx_nxt=1'b0;
        if(s_tick)
            if(s_reg==15)begin
                s_nxt=0;
                n_nxt=0;
                nxt_state=data;
            end
            else
                s_nxt=s_reg+1;
    end
    data:
    begin
        tx_nxt=b_reg[0];
        if(s_tick)
            if(s_reg==15)
            begin
                s_nxt=0;
                b_nxt={1'b0,b_reg[DBIT-1:1]};
                if(n_reg==DBIT-1)
                    nxt_state=stop;
                else
                    n_nxt=n_reg+1;
            end
            else
                s_nxt=s_reg+1;
    end
    stop:
    begin
        tx_nxt=1'b1;
        if(s_tick)
            if(s_reg==(SB_Tick-1))
            begin
                //tx_done_tick=1;
                nxt_state=idle;
            end
            else
                s_nxt=s_reg+1;
    end
    default: nxt_state=idle;
    endcase
    end
    
    assign tx=tx_reg;
endmodule