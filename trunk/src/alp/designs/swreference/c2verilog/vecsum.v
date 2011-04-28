
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


module _Z7vec_sumPjS_S_  (clk, reset, rdy,// control 
	mem_v_out0, mem_v_in0, mem_v_addr0, mem_v_mode0, // memport for: v 
	mem_x_out0, mem_x_in0, mem_x_addr0, mem_x_mode0, // memport for: x 
	mem_z_out0, mem_z_in0, mem_z_addr0, mem_z_mode0, // memport for: z 
	p_v, p_x, p_z, return_value); // params 
 input wire clk;
 input wire reset;
 output rdy;
 reg rdy;
 output return_value;
 reg return_value;
 input [15:0] p_v;
 input [15:0] p_x;
 input [15:0] p_z;
input wire [31:0] mem_v_out0;
output reg [31:0] mem_v_in0;
output reg [15:0] mem_v_addr0;
output reg mem_v_mode0;
input wire [31:0] mem_x_out0;
output reg [31:0] mem_x_in0;
output reg [15:0] mem_x_addr0;
output reg mem_x_mode0;
input wire [31:0] mem_z_out0;
output reg [31:0] mem_z_in0;
output reg [15:0] mem_z_addr0;
output reg mem_z_mode0;


 reg [31:0] i_incrementVal31;   /*local var*/
 reg [31:0] i_incrementVal10;   /*local var*/
 reg [31:0] i_incrementVal;   /*local var*/
 reg [31:0] i_cloned___0___;   /*local var*/
 reg [31:0] i_cloned___1___;   /*local var*/
 reg [31:0] i_tmp3___0___;   /*local var*/
 reg [31:0] i_tmp7___0___;   /*local var*/
 reg i_exitcond9___0___;   /*local var*/
 reg [31:0] i_tmp3___1___;   /*local var*/
 reg [31:0] i_tmp7___1___;   /*local var*/
 reg [31:0] i_tmp8___0___;   /*local var*/
 reg [31:0] i_incrementVal83;   /*local var*/
 reg [31:0] i_tmp8;   /*local var*/
 reg [31:0] i_incrementVal89;   /*local var*/
 reg [31:0] i_incrementVal91;   /*local var*/
 reg [31:0] i_indvar_next8;   /*local var*/
 reg i_exitcond9;   /*local var*/
 reg [31:0] i_tmp3;   /*local var*/
 reg [31:0] i_tmp7;   /*local var*/
 reg [31:0] i_cloned;   /*local var*/
 reg i_gluePipelinedLoop93;   /*phi var*/
 reg [31:0] i_gluePipelinedLoop92;   /*phi var*/
 reg [15:0] p_gluePipelinedLoop90;   /*phi var*/
 reg [31:0] i_gluePipelinedLoop88;   /*phi var*/
 reg [31:0] i_gluePipelinedLoop87;   /*phi var*/
 reg [15:0] p_gluePipelinedLoop86;   /*phi var*/
 reg [31:0] i_gluePipelinedLoop84;   /*phi var*/
 reg [15:0] p_gluePipelinedLoop;   /*phi var*/
 reg [31:0] i_i_01_0;   /*phi var*/

 // Number of states:9
 reg [3:0] eip;
 parameter entry0 = 4'd0;
 parameter entry1 = 4'd1;
 parameter entry2 = 4'd2;
 parameter entry3 = 4'd3;
 parameter entry4 = 4'd4;
 parameter PipelinedLoop0 = 4'd5;
 parameter PipelinedLoop1 = 4'd6;
 parameter PipelinedLoop2 = 4'd7;
 parameter return0 = 4'd8;

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
i_incrementVal31 <= (0)+(0);
i_incrementVal10 <= (1)+(0);
i_incrementVal <= (2)+(0);
i_cloned___0___ <= i_incrementVal31+(1);
i_cloned___1___ <= i_incrementVal10+(1);
i_exitcond9___0___ <= (i_cloned___0___ == (2048));
i_tmp8___0___ <= i_tmp7___0___+i_tmp3___0___;
i_incrementVal83 <= (3)+i_i_01_0;
i_tmp8 <= i_gluePipelinedLoop87+i_gluePipelinedLoop84;
i_incrementVal89 <= (1)+i_i_01_0;
i_incrementVal91 <= (2)+i_i_01_0;
i_indvar_next8 <= i_i_01_0+(1);
i_exitcond9 <= (i_gluePipelinedLoop92 == (2048));
i_cloned <= i_incrementVal91+(1);


// Control 
case (eip)
entry0:
begin
	eip <= entry1;
end
entry1:
begin
	mem_v_mode0 <= 0;
	mem_v_addr0 <= (p_v + i_incrementVal31);
	mem_x_mode0 <= 0;
	mem_x_addr0 <= (p_x + i_incrementVal31);
	eip <= entry2;
end
entry2:
begin
	i_tmp3___0___ <= mem_v_out0;
	mem_v_mode0 <= 0;
	mem_v_addr0 <= (p_v + i_incrementVal10);
	i_tmp7___0___ <= mem_x_out0;
	mem_x_mode0 <= 0;
	mem_x_addr0 <= (p_x + i_incrementVal10);
	eip <= entry3;
