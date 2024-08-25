module EXE(
     input clk,
     input rst,
     //data
     input [31:0]  ID_rs1,
     input [31:0]  ID_rs2,

     input [31:0]  ID_pc_out,
     input [31:0]  ID_imm, 

     input [2:0]   ID_funct3,
     input [6:0]   ID_funct7,
     input [4:0]   ID_rs1_addr,
     input [4:0]   ID_rs2_addr,
     input [4:0]   ID_rd_addr,

     //control signal wire use 1.2.3
     input [2:0] ID_ALUOp,
     input       ID_PCtoRegSrc,
     input       ID_ALUSrc,
          
     output EXE_pc_to_reg,
     output EXE_ALU_out,
     output EXE_rs2_data,
     output EXE_rd_addr,
     output 
);

     wire [31:0] wire_pc_4;
     wire [31:0] wire_pc_imm;
     wire [31:0] wire_pc_to_reg;


     assign wire_pc_4   = ID_pc_out + 4;
     assign wire_pc_imm = ID_pc_out + ID_imm;
     //mux 2
     always_comb begin
          if(ID_PCtoRegSrc)   
               wire_pc_to_reg = wire_pc_4;
          else 
               wire_pc_to_reg = wire_pc_imm;
     end     
     
     wire [31:0] wire_ALUSrc1;
     wire [31:0] wire_ALUSrc2;

     assign  wire_ALUSrc1 = ID_rs1;
     assign  wire_ALUSrc2 = ID_rs2;


     if(ID_ALUSrc)
          wire_ALUSrc2 = ID_rs2;
     else
          wire_ALUSrc2 = ID_imm;

     wire [2:0] wire_funct3;
     wire [6:0] wire_funct7;
     

endmodule
