
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


module _Z7dotprodPiS_  (clk, reset, rdy,// control 
	mem_a_out0, mem_a_in0, mem_a_addr0, mem_a_mode0, // memport for: a 
	mem_b_out0, mem_b_in0, mem_b_addr0, mem_b_mode0, // memport for: b 
	p_a, p_b, return_value); // params 
 input wire clk;
 input wire reset;
 output rdy;
 reg rdy;
 output [31:0] return_value;
 reg [31:0] return_value;
 input [15:0] p_a;
 input [15:0] p_b;
input wire [31:0] mem_a_out0;
output reg [31:0] mem_a_in0;
output reg [15:0] mem_a_addr0;
output reg mem_a_mode0;
input wire [31:0] mem_b_out0;
output reg [31:0] mem_b_in0;
output reg [15:0] mem_b_addr0;
output reg mem_b_mode0;


 reg [31:0] i_incrementVal;   /*local var*/
 reg [31:0] i_incrementVal72;   /*local var*/
 reg [31:0] i_incrementVal61;   /*local var*/
 reg [31:0] i_cloned___0___;   /*local var*/
 reg [31:0] i_cloned___1___;   /*local var*/
 reg [31:0] i_tmp4____1___;   /*local var*/
 reg [31:0] i_tmp8____1___;   /*local var*/
 reg i_exitcond10___0___;   /*local var*/
 reg [31:0] ltmp_0_1;   /*local var*/
 reg [31:0] i_tmp11____1___;   /*local var*/
 reg [31:0] i_tmp11;   /*local var*/
 reg [31:0] i_incrementVal88;   /*local var*/
 reg [31:0] i_indvar_next9;   /*local var*/
 reg i_exitcond10;   /*local var*/
 reg [31:0] i_tmp4;   /*local var*/
 reg [31:0] i_tmp8;   /*local var*/
 reg [31:0] i_cloned;   /*local var*/
 reg [31:0] ltmp_1_1;   /*local var*/
 reg i_gluePipelinedLoop90;   /*phi var*/
 reg [31:0] i_gluePipelinedLoop89;   /*phi var*/
 reg [31:0] i_gluePipelinedLoop87;   /*phi var*/
 reg [31:0] i_gluePipelinedLoop86;   /*phi var*/
 reg [31:0] i_gluePipelinedLoop85;   /*phi var*/
 reg [15:0] p_gluePipelinedLoop84;   /*phi var*/
 reg [31:0] i_gluePipelinedLoop83;   /*phi var*/
 reg [15:0] p_gluePipelinedLoop;   /*phi var*/
 reg [31:0] i_i_01_0;   /*phi var*/
 reg [31:0] i_sum_05_0;   /*phi var*/
 reg [31:0] i_tmp11_lcssa;   /*phi var*/

 // Number of states:19
 reg [4:0] eip;
 parameter entry0 = 5'd0;
 parameter entry1 = 5'd1;
 parameter entry2 = 5'd2;
 parameter entry3 = 5'd3;
 parameter entry4 = 5'd4;
 parameter entry5 = 5'd5;
 parameter entry6 = 5'd6;
 parameter entry7 = 5'd7;
 parameter entry8 = 5'd8;
 parameter entry9 = 5'd9;
 parameter entry10 = 5'd10;
 parameter PipelinedLoop0 = 5'd11;
 parameter PipelinedLoop1 = 5'd12;
 parameter PipelinedLoop2 = 5'd13;
 parameter PipelinedLoop3 = 5'd14;
 parameter PipelinedLoop4 = 5'd15;
 parameter PipelinedLoop5 = 5'd16;
 parameter PipelinedLoop6 = 5'd17;
 parameter bb180 = 5'd18;

// Assign part (2)
wire [31:0] mul0_in_a;
wire [31:0] mul0_in_b;
 assign mul0_in_a = 
 (eip == PipelinedLoop0) ? i_gluePipelinedLoop85 :
 (eip == entry3) ? i_tmp8____1___ :0;
 assign mul0_in_b = 
 (eip == PipelinedLoop0) ? i_gluePipelinedLoop83 :
 (eip == entry3) ? i_tmp4____1___ :0;

wire [31:0] out_mul0;
mul  mul0_instance (.clk(clk), .a(mul0_in_a), .b(mul0_in_b), .p(out_mul0));



always @(posedge clk)
 begin
  if (reset)
   begin
    $display("@hard reset");
    eip<=0;
    rdy<=0;
   end


// Datapath 
i_incrementVal <= (-1)+(0);
i_incrementVal72 <= (0)+(0);
i_incrementVal61 <= (1)+(0);
i_cloned___0___ <= i_incrementVal72+(1);
i_cloned___1___ <= i_incrementVal61+(1);
i_exitcond10___0___ <= (i_cloned___0___ == (1024));
i_tmp11____1___ <= ltmp_0_1+(0);
i_tmp11 <= i_gluePipelinedLoop86+i_sum_05_0;
i_incrementVal88 <= (2)+i_i_01_0;
i_indvar_next9 <= i_i_01_0+(1);
i_exitcond10 <= (i_gluePipelinedLoop89 == (1024));
i_cloned <= i_incrementVal88+(1);


// Control 
case (eip)
entry0:
begin
	eip <= entry1;
