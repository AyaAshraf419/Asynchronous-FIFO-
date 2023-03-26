`timescale 1ns/100ps
module FIFO_TB #( parameter WIDTH = 8 ) ();
 reg [WIDTH-1:0]      DATA_IN_TB;
 reg                  CLK_WRITE_TB;
 reg                  CLK_READ_TB;
 reg                  WR_EN_TB;
 reg                  R_EN_TB;
 reg                  WR_RST_TB;
 reg                  R_RST_TB;
 wire                 FULL_FLAG_TB;
 wire                 EMPTY_FLAG_TB;
 wire [WIDTH-1:0]     DATA_out_TB;
integer I; 
initial
 begin
   DATA_IN_TB='b0;  
   CLK_WRITE_TB=1'b0;
   CLK_READ_TB=1'b0;
   WR_RST_TB=1'b0; 
   WR_EN_TB=1'b0;
   R_EN_TB=1'b0;     
   R_RST_TB=1'b0;  
   #70
//------------------reading from empty  fifo-----------------------
   R_EN_TB=1'b1;    
   R_RST_TB=1'b1;
   #40
   if(EMPTY_FLAG_TB==1'b1)
       $display("Test1 passed");
   else
       $display("Test1 failed");
   #30
//----------------writing twice in fifo------------------------
   R_EN_TB=1'b0;  
   WR_RST_TB=1'b1;
   WR_EN_TB=1'b1;
   DATA_IN_TB='b11111111;
   #20
   R_EN_TB=1'b0;  
   WR_EN_TB=1'b0;
   #50
   R_EN_TB=1'b0;  
   WR_EN_TB =1'b1;
   DATA_IN_TB='b10000001;
   #20
   R_EN_TB=1'b0;  
   WR_EN_TB=1'b0;
   #50
//----------------reading twice from fifo---------------------
   R_EN_TB=1'b1;
   WR_EN_TB =1'b0;
   #40
   if((DATA_out_TB=='b11111111)&&(!EMPTY_FLAG_TB)&&(!FULL_FLAG_TB))
       $display("Test2&4 passed");
     else
       $display("Test2&4 failed");
   #30
   R_EN_TB=1'b1;
   WR_EN_TB=1'b0;
   #40
   if((DATA_out_TB=='b10000001)&&(EMPTY_FLAG_TB)&&(!FULL_FLAG_TB))
       $display("Test3&5 passed");
   else
       $display("Test3&5 failed");
   #30
   R_EN_TB=1'b0;  
   WR_EN_TB=1'b0;
//------------------reading from empty  fifo-----------------------
   R_EN_TB=1'b1;
   #40
   if(EMPTY_FLAG_TB==1'b1)
       $display("Test6 passed");
   else
       $display("Test4 failed");
   #20 
   
//-------------------Full fifo with random data---------------------
   for(I=0;I<32;I=I+1)
     begin
       R_EN_TB=1'b0;
       WR_EN_TB=1'b1;
       DATA_IN_TB= $random;
       #20
       R_EN_TB=1'b0;  
       WR_EN_TB=1'b0;
       #100
       R_EN_TB=1'b0;  
       WR_EN_TB=1'b0;
     end  
   if((!EMPTY_FLAG_TB)&&(FULL_FLAG_TB))
     $display("Test7 passed");
   else
     $display("Test7 failed");
   #17.5
//----------------reading till the fifo is empty-------------------------
   for(I=0;I<32;I=I+1)
     begin
       R_EN_TB=1'b1;
       WR_EN_TB =1'b0;
  	    #70
       R_EN_TB=1'b0;  
       WR_EN_TB=1'b0;
       #70
       R_EN_TB=1'b0;  
       WR_EN_TB=1'b0;
     end
   if((EMPTY_FLAG_TB)&&(!FULL_FLAG_TB))
     $display("Test8 passed");
   else
     $display("Test8 failed");
   #63.5
//-------------------Full fifo with random data---------------------
   for(I=0;I<32;I=I+1)
     begin
       R_EN_TB=1'b0;
       WR_EN_TB=1'b1;
       DATA_IN_TB= $random;
       #20
       R_EN_TB=1'b0;  
       WR_EN_TB=1'b0;
       #100
       R_EN_TB=1'b0;  
       WR_EN_TB=1'b0;
     end  
   if((!EMPTY_FLAG_TB)&&(FULL_FLAG_TB))
     $display("Test9 passed");
   else
     $display("Test9 failed");
   $stop;
 end


always #10  CLK_WRITE_TB=~CLK_WRITE_TB;
always #35  CLK_READ_TB =~CLK_READ_TB;
 FIFO DUT
(
.DATA_IN(DATA_IN_TB),
.CLK_WRITE(CLK_WRITE_TB),
.CLK_READ(CLK_READ_TB),
.WR_EN(WR_EN_TB),
.R_EN(R_EN_TB),
.WR_RST(WR_RST_TB),
.R_RST(R_RST_TB),
.FULL_FLAG(FULL_FLAG_TB), 
.EMPTY_FLAG(EMPTY_FLAG_TB),
.DATA_out(DATA_out_TB)
);
endmodule