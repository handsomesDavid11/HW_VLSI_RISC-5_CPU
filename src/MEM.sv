module MEM(


     input clk,
     input rst,
//--------------------------control unit--------------------------//
     input        EXE_RDSrc,
     input        EXE_MemtoReg,
     input        EXE_MemWrite,
     input        EXE_MemRead,
     input        EXE_RegWrite,
//--------------------------
     input [31:0] EXE_pc_to_reg,
     input [31:0] EXE_ALU_out,
     input [31:0] EXE_rs2_data,
     input [4:0] EXE_rd_addr,
     input [2:0] EXE_funct3,


     output reg MEM_MemtoReg,
     output reg MEM_regWrite,
     output reg [31:0] MEM_rd_data,    
     output reg [31:0] MEM_Dout,    //data from data mem
     output reg [4:0] MEM_rd_addr,
     //output reg [31:0] wire_mem_rd_data,
//---------------------------Data memory------------------------//
     input [31:0] Dout,
     output reg wire_chip_select,                    //chip select
     output reg [3:0] wire_WE,                   //write enable 
     output reg [31:0] wire_Din                  //data in 

);

     
     wire [31:0] wire_mem_rd_data;
     assign wire_mem_rd_data = (EXE_RDSrc) ? EXE_pc_to_reg : EXE_ALU_out;
     assign wire_chip_select = EXE_MemRead | EXE_MemWrite;

     reg [31:0] wire_Dout;

     always_comb begin
          case(EXE_funct3)
               3'b010:                //LW
               begin
                    wire_Dout = Dout;
               end
               3'b000:                //LB
               begin
                    wire_Dout = {{24{Dout[7]}},Dout[7:0]};
               end
               3'b001:                //LH
               begin
                    wire_Dout = {{16{Dout[15]}},Dout[15:0]};
               end
               3'b101:                //LBU
               begin
                    wire_Dout = {{24{Dout[7]}},Dout[7:0]};
               end
               3'b100:                //LHU
               begin
                    wire_Dout = {16{Dout[15],Dout[15:0]}}; 
               end
          endcase

     



     
     
     end 

     always_ff @(posedge clk  or posedge rst)begin
          if(rst) begin
               MEM_MemtoReg <= 1'b0;
               MEM_regWrite <= 1'b0;
               MEM_rd_data  <= 32'b0;
               MEM_Dout     <= 32'b0;
               MEM_rd_addr  <= 5'b0;
               


          end
          else begin
               MEM_MemtoReg <= EXE_MemtoReg;
               MEM_regWrite <= EXE_RegWrite;
               MEM_rd_data  <= wire_mem_rd_data;
               MEM_Dout     <= wire_Dout;
               MEM_rd_addr  <= EXE_rd_addr;

          end


     end 

     



endmodule