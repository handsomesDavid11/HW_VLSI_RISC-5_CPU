module WB(
     input clk,
     input rst,
//---------------------------control unit------------------------------//
     input  MEM_MemtoReg,
     input  MEM_regWrite,
     input  [31:0] MEM_rd_data, //up    
     input  [31:0] MEM_Dout,    //data from data mem
     input  [4:0] MEM_rd_addr,  //
     
     output reg WB_regWrite,
     output reg [31:0] WB_rd_data,
     output reg [4:0] WB_rd_addr
);
     assign WB_regWrite = MEM_regWrite;

     assign WB_rd_data  = (MEM_MemtoReg)? MEM_rd_data:MEM_Dout;

     assign WB_rd_addr  = MEM_rd_addr;

endmodule