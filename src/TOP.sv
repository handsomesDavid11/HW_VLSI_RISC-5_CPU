`include "IF.sv"
`include "ID.sv"
`include "EXE.sv"
`include "MEM.sv"
`include "WB.sv"
`include "HazzardCtrl.sv"
`include "SRAM_wrapper.sv"
`include "ForwardingUnit.sv"


module top(
     input clk,
     input rst
);

//------------------------ the wire of IF------------------------//

     wire [1:0] BranchCtrl;
     wire [31:0] pc_imm;
     wire [31:0] pc_immrs1;
     wire InstrFlush;
     wire IFID_RegWrite;
     wire PC_write;
     wire [31:0] instr_out;
     wire [31:0] IF_pc_out;
     wire [31:0] IF_instr_out;
     wire [31:0] pc_out;
     wire [4:0]  ID_rs1_addr;
     wire [4:0]  ID_rs2_addr;
     wire [4:0]  ID_rd_addr;
     wire CtrlSignalFlush;
     wire [4:0]  rs1_addr;
     wire [4:0]  rs2_addr;
IF IF(
    .clk(clk),  
    .rst(rst),
    .BranchCtrl(BranchCtrl),               //EXE_brachCtrl
    .pc_imm(pc_imm),
    .pc_immrs1(pc_immrs1),
    .InstrFlush(InstrFlush),               //data hazard
    .IFID_RegWrite(IFID_RegWrite),         //data hazard
    .PC_write(PC_write),                   //data hazard
    .instr_out(instr_out),                 //memory output

    //output
    .IF_pc_out(IF_pc_out),                 //if register output
    .IF_instr_out(IF_instr_out),           //if register output
    .pc_out(pc_out)                        // to memory
);



