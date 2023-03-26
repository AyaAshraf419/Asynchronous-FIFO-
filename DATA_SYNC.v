module DATA_SYNC #(parameter WIDTH=5 )
(
input     wire              RST,
input     wire              CLK,
input     wire  [WIDTH:0]   Unsync_bus,
output    reg   [WIDTH:0]   sync_bus
);
reg [WIDTH:0] out_1;

always @(posedge CLK or negedge RST)
  begin 
    if(!RST)
      out_1<=0;
    else
      out_1<=Unsync_bus;
  end 
  
always @(posedge CLK or negedge RST)
  begin 
    
    if(!RST)
      sync_bus<=0;
    else
      sync_bus<=out_1;
  end 
endmodule


