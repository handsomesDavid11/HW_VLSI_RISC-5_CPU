module ForwardingUnit(
     input MEM_regWrite,
     input EXE_regWrite,
     input [4:0] rs1_addr,
     input [4:0] rs2_addr,
     input [4:0] MEM_rd_addr, 
     input [4:0] EXE_rd_addr,
     output reg [1:0] FDSignal
);
     always_comb begin
     if(EXE_regWrite && rs1_addr==EXE_rd_addr)
          FDSignal = 2'b01;
     else if(MEM_regWrite && rs1_addr==MEM_rd_addr)
          FDSignal = 2'b10;
     else
          FDSignal = 2'b00;

     end
     always_comb begin
     if(EXE_regWrite && rs2_addr==EXE_rd_addr)
          FDSignal = 2'b01;
     else if(MEM_regWrite && rs2_addr==MEM_rd_addr)
          FDSignal = 2'b10;
     else
          FDSignal = 2'b00;

     end


endmodule