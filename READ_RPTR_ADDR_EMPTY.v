module READ_RPTR_ADDR_EMPTY #( parameter  ADDR_WIDTH=5)
(
 input      wire                   R_EN,
 input      wire                   CLK_READ,
 input      wire                   R_RST,   
 input      wire  [ADDR_WIDTH:0]   rptr_WR_SYN,
 output     reg   [ADDR_WIDTH:0]   ADDR_R,
 output     reg   [ADDR_WIDTH:0]   rptr_R,
 output     wire                   EMPTY_FLAG
);
integer I;
reg  [ADDR_WIDTH:0] ADDR_WR;
wire [ADDR_WIDTH:0] rptr_R_comp;

assign rptr_R_comp = (ADDR_R>>1)^ADDR_R;
assign EMPTY_FLAG  = ((ADDR_R==ADDR_WR)&&(R_RST))? 1:0;

always @(posedge CLK_READ or negedge R_RST)
  begin
    if(!R_RST)
      begin
        rptr_R<='b0;
      end
    else 
      begin
        rptr_R<=rptr_R_comp;
      end 
  end
  
always @(*)
  begin
    if(!R_RST)
      begin
        ADDR_WR<='b0;
      end
    else 
      begin
        for(I=0;I<ADDR_WIDTH+1'b1;I=I+1)
           begin
             ADDR_WR[I]<=^(rptr_WR_SYN>>I);
           end
      end 
  end
  
always@(posedge CLK_READ or negedge R_RST)
  begin
    if(!R_RST)
      begin
        ADDR_R<='b0;
      end
  else if(R_EN&&(ADDR_R!='b111111)&&(!EMPTY_FLAG))
      begin
        ADDR_R<=ADDR_R+'b1;
      end
    else if (R_EN&&(ADDR_R=='b111111)&&(!EMPTY_FLAG))
      begin
        ADDR_R<='b0;
      end
    else
      begin
        ADDR_R<=ADDR_R;
      end 
  end
endmodule