end
entry3:
begin
	i_tmp3___1___ <= mem_v_out0;
	i_tmp7___1___ <= mem_x_out0;
	eip <= entry4;
end
entry4:
begin
			i_gluePipelinedLoop93 <= i_exitcond9___0___;
		i_gluePipelinedLoop92 <= i_cloned___1___;
		p_gluePipelinedLoop90 <= (p_z + i_incrementVal31);
		i_gluePipelinedLoop88 <= i_tmp8___0___;
		i_gluePipelinedLoop87 <= i_tmp7___1___;
		p_gluePipelinedLoop86 <= (p_x + i_incrementVal);
		i_gluePipelinedLoop84 <= i_tmp3___1___;
		p_gluePipelinedLoop <= (p_v + i_incrementVal);
		i_i_01_0 <= (0);
		eip <= PipelinedLoop0;
end
PipelinedLoop0:
begin
	mem_v_mode0 <= 0;
	mem_v_addr0 <= p_gluePipelinedLoop;
	mem_x_mode0 <= 0;
	mem_x_addr0 <= p_gluePipelinedLoop86;
	mem_z_in0 <= i_gluePipelinedLoop88;
	mem_z_mode0 <= 1;
	mem_z_addr0 <= p_gluePipelinedLoop90;
	eip <= PipelinedLoop1;
end
PipelinedLoop1:
begin
	i_tmp3 <= mem_v_out0;
	i_tmp7 <= mem_x_out0;
	mem_z_mode0 <= 0;
	eip <= PipelinedLoop2;
end
PipelinedLoop2:
begin
	if (i_gluePipelinedLoop93) begin
		eip <= return0;
	end else begin
		i_gluePipelinedLoop93 <= i_exitcond9;
		i_gluePipelinedLoop92 <= i_cloned;
		p_gluePipelinedLoop90 <= (p_z + i_incrementVal89);
		i_gluePipelinedLoop88 <= i_tmp8;
		i_gluePipelinedLoop87 <= i_tmp7;
		p_gluePipelinedLoop86 <= (p_x + i_incrementVal83);
		i_gluePipelinedLoop84 <= i_tmp3;
		p_gluePipelinedLoop <= (p_v + i_incrementVal83);
		i_i_01_0 <= i_indvar_next8;
		eip <= PipelinedLoop0;
	end
end
return0:
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


module _Z7vec_sumPjS_S__test;
 wire rdy;
 reg reset, clk;
wire [31:0] mem_v_out0;
wire [31:0] mem_v_in0;
wire [15:0] mem_v_addr0;
wire mem_v_mode0;
wire [31:0] mem_v_out1;
wire [31:0] mem_v_in1;
wire [15:0] mem_v_addr1;
wire mem_v_mode1;
xram ram_v (mem_v_out0, mem_v_in0, mem_v_addr0, mem_v_mode0, clk,
  mem_v_out1, mem_v_in1, mem_v_addr1, mem_v_mode1, clk);


wire [31:0] mem_x_out0;
wire [31:0] mem_x_in0;
wire [15:0] mem_x_addr0;
wire mem_x_mode0;
wire [31:0] mem_x_out1;
wire [31:0] mem_x_in1;
wire [15:0] mem_x_addr1;
wire mem_x_mode1;
xram ram_x (mem_x_out0, mem_x_in0, mem_x_addr0, mem_x_mode0, clk,
  mem_x_out1, mem_x_in1, mem_x_addr1, mem_x_mode1, clk);


wire [31:0] mem_z_out0;
wire [31:0] mem_z_in0;
wire [15:0] mem_z_addr0;
wire mem_z_mode0;
wire [31:0] mem_z_out1;
wire [31:0] mem_z_in1;
wire [15:0] mem_z_addr1;
wire mem_z_mode1;
xram ram_z (mem_z_out0, mem_z_in0, mem_z_addr0, mem_z_mode0, clk,
  mem_z_out1, mem_z_in1, mem_z_addr1, mem_z_mode1, clk);


 always #5 clk = ~clk;
 reg [15:0] p_v;
 reg [15:0] p_x;
 reg [15:0] p_z;
 wire return_value;
_Z7vec_sumPjS_S_ instance1 (clk, reset, rdy,// control 
	mem_v_out0, mem_v_in0, mem_v_addr0, mem_v_mode0, // memport for: v 
	mem_x_out0, mem_x_in0, mem_x_addr0, mem_x_mode0, // memport for: x 
	mem_z_out0, mem_z_in0, mem_z_addr0, mem_z_mode0, // memport for: z 
	p_v, p_x, p_z, return_value); // params 
initial begin
 clk = 0;
 $monitor("return = %b, 0x%x", rdy,  return_value);

 // Configure the values below to test the module
 p_v <= 0;
 p_x <= 0;
 p_z <= 0;
 #5 reset = 1; #5 reset = 0;
end

endmodule //main_test 
