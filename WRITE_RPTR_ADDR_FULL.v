module WRITE_RPTR_ADDR_FULL #( parameter  ADDR_WIDTH=5)
(
 input      wire                   WR_EN,
 input      wire                   WR_RST,
 input      wire                   CLK_WRITE,
 input      wire  [ADDR_WIDTH:0]   rptr_R_SYN,
 output     reg   [ADDR_WIDTH:0]   ADDR_WR,
 output     reg   [ADDR_WIDTH:0]   rptr_WR,
 output     wire                   FULL_FLAG
 
);
integer I;
reg    [ADDR_WIDTH:0]   ADDR_R_n;
wire   [ADDR_WIDTH:0]   rptr_WR_comp;
wire                    cond_1;
wire                    cond_2;
assign rptr_WR_comp = (ADDR_WR>>1)^ADDR_WR;
assign FULL_FLAG    = (cond_1&&cond_2&&WR_RST)? 1:0;
assign cond_1       =(ADDR_R_n[ADDR_WIDTH-1:0]==ADDR_WR[ADDR_WIDTH-1:0])? 1:0;
assign cond_2       =(ADDR_R_n[ADDR_WIDTH]!=ADDR_WR[ADDR_WIDTH]) ?1:0;
always @(posedge CLK_WRITE or negedge WR_RST)
  begin
    if(!WR_RST)
      begin
        rptr_WR<='b0;
      end
    else 
      begin
        rptr_WR<=rptr_WR_comp;
      end 
  end
  
always @(*)
  begin
    if(!WR_RST)
      begin
        ADDR_R_n<='b0;
      end
    else 
      begin
        for(I=0;I<ADDR_WIDTH+1'b1;I=I+1)
           begin
             ADDR_R_n[I]<=^(rptr_R_SYN>>I);
           end
      end 
  end
always@(posedge CLK_WRITE or negedge WR_RST)
  begin
    if(!WR_RST)
      begin
        ADDR_WR<='b0;
      end
    else if(WR_EN&&(ADDR_WR!='b111111)&&(!FULL_FLAG))
      begin
        ADDR_WR<=ADDR_WR+'b1;
      end
    else if (WR_EN&&(ADDR_WR=='b111111)&&(!FULL_FLAG))
      begin
        ADDR_WR<='b0;
      end
    else
      begin
        ADDR_WR<=ADDR_WR;
      end 
  end
endmodule
