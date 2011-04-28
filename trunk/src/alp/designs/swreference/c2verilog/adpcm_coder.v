
/*       This module was generated by c-to-verilog.com
 * THIS SOFTWARE IS PROVIDED BY www.c-to-verilog.com ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL c-to-verilog.com BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES)
 * 
 * Found a bug? email info@c-to-verilog.com 
 */


module _Z11adpcm_coderPiS_S_S_  (clk, reset, rdy,// control 
	mem_indata_out0, mem_indata_in0, mem_indata_addr0, mem_indata_mode0, // memport for: indata 
	mem_indexTable_out0, mem_indexTable_in0, mem_indexTable_addr0, mem_indexTable_mode0, // memport for: indexTable 
	mem_outdata_out0, mem_outdata_in0, mem_outdata_addr0, mem_outdata_mode0, // memport for: outdata 
	mem_stepSizeTable_out0, mem_stepSizeTable_in0, mem_stepSizeTable_addr0, mem_stepSizeTable_mode0, // memport for: stepSizeTable 
	p_indata, p_outdata, p_indexTable, p_stepSizeTable, return_value); // params 
 input wire clk;
 input wire reset;
 output rdy;
 reg rdy;
 output return_value;
 reg return_value;
 input [15:0] p_indata;
 input [15:0] p_outdata;
 input [15:0] p_indexTable;
 input [15:0] p_stepSizeTable;
input wire [31:0] mem_indata_out0;
output reg [31:0] mem_indata_in0;
output reg [15:0] mem_indata_addr0;
output reg mem_indata_mode0;
input wire [31:0] mem_indexTable_out0;
output reg [31:0] mem_indexTable_in0;
output reg [15:0] mem_indexTable_addr0;
output reg mem_indexTable_mode0;
input wire [31:0] mem_outdata_out0;
output reg [31:0] mem_outdata_in0;
output reg [15:0] mem_outdata_addr0;
output reg mem_outdata_mode0;
input wire [31:0] mem_stepSizeTable_out0;
output reg [31:0] mem_stepSizeTable_in0;
output reg [15:0] mem_stepSizeTable_addr0;
output reg mem_stepSizeTable_mode0;


 reg [31:0] i_tmp3;   /*local var*/
 reg [31:0] i_tmp7;   /*local var*/
 reg [31:0] i_tmp10;   /*local var*/
 reg i_tmp12;   /*local var*/
 reg [31:0] i_tmp21;   /*local var*/
 reg [31:0] i_iftmp_0_0;   /*local var*/
 reg i_tmp16;   /*local var*/
 reg [31:0] i_diff_0;   /*local var*/
 reg i_tmp27;   /*local var*/
 reg [31:0] i_tmp36;   /*local var*/
 reg [31:0] i_delta_0;   /*local var*/
 reg [31:0] i_diff_1;   /*local var*/
 reg [31:0] i_vpdiff_0;   /*local var*/
 reg i_tmp42;   /*local var*/
 reg [31:0] i_tmp53;   /*local var*/
 reg [31:0] i_tmp47;   /*local var*/
 reg [31:0] i_diff_2;   /*local var*/
 reg [31:0] i_vpdiff_1;   /*local var*/
 reg i_tmp59;   /*local var*/
 reg [31:0] i_tmp67;   /*local var*/
 reg [31:0] i_vpdiff_2;   /*local var*/
 reg [31:0] i_tmp;   /*local var*/
 reg [31:0] i_valpred_0_p;   /*local var*/
 reg [31:0] i_valpred_0;   /*local var*/
 reg i_tmp83;   /*local var*/
 reg [31:0] i_len_010_0;   /*phi var*/
 reg [31:0] i_valpred_17_0;   /*phi var*/
 reg [31:0] i_index_013_0;   /*phi var*/
 reg [31:0] i_bufferstep_014_0;   /*phi var*/
 reg [31:0] i_outputbuffer_117_0;   /*phi var*/
 reg [31:0] i_step_01_0;   /*phi var*/
 reg i_tmp89;   /*local var*/
 reg [31:0] ltmp_0_1;   /*local var*/
 reg i_tmp121;   /*local var*/
 reg [31:0] i_delta_1;   /*local var*/
 reg [31:0] i_delta_2;   /*local var*/
 reg [31:0] i_tmp97;   /*local var*/
 reg [31:0] i_tmp101;   /*local var*/
 reg [31:0] i_tmp103;   /*local var*/
 reg i_tmp105;   /*local var*/
 reg [31:0] i_index_1;   /*local var*/
 reg i_tmp111;   /*local var*/
 reg [31:0] i_index_2;   /*local var*/
 reg [31:0] i_tmp119;   /*local var*/
 reg [31:0] i_valpred_2;   /*phi var*/
 reg [7:0] i_reduced_and;   /*local var*/
 reg [3:0] i_reduced_and37;   /*local var*/
 reg [31:0] i_tmp132;   /*local var*/
 reg [31:0] i_indvar_next31;   /*local var*/
 reg i_exitcond32;   /*local var*/
 reg [31:0] i_outputbuffer_022_0;   /*phi var*/
 reg [31:0] i_outputbuffer_022_0_lcssa;   /*phi var*/

 // Number of states:53
 reg [5:0] eip;
 parameter entry0 = 6'd0;
 parameter entry1 = 6'd1;
 parameter entry2 = 6'd2;
 parameter bb0 = 6'd3;
 parameter bb1 = 6'd4;
 parameter bb2 = 6'd5;
 parameter bb3 = 6'd6;
 parameter bb4 = 6'd7;
 parameter bb5 = 6'd8;
 parameter bb6 = 6'd9;
 parameter bb7 = 6'd10;
 parameter bb8 = 6'd11;
 parameter bb9 = 6'd12;
 parameter bb10 = 6'd13;
 parameter bb11 = 6'd14;
 parameter bb12 = 6'd15;
 parameter bb13 = 6'd16;
 parameter bb14 = 6'd17;
 parameter bb15 = 6'd18;
 parameter bb16 = 6'd19;
 parameter bb17 = 6'd20;
 parameter bb18 = 6'd21;
 parameter bb19 = 6'd22;
 parameter bb20 = 6'd23;
 parameter cond_false870 = 6'd24;
 parameter cond_false871 = 6'd25;
 parameter cond_true920 = 6'd26;
 parameter cond_next940 = 6'd27;
 parameter cond_next941 = 6'd28;
 parameter cond_next942 = 6'd29;
 parameter cond_next943 = 6'd30;
 parameter cond_next944 = 6'd31;
 parameter cond_next945 = 6'd32;
 parameter cond_next946 = 6'd33;
 parameter cond_next947 = 6'd34;
 parameter cond_next948 = 6'd35;
 parameter cond_next949 = 6'd36;
 parameter cond_next9410 = 6'd37;
 parameter cond_next9411 = 6'd38;
 parameter cond_next9412 = 6'd39;
 parameter cond_true1240 = 6'd40;
 parameter cond_true1241 = 6'd41;
 parameter cond_false1280 = 6'd42;
 parameter cond_false1281 = 6'd43;
 parameter cond_false1282 = 6'd44;
 parameter cond_false1283 = 6'd45;
 parameter bb1420 = 6'd46;
 parameter bb1421 = 6'd47;
 parameter bb1422 = 6'd48;
 parameter bb1470 = 6'd49;
 parameter cond_true1520 = 6'd50;
 parameter cond_true1521 = 6'd51;
 parameter UnifiedReturnBlock330 = 6'd52;