//------------------------instruction memory----------------------//
SRAM_wrapper IM1 (
    .CK(~clk),
    .CS(1'b1),
    .OE(1'b1),
    .WEB(4'b1111),
    .A(pc_out[15:2]),
    .DI(32'b0),
    .DO(instr_out)
);


//----------------------------ID state-------------------------------//
     wire [31:0]  WB_rd_data;
     wire [4:0]   WB_rd_addr;
     wire         WB_RegWrite;
       
     wire [31:0] ID_rs1;
     wire [31:0] ID_rs2;
     wire [31:0] ID_pc_out;
     wire [2:0]  ID_funct3;
     wire [6:0]  ID_funct7;
     wire [31:0] wire_mem_rd_data;

     wire [31:0] ID_imm;

     wire [2:0] ID_ALUOp;
     wire ID_PCtoRegSrc;
     wire ID_ALUSrc;
     wire ID_RDSrc;
     wire ID_MemtoReg;
     wire ID_MemWrite;
     wire ID_MemRead;
     wire ID_RegWrite;
     wire [1:0] ID_Branch; 

ID ID(
     .clk(clk),
     .rst(rst),

     .IF_pc_out(IF_pc_out),
     .IF_instr_out(IF_instr_out),
     .WB_rd_data(WB_rd_data),
     .WB_rd_addr(WB_rd_addr),  
     .WB_RegWrite(WB_RegWrite),
     .CtrlSignalFlush(CtrlSignalFlush),
     //output
     .ID_rs1(ID_rs1),
     .ID_rs2(ID_rs2),
     .ID_pc_out(ID_pc_out),
     .ID_funct3(ID_funct3),
     .ID_funct7(ID_funct7),
     .ID_rs1_addr(ID_rs1_addr),
     .ID_rs2_addr(ID_rs2_addr),
     .ID_rd_addr(ID_rd_addr),
     .ID_imm(ID_imm),   
     //control unit
     .ID_ALUOp(ID_ALUOp),
     .ID_PCtoRegSrc(ID_PCtoRegSrc),
     .ID_ALUSrc(ID_ALUSrc),
     .ID_RDSrc(ID_RDSrc),
     .ID_MemtoReg(ID_MemtoReg),
     .ID_MemWrite(ID_MemWrite),
     .ID_MemRead(ID_MemRead),
     .ID_RegWrite(ID_RegWrite),
     .ID_Branch(ID_Branch),

     .rs1_addr(rs1_addr),
     .rs2_addr(rs2_addr)

);
     wire [31:0] EXE_pc_to_reg;
     wire [31:0] EXE_ALU_out;
     wire [31:0] EXE_rs2_data;
     wire [4:0] EXE_rd_addr;
     wire      EXE_RDSrc;
     wire      EXE_MemtoReg;
     wire      EXE_MemWrite;
     wire      EXE_MemRead;
     wire      EXE_RegWrite;

     wire [2:0] EXE_funct3;
     wire [1:0] FDSignal1;
     wire [1:0] FDSignal2;

//------------------------------------------------------------//
     wire MEM_MemtoReg;
     wire MEM_RegWrite;
     wire [31:0] MEM_rd_data;
     wire [31:0] MEM_Dout;   
     wire [4:0] MEM_rd_addr;
     wire [31:0] Dout;
     wire wire_chip_select;  
     wire [3:0] wire_WE;     
     wire [31:0] wire_Din;




EXE EXE(
     .clk(clk),
     .rst(rst),
     .FDSignal1(FDSignal1),
     .FDSignal2(FDSignal2),
     .MEM_rd_data(wire_mem_rd_data),
     .WB_rd_data(WB_rd_data),

     .ID_rs1(ID_rs1),
     .ID_rs2(ID_rs2),
     .ID_pc_out(ID_pc_out),
     .ID_imm(ID_imm), 
     .ID_funct3(ID_funct3),
     .ID_funct7(ID_funct7),
     .ID_rs1_addr(ID_rs1_addr),
     .ID_rs2_addr(ID_rs2_addr),
     .ID_rd_addr(ID_rd_addr),

     //control unit
     .ID_ALUOp(ID_ALUOp),
     .ID_PCtoRegSrc(ID_PCtoRegSrc),
     .ID_ALUSrc(ID_ALUSrc),
     .ID_RDSrc(ID_RDSrc),
     .ID_MemtoReg(ID_MemtoReg),
     .ID_MemWrite(ID_MemWrite),
     .ID_MemRead(ID_MemRead),
     .ID_RegWrite(ID_RegWrite),
     .ID_Branch(ID_Branch),

     //output
     .EXE_pc_to_reg(EXE_pc_to_reg),
     .EXE_ALU_out(EXE_ALU_out),
     .EXE_rs2_data(EXE_rs2_data),
     .EXE_rd_addr(EXE_rd_addr),
     .EXE_RDSrc(EXE_RDSrc),
     .EXE_MemtoReg(EXE_MemtoReg),
     .EXE_MemWrite(EXE_MemWrite),
     .EXE_MemRead(EXE_MemRead),
     .EXE_RegWrite(EXE_RegWrite),
     .wire_BranchCtrl(BranchCtrl),
     .EXE_funct3(EXE_funct3),
     .pc_imm(pc_imm),
     .pc_immrs1(pc_immrs1)

);



MEM MEM(
     .clk(clk),
     .rst(rst),
     .EXE_RDSrc(EXE_RDSrc),
     .EXE_MemtoReg(EXE_MemtoReg),
     .EXE_MemWrite(EXE_MemWrite),
     .EXE_MemRead(EXE_MemRead),
     .EXE_RegWrite(EXE_RegWrite),
     .EXE_pc_to_reg(EXE_pc_to_reg),
     .EXE_ALU_out(EXE_ALU_out),
     .EXE_rs2_data(EXE_rs2_data),
     .EXE_rd_addr(EXE_rd_addr),
     .EXE_funct3(EXE_funct3),
     //output
     .MEM_MemtoReg(MEM_MemtoReg),
     .MEM_RegWrite(MEM_RegWrite),
     .MEM_rd_data(MEM_rd_data),    
     .MEM_Dout(MEM_Dout),    
     .MEM_rd_addr(MEM_rd_addr),

     //DM
     .Dout(Dout),
     .wire_chip_select(wire_chip_select),                    
     .wire_WE(wire_WE),                  
     .wire_Din(wire_Din) ,
     .wire_mem_rd_data(wire_mem_rd_data)          

);

SRAM_wrapper DM1 (
    .CK(~clk),
    .CS(wire_chip_select),
    .OE(EXE_MemRead),
    .WEB(wire_WE),
    .A(EXE_ALU_out[15:2]),
    .DI(wire_Din),
    .DO(Dout)
);



WB WB(
     .clk(clk),
     .rst(rst),
     .MEM_MemtoReg(MEM_MemtoReg),
     .MEM_RegWrite(MEM_RegWrite),
     .MEM_rd_data(MEM_rd_data), //up    
     .MEM_Dout(MEM_Dout),    //data from data mem
     .MEM_rd_addr(MEM_rd_addr),
     //out    
     .WB_RegWrite(WB_RegWrite),
     .WB_rd_data(WB_rd_data),
     .WB_rd_addr(WB_rd_addr)
);

//--------------------------hazardCtrl----------------------------//


ForwardingUnit ForwardingUnit(
     .MEM_RegWrite(MEM_RegWrite),
     .EXE_RegWrite(EXE_RegWrite),
     .rs1_addr(ID_rs1_addr),
     .rs2_addr(ID_rs2_addr),
     .MEM_rd_addr(MEM_rd_addr), 
     .EXE_rd_addr(EXE_rd_addr),
     .FDSignal1(FDSignal1),
     .FDSignal2(FDSignal2)

);



HazardCtrl HazardCtrl(
     .ID_MemRead(ID_MemRead),
     .ID_rd_addr(ID_rd_addr),
     .rs1_addr(rs1_addr),
     .rs2_addr(rs2_addr),
     .BranchCtrl(BranchCtrl),
     //output
     .PC_write(PC_write),
     .instrFlush(InstrFlush),
     .IFID_RegWrite(IFID_RegWrite),
     .CtrlSignalFlush(CtrlSignalFlush)

);

endmodule