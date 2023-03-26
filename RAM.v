module RAM #( parameter WIDTH = 8 , ADDR_WIDTH=5)
(
 input   wire [WIDTH-1:0]      DATA_IN,
 input   wire                  CLK_WRITE,
 input   wire                  CLK_READ,
 input   wire                  WR_EN,
 input   wire [ADDR_WIDTH:0]   ADDR_WR,
 input   wire [ADDR_WIDTH:0]   ADDR_R,
 input   wire                  R_EN,
 input   wire                  FULL_FLAG,
 input   wire                  EMPTY_FLAG,
 input   wire                  WR_RST,
 input   wire                  R_RST,
 output  reg  [WIDTH-1:0]      DATA_out
);
integer I;
// memory of 32 registers each of 8 bits width
reg [WIDTH-1:0] memory [((2**ADDR_WIDTH)-1):0]; 
//Write process
always@(posedge CLK_WRITE or negedge WR_RST)
  begin
   if(!WR_RST)
     begin
       for(I=0;I<(2**ADDR_WIDTH);I=I+1)
         begin
           memory[I]<='b0;
         end
     end
   else if((WR_EN)&&(!FULL_FLAG))
     begin
       memory[ADDR_WR[ADDR_WIDTH-1:0]]<=DATA_IN;
     end
end
//read process
 always@(posedge CLK_READ or negedge R_RST)
  begin
   if(!R_RST)
     begin
       DATA_out<='b0;
     end
   else if((R_EN)&&(!EMPTY_FLAG))
     begin
       DATA_out<=memory[ADDR_R[ADDR_WIDTH-1:0]];
       memory[ADDR_R[ADDR_WIDTH-1:0]]<='b0;
     end
   else
     begin
       DATA_out<=DATA_out;
     end
 
end 
endmodule