// Assign part (0)


always @(posedge clk)
 begin
  if (reset)
   begin
    $display("@hard reset");
    eip<=0;
    rdy<=0;
   end


// Datapath 
i_tmp10 <= i_tmp7-i_valpred_17_0;
i_tmp12 <= (i_tmp10 < (0));
i_tmp21 <= (0)-i_tmp10;
i_iftmp_0_0 <= (i_tmp12 ? (8) : (0));
i_tmp16 <= (i_iftmp_0_0 == (0));
i_diff_0 <= (i_tmp16 ? i_tmp10 : i_tmp21);
i_tmp27 <= (i_diff_0 < i_step_01_0);
i_tmp36 <= (i_tmp27 ? (0) : i_step_01_0);
i_delta_0 <= (i_tmp27 ? (0) : (4));
i_diff_1 <= i_diff_0-i_tmp36;
i_vpdiff_0 <= i_tmp36+(i_step_01_0 >> (3));
i_tmp42 <= (i_diff_1 < (i_step_01_0 >> (1)));
i_tmp53 <= (i_tmp42 ? (0) : (i_step_01_0 >> (1)));
i_tmp47 <= (i_tmp42 ? (0) : (2));
i_diff_2 <= i_diff_1-i_tmp53;
i_vpdiff_1 <= i_vpdiff_0+i_tmp53;
i_tmp59 <= (i_diff_2 < (i_step_01_0 >> (2)));
i_tmp67 <= (i_tmp59 ? (0) : (i_step_01_0 >> (2)));
i_vpdiff_2 <= i_vpdiff_1+i_tmp67;
i_tmp <= (0)-i_vpdiff_2;
i_valpred_0_p <= (i_tmp16 ? i_vpdiff_2 : i_tmp);
i_valpred_0 <= i_valpred_0_p+i_valpred_17_0;
i_tmp83 <= (i_valpred_0 > (32767));
i_tmp89 <= (i_valpred_0 < (-32768));
ltmp_0_1 <= i_delta_0|i_iftmp_0_0;
i_tmp121 <= (i_bufferstep_014_0 == (0));
i_delta_1 <= ltmp_0_1|i_tmp47;
i_delta_2 <= i_delta_1|(i_tmp59);
i_tmp97 <= i_delta_2^(1);
i_tmp103 <= i_tmp101+i_index_013_0;
i_tmp105 <= (i_tmp103 < (0));
i_index_1 <= (i_tmp105 ? (0) : i_tmp103);
i_tmp111 <= (i_index_1 > (88));
i_index_2 <= (i_tmp111 ? (88) : i_index_1);
i_reduced_and <= ((240))&((i_tmp97 << (4)));
i_reduced_and37 <= ((15))&(i_tmp97);
i_tmp132 <= (i_reduced_and37)|i_outputbuffer_117_0;
i_indvar_next31 <= i_len_010_0+(1);
i_exitcond32 <= (i_indvar_next31 == (1024));


