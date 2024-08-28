module ALU(
     input [31:0] rs1,
     input [31:0] rs2,
     input [2:0]  ALUCtrl,
     output reg zeroFlag,
     output reg [31:0] ALU_out

);


localparam [5:0]    ADD        = 5'b00000,
                    SUB         = 5'b00001,
                    SLL         = 5'b00010,
                    SLT         = 5'b00011,
                    SLTU        = 5'b00100,
                    XOR         = 5'b00101,
                    SRL         = 5'b00110,
                    SRA         = 5'b00111,
                    OR          = 5'b01000,//8
                    AND         = 5'b01001,
                    JALR        = 5'b01010,
                    BEQ         = 5'b01011,
                    BNE         = 5'b01100,
                    BLT         = 5'b01101,
                    BGE         = 5'b01110,
                    BLTU        = 5'b01111,
                    BGEU        = 5'b10000,
                    IMM         = 5'b10001;

     wire signed [31:0] signed_rs1;
     wire signed [31:0] signed_rs2;
     wire  [31:0] sum;


     assign signed_rs1 = rs1;
     assign signed_rs2 = rs2;
     assign sum        = rs1+rs2; 

     always_comb begin
     case (ALUCtrl)
          ADD :     ALU_out = sum;
          SUB :     ALU_out = rs1 - rs2;
          SLL :     ALU_out = rs1 << rs2[4:0];
          SLT :     ALU_out = (signed_rs1 < signed_rs2) ? 32'b1:32'b0;     
          SLTU:     ALU_out = (rs1 < rs2) ? 32'b1:32'b0;
          XOR :     ALU_out = rs1 ^ rs2;
          SRL :     ALU_out = rs1 >> rs2[4:0];
          SRA :     ALU_out = signed_rs1 >> rs2[4:0];
          OR  :     ALU_out = rs1 | rs2;
          AND :     ALU_out = rs1 & rs2;
          JALR:     ALU_out = {sum[31:1],1'b0};
          IMM :     ALU_out = rs2;
          default : ALU_out = 32'b0;
     endcase
     end

     always_comb begin
     case (ALUCtrl)      
     
          BEQ :    zeroFlag =  (rs1 == rs2) ? 32'b1 : 32'b0;
          BNE :    zeroFlag =  (rs1 != rs2) ? 32'b1 : 32'b0;
          BLT :    zeroFlag =  (signed_rs1  < signed_rs2) ? 32'b1 : 32'b0; 
          BGE :    zeroFlag =  (signed_rs1 >= signed_rs2) ? 32'b1 : 32'b0;
          BLTU:    zeroFlag =  (rs1 <  rs2) ? 32'b1 : 32'b0;
          BGEU:    zeroFlag =  (rs1 >= rs2) ? 32'b1 : 32'b0;
          default :    zeroFlag = 32'b0; 
     
     endcase

     end






endmodule