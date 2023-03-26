module FIFO #( parameter WIDTH = 8 , ADDR_WIDTH=5)
(
 input   wire [WIDTH-1:0]      DATA_IN,
 input   wire                  CLK_WRITE,
 input   wire                  CLK_READ,
 input   wire                  WR_EN,
 input   wire                  R_EN,
 input   wire                  WR_RST,
 input   wire                  R_RST,
 output  wire                  FULL_FLAG,
 output  wire                  EMPTY_FLAG,
 output  wire [WIDTH-1:0]      DATA_out
);
wire [ADDR_WIDTH:0]   ADDR_WR;
wire [ADDR_WIDTH:0]   ADDR_R;
wire [ADDR_WIDTH:0]   rptr_WR;
wire [ADDR_WIDTH:0]   rptr_WR_SYN;
wire [ADDR_WIDTH:0]   rptr_R;
wire [ADDR_WIDTH:0]   rptr_R_SYN;
//------------READ pointer syncronizer----------
DATA_SYNC U0_R_SYN
(
.RST(WR_RST),
.CLK(CLK_WRITE),
.Unsync_bus(rptr_R),
.sync_bus(rptr_R_SYN)
);
//------------WRITE pointer syncronizer----------
DATA_SYNC  U1_WR_SYN
(
.RST(R_RST),
.CLK(CLK_READ),
.Unsync_bus(rptr_WR),
.sync_bus(rptr_WR_SYN)
);
//-------------MEMORY----------------------------
RAM    U2_RAM
(
.DATA_IN(DATA_IN),
.CLK_WRITE(CLK_WRITE),
.CLK_READ(CLK_READ),
.WR_EN(WR_EN),
.ADDR_WR(ADDR_WR),
.ADDR_R(ADDR_R),
.R_EN(R_EN),
.FULL_FLAG(FULL_FLAG),
.EMPTY_FLAG(EMPTY_FLAG),
.WR_RST(WR_RST),
.R_RST(R_RST),
.DATA_out(DATA_out)
);
//---------------FIFO READ ADDRESS AND EMPTY FLAG GENERATION --------------
READ_RPTR_ADDR_EMPTY U5_READ_RPTR_ADDR_EMPTY
(
.R_EN(R_EN),
.CLK_READ(CLK_READ),
.R_RST(R_RST),   
.rptr_WR_SYN(rptr_WR_SYN),
.ADDR_R(ADDR_R),
.rptr_R(rptr_R),
.EMPTY_FLAG(EMPTY_FLAG)
);
//---------------FIFO WRITE ADDRESS AND FULL FLAG GENERATION --------------
WRITE_RPTR_ADDR_FULL   U4_WRITE_RPTR_ADDR_FULL
(
.WR_EN(WR_EN),
.rptr_R_SYN(rptr_R_SYN),
.WR_RST(WR_RST),   
.CLK_WRITE(CLK_WRITE),
.ADDR_WR(ADDR_WR),
.rptr_WR(rptr_WR),
.FULL_FLAG(FULL_FLAG)
);

endmodule