// Control 
case (eip)
entry0:
begin
	mem_stepSizeTable_mode0 <= 0;
	mem_stepSizeTable_addr0 <= (p_stepSizeTable + ltmp_1_1);
	eip <= entry1;
end
entry1:
begin
	i_tmp3 <= mem_stepSizeTable_out0;
	eip <= entry2;
end
entry2:
begin
			i_len_010_0 <= (0);
		i_bufferstep_014_0 <= (1);
		i_step_01_0 <= i_tmp3;
		eip <= bb0;
end
bb0:
begin
	mem_indata_mode0 <= 0;
	mem_indata_addr0 <= (p_indata + i_len_010_0);
	eip <= bb1;
end
bb1:
begin
	i_tmp7 <= mem_indata_out0;
	eip <= bb2;
end
bb2:
begin
	eip <= bb3;
end
bb3:
begin
	eip <= bb4;
end
bb4:
begin
	eip <= bb5;
end
bb5:
begin
	eip <= bb6;
end
bb6:
begin
	eip <= bb7;
end
bb7:
begin
	eip <= bb8;
end
bb8:
begin
	eip <= bb9;
end
bb9:
begin
	eip <= bb10;
end
bb10:
begin
	eip <= bb11;
end
bb11:
begin
	eip <= bb12;
end
bb12:
begin
	eip <= bb13;
end
bb13:
begin
	eip <= bb14;
end
bb14:
begin
	eip <= bb15;
end
bb15:
begin
	eip <= bb16;
end
bb16:
begin
	eip <= bb17;
end
bb17:
begin
	eip <= bb18;
end
bb18:
begin
	eip <= bb19;
end
bb19:
begin
	eip <= bb20;
end
bb20:
begin
	if (i_tmp83) begin
		i_valpred_2 <= (32767);
		eip <= cond_next940;
	end else begin
		eip <= cond_false870;
	end
end
cond_false870:
begin
	eip <= cond_false871;
end
cond_false871:
begin
	if (i_tmp89) begin
		eip <= cond_true920;
	end else begin
		i_valpred_2 <= i_valpred_0;
		eip <= cond_next940;
	end
end
cond_true920:
begin
			i_valpred_2 <= (-32768);
		eip <= cond_next940;
end
cond_next940:
begin
	eip <= cond_next941;
end
cond_next941:
begin
	eip <= cond_next942;
end
cond_next942:
begin
	eip <= cond_next943;
end
cond_next943:
begin
	eip <= cond_next944;
end
cond_next944:
begin
	mem_indexTable_mode0 <= 0;
	mem_indexTable_addr0 <= (p_indexTable + i_tmp97);
	eip <= cond_next945;
end
cond_next945:
begin
	i_tmp101 <= mem_indexTable_out0;
	eip <= cond_next946;
end
cond_next946:
begin
	eip <= cond_next947;
end
cond_next947:
begin
	eip <= cond_next948;
end
cond_next948:
begin
	eip <= cond_next949;
end
cond_next949:
begin
	eip <= cond_next9410;
end
cond_next9410:
begin
	eip <= cond_next9411;
