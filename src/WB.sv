module WB(
     input clk,
     input rst,
//---------------------------control unit------------------------------//
     input  MEM_MemtoReg,
     input  MEM_RegWrite,
     input  [31:0] MEM_rd_data, //up    
     input  [31:0] MEM_Dout,    //data from data mem
     input  [4:0] MEM_rd_addr,  //
     
     output reg WB_RegWrite,
     output reg [31:0] WB_rd_data,
     output reg [4:0] WB_rd_addr
);
     assign WB_RegWrite = MEM_RegWrite;

     assign WB_rd_data  = (MEM_MemtoReg)? MEM_Dout:MEM_rd_data;

     assign WB_rd_addr  = MEM_rd_addr;

endmodule