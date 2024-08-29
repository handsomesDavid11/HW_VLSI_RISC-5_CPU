module HazardCtrl(
     input ID_MemRead,
     input [4:0] ID_rd_addr,
     input [4:0] rs1_addr,
     input [4:0] rs2_addr,
     input [1:0] BranchCtrl,

     output reg PC_write,
     output reg instrFlush,
     output reg IFID_RegWrite,
     output reg CtrlSignalFlush

);

     localparam [1:0]    None_branch = 2'b00,
                         B_branch    = 2'b01,
                         JALR_branch = 2'b10,
                         J_branch    = 2'b11;


     always_comb begin
          if( BranchCtrl != None_branch)begin
               PC_write          = 1'b1;
               instrFlush        = 1'b1;
               IFID_RegWrite     = 1'b1;
               CtrlSignalFlush   = 1'b1;
          end
          else if( ID_MemRead && ((ID_rd_addr==rs1_addr) || (ID_rd_addr==rs2_addr)) )begin
               PC_write          = 1'b0;
               instrFlush        = 1'b0;
               IFID_RegWrite     = 1'b0;
               CtrlSignalFlush   = 1'b1;
          end
          else begin
               PC_write          = 1'b1;
               instrFlush        = 1'b0;
               IFID_RegWrite     = 1'b1;
               CtrlSignalFlush   = 1'b0;
          end

     end






endmodule