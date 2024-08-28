`include "ALU_Ctrl.sv"
`include "ALU.sv"
`include "BranchCtrl.sv"
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
     input       ID_RDSrc,
     input       ID_MemtoReg,
     input       ID_MemWrite,
     input       ID_MemRead,
     input       ID_RegWrite,
     input       [1:0] ID_Branch,
     
          
     output reg [31:0] EXE_pc_to_reg,
     output reg [31:0] EXE_ALU_out,
     output reg [31:0] EXE_rs2_data,
     output reg [4:0] EXE_rd_addr,
     output reg      EXE_RDSrc,
     output reg      EXE_MemtoReg,
     output reg      EXE_MemWrite,
     output reg      EXE_MemRead,
     output reg      EXE_RegWrite,
     output reg [1:0] EXE_Branch,
     output reg [2:0] EXE_funct3
);

     wire [31:0] wire_pc_4;
     wire [31:0] wire_pc_imm;
     wire [31:0] wire_pc_to_reg;

//------------------------ pc+4 and pc+imm------------------------//
     assign wire_pc_4   = ID_pc_out + 4;
     assign wire_pc_imm = ID_pc_out + ID_imm;
     //mux 2  
//----------------- ID_pctoregsrc to chioce PC+4 or PC+imm--------?//
     assign wire_pc_to_reg = (ID_PCtoRegSrc) ? wire_pc_4 : wire_pc_imm;

//-----------------------ALU src choice----------------------------//
     wire [31:0] wire_ALUSrc1;
     wire [31:0] wire_ALUSrc2;

     assign  wire_ALUSrc1 = ID_rs1;
   //assign  wire_ALUSrc2 = ID_rs2;
     assign  wire_ALUSrc2 = (ID_PCtoRegSrc) ? ID_rs2 : ID_imm;
//---------------------------ALU_control unit-----------------------//
     wire [2:0] wire_funct3;
     wire [6:0] wire_funct7;
     wire [2:0] wire_ALUOp;
     wire [4:0] wire_ALUCtrl;
     // output
     wire wire_zeroFlag;
     wire [31:0] wire_ALU_out;


     assign wire_funct3 = ID_funct3;
     assign wire_funct7 = ID_funct7;
     assign wire_ALUOp  = ID_ALUOp;

     ALU_Ctrl ALU_ctrl(
          .ALUOp(wire_ALUOp),
          .funct3(wire_funct3),
          .funct7(wire_funct7),
          .ALUCtrl(wire_ALUCtrl)
     );

     ALU ALU(
          .rs1(wire_ALUSrc1),
          .rs2(wire_ALUSrc2),
          .ALUCtrl(wire_ALUOp),
          .zeroFlag(wire_zeroFlag),
          .ALU_out(wire_ALU_out)
     );
     BranchCtrl BranchCtrl(
          .wire_zeroFlag(wire_zeroFlag),
          .Branch(ID_Branch),
          .BranchCtrl(EXE_Branch)
     );



     always_ff @(posedge clk, posedge rst)begin
          if(rst) begin
               EXE_pc_to_reg <= 32'b0;
               EXE_ALU_out   <= 32'b0;
               EXE_rs2_data  <= 32'b0;
               EXE_rd_addr   <= 5'b0;
               EXE_funct3    <= 3'b0;

               EXE_RDSrc     <= 1'b0;
               EXE_MemtoReg  <= 1'b0;
               EXE_MemRead   <= 1'b0;
               EXE_MemWrite  <= 1'b0;
               EXE_RegWrite  <= 1'b0;
          end   

          
          else begin
               EXE_pc_to_reg <= wire_pc_to_reg;
               EXE_ALU_out   <= wire_ALU_out;
               EXE_rs2_data  <= ID_rs2;
               EXE_rd_addr   <= ID_rd_addr;
               EXE_funct3    <= ID_funct3;

               EXE_RDSrc     <= ID_RDSrc;
               EXE_MemtoReg  <= ID_MemtoReg;
               EXE_MemRead   <= ID_MemRead;
               EXE_MemWrite  <= ID_MemWrite;
               EXE_RegWrite  <= ID_RegWrite;
          end   


     end


   

endmodule
