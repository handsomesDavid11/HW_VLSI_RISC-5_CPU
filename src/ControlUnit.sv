module controlUnit(
     input [6:0]opcode,

     output reg [2:0] ImmType,
     output reg [2:0] ALUOp,

     output reg PCtoRegSrc,
     output reg RDSrc,
     output reg ALUSrc,
     output reg MemtoReg,
     output reg MemWrite,
     output reg MemRead,
     output reg RegWrite,
     output reg Branch,

     output reg [1:0] Branch
);
     localparam [2:0]    I_Imm = 3'b000,
                         S_Imm = 3'b001,
                         B_Imm = 3'b010,
                         U_Imm = 3'b011,
                         J_Imm = 3'b100;

     localparam [2:0]    R_type   = 3'b000,
                         I_type   = 3'b001,
                         ADD_type = 3'b010,
                         B_type   = 3'b011;


     localparam [1:0] None_branch    = 2'b00,
                         B_branch    = 2'b01,
                         JALR_branch = 2'b10,
                         J_branch    = 2'b11;


     always_comb begin
     case (opcode)
          //R_type
          7'b0110011:begin
               ImmType    = I_Imm;  //don't care
               ALUOp      = R_type;
               PCtoRegSrc = 1'b0;   //don't care
               ALUSrc     = 1'b1;   // reg
               RDSrc      = 1'b0;   // ALU
               MemtoReg   = 1'b0;
               MemWrite   = 1'b0;
               MemRead    = 1'b0;
               RegWrite   = 1'b1;
               Branch     = None_branch;

          end

               

          //LW and LB
          7'b0000011:begin
               ImmType    = I_Imm;
               ALUOp      = ADD_type;
               PCtoRegSrc = 1'b0;   //don't care
               ALUSrc     = 1'b0;   
               RDSrc      = 1'b0;   //don't care
               MemtoReg   = 1'b1;
               MemWrite   = 1'b0;
               MemRead    = 1'b1;
               RegWrite   = 1'b1;
               Branch     = None_branch;
          end
          //I_type
          7'b0010011:begin
               ImmType    = S_Imm;
               ALUOp      = I_type;
               PCtoRegSrc = 1'b0;   //don't care
               ALUSrc     = 1'b0;   
               RDSrc      = 1'b0;   
               MemtoReg   = 1'b0;
               MemWrite   = 1'b0;
               MemRead    = 1'b0;
               RegWrite   = 1'b1;
               Branch     = None_branch;
          end

          //JALR !!!!!!!
          7'b1100111:begin
               ImmType    = I_Imm;
               ALUOp      = JALR_type;
               PCtoRegSrc = 1'b0;   //don't care
               ALUSrc     = 1'b0;   
               RDSrc      = 1'b1;   //don't care
               MemtoReg   = 1'b1;
               MemWrite   = 1'b0;
               MemRead    = 1'b0;
               RegWrite   = 1'b1;
               Branch     = JALR_branch;
          
          end

          //S_type ok
          7'b0100011: begin
               ImmType    = S_Imm;
               ALUOp      = ADD_type;
               PCtoRegSrc = 1'b0;   //don't care
               ALUSrc     = 1'b0;   
               RDSrc      = 1'b0;   //don't care
               MemtoReg   = 1'b0;
               MemWrite   = 1'b1;
               MemRead    = 1'b0;
               RegWrite   = 1'b0;
               Branch     = None_branch;
          end

          //B_type
          7'b1100011: begin
               ImmType    = B_Imm;
               ALUOp      = B_type;
               PCtoRegSrc = 1'b0;   //don't care
               ALUSrc     = 1'b1;   
               RDSrc      = 1'b0;   //don't care
               MemtoReg   = 1'b0;
               MemWrite   = 1'b0;
               MemRead    = 1'b0;
               RegWrite   = 1'b0;
               Branch     = B_branch;

          end

          //U_type
          7'b0010111: begin
               ImmType    = U_Imm;
               ALUOp      = B_type;
               PCtoRegSrc = 1'b0;   //don't care
               ALUSrc     = 1'b1;   
               RDSrc      = 1'b0;   //don't care
               MemtoReg   = 1'b0;
               MemWrite   = 1'b0;
               MemRead    = 1'b0;
               RegWrite   = 1'b0;
               Branch     = B_branch;


          end

          7'b0110111:
          //J_type
          7'b1101111:





     endcase



     end


endmodule