end
entry1:
begin
	mem_a_mode0 <= 0;
	mem_a_addr0 <= (p_a + i_incrementVal);
	mem_b_mode0 <= 0;
	mem_b_addr0 <= (p_b + i_incrementVal);
	eip <= entry2;
end
entry2:
begin
	i_tmp4____1___ <= mem_a_out0;
	i_tmp8____1___ <= mem_b_out0;
	eip <= entry3;
end
entry3:
begin
	eip <= entry4;
end
entry4:
begin
	eip <= entry5;
end
entry5:
begin
	eip <= entry6;
end
entry6:
begin
	eip <= entry7;
end
entry7:
begin
	eip <= entry8;
end
entry8:
begin
	ltmp_0_1 <= out_mul0;
	eip <= entry9;
end
entry9:
begin
	eip <= entry10;
end
entry10:
begin
			i_gluePipelinedLoop90 <= i_exitcond10___0___;
		i_gluePipelinedLoop89 <= i_cloned___1___;
		i_gluePipelinedLoop87 <= i_tmp11____1___;
		i_gluePipelinedLoop86 <= ltmp_0_1;
		i_gluePipelinedLoop85 <= i_tmp8____1___;
		p_gluePipelinedLoop84 <= (p_b + i_incrementVal);
		i_gluePipelinedLoop83 <= i_tmp4____1___;
		p_gluePipelinedLoop <= (p_a + i_incrementVal);
		i_i_01_0 <= (0);
		i_sum_05_0 <= (0);
		eip <= PipelinedLoop0;
end
PipelinedLoop0:
begin
	mem_a_mode0 <= 0;
	mem_a_addr0 <= p_gluePipelinedLoop;
	mem_b_mode0 <= 0;
	mem_b_addr0 <= p_gluePipelinedLoop84;
	eip <= PipelinedLoop1;
end
PipelinedLoop1:
begin
	i_tmp4 <= mem_a_out0;
	i_tmp8 <= mem_b_out0;
	eip <= PipelinedLoop2;
end
PipelinedLoop2:
begin
	eip <= PipelinedLoop3;
end
PipelinedLoop3:
begin
	eip <= PipelinedLoop4;
end
PipelinedLoop4:
begin
	eip <= PipelinedLoop5;
end
PipelinedLoop5:
begin
	ltmp_1_1 <= out_mul0;
	eip <= PipelinedLoop6;
end
PipelinedLoop6:
begin
	if (i_gluePipelinedLoop90) begin
		i_tmp11_lcssa <= i_gluePipelinedLoop87;
		eip <= bb180;
	end else begin
		i_gluePipelinedLoop90 <= i_exitcond10;
		i_gluePipelinedLoop89 <= i_cloned;
		i_gluePipelinedLoop87 <= i_tmp11;
		i_gluePipelinedLoop86 <= ltmp_1_1;
		i_gluePipelinedLoop85 <= i_tmp8;
		p_gluePipelinedLoop84 <= (p_b + i_i_01_0);
		i_gluePipelinedLoop83 <= i_tmp4;
		p_gluePipelinedLoop <= (p_a + i_i_01_0);
		i_i_01_0 <= i_indvar_next9;
		i_sum_05_0 <= i_gluePipelinedLoop87;
		eip <= PipelinedLoop0;
	end
end
bb180:
begin
	 rdy <= 1;
 return_value <= i_tmp11_lcssa;
 $display($time, " Return (0x%x) ",i_tmp11_lcssa);
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


module _Z7dotprodPiS__test;
 wire rdy;
 reg reset, clk;
wire [31:0] mem_a_out0;
wire [31:0] mem_a_in0;
wire [15:0] mem_a_addr0;
wire mem_a_mode0;
wire [31:0] mem_a_out1;
wire [31:0] mem_a_in1;
wire [15:0] mem_a_addr1;
wire mem_a_mode1;
xram ram_a (mem_a_out0, mem_a_in0, mem_a_addr0, mem_a_mode0, clk,
  mem_a_out1, mem_a_in1, mem_a_addr1, mem_a_mode1, clk);


wire [31:0] mem_b_out0;
wire [31:0] mem_b_in0;
wire [15:0] mem_b_addr0;
wire mem_b_mode0;
wire [31:0] mem_b_out1;
wire [31:0] mem_b_in1;
wire [15:0] mem_b_addr1;
wire mem_b_mode1;
xram ram_b (mem_b_out0, mem_b_in0, mem_b_addr0, mem_b_mode0, clk,
  mem_b_out1, mem_b_in1, mem_b_addr1, mem_b_mode1, clk);


 always #5 clk = ~clk;
 reg [15:0] p_a;
 reg [15:0] p_b;
 wire [31:0] return_value;
_Z7dotprodPiS_ instance1 (clk, reset, rdy,// control 
	mem_a_out0, mem_a_in0, mem_a_addr0, mem_a_mode0, // memport for: a 
	mem_b_out0, mem_b_in0, mem_b_addr0, mem_b_mode0, // memport for: b 
	p_a, p_b, return_value); // params 
initial begin
 clk = 0;
 $monitor("return = %b, 0x%x", rdy,  return_value);

 // Configure the values below to test the module
 p_a <= 0;
 p_b <= 0;
 #5 reset = 1; #5 reset = 0;
end

endmodule //main_test 