end
cond_next9411:
begin
	mem_stepSizeTable_mode0 <= 0;
	mem_stepSizeTable_addr0 <= (p_stepSizeTable + i_index_2);
	eip <= cond_next9412;
end
cond_next9412:
begin
	i_tmp119 <= mem_stepSizeTable_out0;
	if (i_tmp121) begin
		eip <= cond_false1280;
	end else begin
		eip <= cond_true1240;
	end
end
cond_true1240:
begin
	eip <= cond_true1241;
end
cond_true1241:
begin
			i_outputbuffer_022_0 <= (i_reduced_and);
		eip <= bb1420;
end
cond_false1280:
begin
	eip <= cond_false1281;
end
cond_false1281:
begin
	eip <= cond_false1282;
end
cond_false1282:
begin
	mem_outdata_in0 <= i_tmp132;
	mem_outdata_mode0 <= 1;
	mem_outdata_addr0 <= p_outdata;
	eip <= cond_false1283;
end
cond_false1283:
begin
	mem_outdata_mode0 <= 0;
			i_outputbuffer_022_0 <= i_outputbuffer_117_0;
		eip <= bb1420;
end
bb1420:
begin
	eip <= bb1421;
end
bb1421:
begin
	eip <= bb1422;
end
bb1422:
begin
	if (i_exitcond32) begin
		i_outputbuffer_022_0_lcssa <= i_outputbuffer_022_0;
		eip <= bb1470;
	end else begin
		i_len_010_0 <= i_indvar_next31;
		i_valpred_17_0 <= i_valpred_2;
		i_index_013_0 <= i_index_2;
		i_bufferstep_014_0 <= (i_tmp121);
		i_outputbuffer_117_0 <= i_outputbuffer_022_0;
		i_step_01_0 <= i_tmp119;
		eip <= bb0;
	end
end
bb1470:
begin
	if (i_tmp121) begin
		eip <= UnifiedReturnBlock330;
	end else begin
		eip <= cond_true1520;
	end
end
cond_true1520:
begin
	mem_outdata_in0 <= i_outputbuffer_022_0_lcssa;
	mem_outdata_mode0 <= 1;
	mem_outdata_addr0 <= p_outdata;
	eip <= cond_true1521;
end
cond_true1521:
begin
	mem_outdata_mode0 <= 0;
			eip <= UnifiedReturnBlock330;
end
UnifiedReturnBlock330:
begin
	 rdy <= 1;
 return_value <= 0;
 $finish();
end
 endcase //eip
end //always @(..)

endmodule



// -- Library components --  

module mul (clk, a, b, p);
output reg [31:0] p;
input [31:0] a;
input [31:0] b;
input clk;reg [31:0] t0;
reg [31:0] t1;
reg [31:0] t2;
reg [31:0] t3;
always @(posedge clk)begin
t0 <= a * b;
t1 <= t0;
t2 <= t1;
t3 <= t2;
p <=t3;
end
endmodule


module div (clk, a, b, p);
output reg [31:0] p;
input [31:0] a;
input [31:0] b;
input clk;reg [31:0] t0;
reg [31:0] t1;
reg [31:0] t2;
reg [31:0] t3;
always @(posedge clk)begin
t0 <= a / b;
t1 <= t0;
t2 <= t1;
t3 <= t2;
p <=t3;
end
endmodule


module shl (clk, a, b, p);
output reg [31:0] p;
input [31:0] a;
input [31:0] b;
input clk;reg [31:0] t0;
reg [31:0] t1;
reg [31:0] t2;
reg [31:0] t3;
always @(posedge clk)begin
t0 <= a << b;
t1 <= t0;
t2 <= t1;
t3 <= t2;
p <=t3;
end
endmodule

// Dual port memory block
module xram (out0, din0, addr0, we0, clk0,
           out1, din1, addr1, we1, clk1);
  parameter ADDRESS_WIDTH = 16;
  parameter WORD_WIDTH = 32;
  output [WORD_WIDTH-1:0] out0;
  input [WORD_WIDTH-1:0] din0;
  input [ADDRESS_WIDTH-1:0] addr0;
  input we0;
  input clk0;
  output [WORD_WIDTH-1:0] out1;
  input [WORD_WIDTH-1:0] din1;
  input [ADDRESS_WIDTH-1:0] addr1;
  input we1;
  input clk1;
  reg [WORD_WIDTH-1:0] mem[1<<ADDRESS_WIDTH-1:0];
   integer i;
   initial begin
       for (i = 0; i < (1<<(ADDRESS_WIDTH-1)); i = i + 1) begin
       mem[i] <= i;
     end
   end
  assign out0 = mem[addr0];
  assign out1 = mem[addr1];
  always @(posedge clk0)begin
      if (we0) begin
          mem[addr0] = din0;
          $display($time,"w mem[%d] == %d; in=%d",addr0, mem[addr0],din0);
      end
  end
  always @(posedge clk1)begin
      if (we1) begin
          mem[addr1] = din1;
          $display($time,"w mem[%d] == %d; in=%d",addr0, mem[addr0],din0);
      end 
  end
endmodule

 // Test Bench 


module _Z11adpcm_coderPiS_S_S__test;
 wire rdy;
 reg reset, clk;
wire [31:0] mem_indata_out0;
wire [31:0] mem_indata_in0;
wire [15:0] mem_indata_addr0;
wire mem_indata_mode0;
wire [31:0] mem_indata_out1;
wire [31:0] mem_indata_in1;
wire [15:0] mem_indata_addr1;
wire mem_indata_mode1;
xram ram_indata (mem_indata_out0, mem_indata_in0, mem_indata_addr0, mem_indata_mode0, clk,
  mem_indata_out1, mem_indata_in1, mem_indata_addr1, mem_indata_mode1, clk);


wire [31:0] mem_indexTable_out0;
wire [31:0] mem_indexTable_in0;
wire [15:0] mem_indexTable_addr0;
wire mem_indexTable_mode0;
wire [31:0] mem_indexTable_out1;
wire [31:0] mem_indexTable_in1;
wire [15:0] mem_indexTable_addr1;
wire mem_indexTable_mode1;
xram ram_indexTable (mem_indexTable_out0, mem_indexTable_in0, mem_indexTable_addr0, mem_indexTable_mode0, clk,
  mem_indexTable_out1, mem_indexTable_in1, mem_indexTable_addr1, mem_indexTable_mode1, clk);


wire [31:0] mem_outdata_out0;
wire [31:0] mem_outdata_in0;
wire [15:0] mem_outdata_addr0;
wire mem_outdata_mode0;
wire [31:0] mem_outdata_out1;
wire [31:0] mem_outdata_in1;
wire [15:0] mem_outdata_addr1;
wire mem_outdata_mode1;
xram ram_outdata (mem_outdata_out0, mem_outdata_in0, mem_outdata_addr0, mem_outdata_mode0, clk,
  mem_outdata_out1, mem_outdata_in1, mem_outdata_addr1, mem_outdata_mode1, clk);


wire [31:0] mem_stepSizeTable_out0;
wire [31:0] mem_stepSizeTable_in0;
wire [15:0] mem_stepSizeTable_addr0;
wire mem_stepSizeTable_mode0;
wire [31:0] mem_stepSizeTable_out1;
wire [31:0] mem_stepSizeTable_in1;
wire [15:0] mem_stepSizeTable_addr1;
wire mem_stepSizeTable_mode1;
xram ram_stepSizeTable (mem_stepSizeTable_out0, mem_stepSizeTable_in0, mem_stepSizeTable_addr0, mem_stepSizeTable_mode0, clk,
  mem_stepSizeTable_out1, mem_stepSizeTable_in1, mem_stepSizeTable_addr1, mem_stepSizeTable_mode1, clk);


 always #5 clk = ~clk;
 reg [15:0] p_indata;
 reg [15:0] p_outdata;
 reg [15:0] p_indexTable;
 reg [15:0] p_stepSizeTable;
 wire return_value;
_Z11adpcm_coderPiS_S_S_ instance1 (clk, reset, rdy,// control 
	mem_indata_out0, mem_indata_in0, mem_indata_addr0, mem_indata_mode0, // memport for: indata 
	mem_indexTable_out0, mem_indexTable_in0, mem_indexTable_addr0, mem_indexTable_mode0, // memport for: indexTable 
	mem_outdata_out0, mem_outdata_in0, mem_outdata_addr0, mem_outdata_mode0, // memport for: outdata 
	mem_stepSizeTable_out0, mem_stepSizeTable_in0, mem_stepSizeTable_addr0, mem_stepSizeTable_mode0, // memport for: stepSizeTable 
	p_indata, p_outdata, p_indexTable, p_stepSizeTable, return_value); // params 
initial begin
 clk = 0;
 $monitor("return = %b, 0x%x", rdy,  return_value);

 // Configure the values below to test the module
 p_indata <= 0;
 p_outdata <= 0;
 p_indexTable <= 0;
 p_stepSizeTable <= 0;
 #5 reset = 1; #5 reset = 0;
end

endmodule //main_test 
