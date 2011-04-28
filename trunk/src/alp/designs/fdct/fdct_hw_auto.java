/* Copyright (c) 2009 Ricardo Menotti, All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its 
 * documentation for NON-COMERCIAL purposes and without fee is hereby granted 
 * provided that this copyright notice appears in all copies.
 *
 * RICARDO MENOTTI MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY
 * OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR 
 * NON-INFRINGEMENT. RICARDO MENOTTI SHALL NOT BE LIABLE FOR ANY DAMAGES 
 * SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS 
 * SOFTWARE OR ITS DERIVATIVES. 
 */

package alp.designs.fdct;

import alp.components.add_op_s;
import alp.components.add_reg_op_s;
import alp.components.block_ram;
import alp.components.const_op;
import alp.components.delay_op;
import alp.components.delay_step_op;
import alp.components.input;
import alp.components.module_for;
import alp.components.mult_op_s;
import alp.components.mux_m_op;
import alp.components.mux_op;
import alp.components.not_op;
import alp.components.output;
import alp.components.reg_op;
import alp.components.shr_c_op;
import alp.components.sub_reg_op_s;
import alp.core.Design;
import alp.core.Parameters;

/**
 * The FDCT example
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version October, 2008
 * @deprecated
 */
public class fdct_hw_auto extends Design {
	final static int N = 8;
	final static int M = N*N;
//	final static int num_fdcts = 7500; // SIZE = 480.000
	final static int num_fdcts = 10; // SIZE = 640
	final static int SIZE = num_fdcts*M;
	public fdct_hw_auto() {
		super("fdct_auto");
		Parameters.setDefaultDataWidth(16);
//		Parameters.setDefaultAddressWidth(19); // 2**19 = 524.288 
		Parameters.setDefaultAddressWidth(10); // 2**10 = 1.024 >= SIZE
		// BEGIN: memory initialization
		int[] sw_dct_io_ptr = new int[(int)Math.pow(2, Parameters.getDefaultAddressWidth())];
		for (int i=0; i<SIZE; i++)
			sw_dct_io_ptr[i] = (short)(i-64);
		// END: memory initialization
		// input/output pins
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		output done = (output)this.addComponent(new output("done"));
		output output = (output)this.addComponent(new output("output", true));
		// memories
		block_ram dct_io_ptr = (block_ram)this.addComponent(new block_ram("dct_io_ptr", Parameters.getDefaultAddressWidth(), Parameters.getDefaultDataWidth()));
		dct_io_ptr.setInitialValue(sw_dct_io_ptr);
		block_ram dct_io_tmp = (block_ram)this.addComponent(new block_ram("dct_io_tmp", Parameters.getDefaultAddressWidth(), Parameters.getDefaultDataWidth()));
		block_ram dct_o = (block_ram)this.addComponent(new block_ram("dct_o", Parameters.getDefaultAddressWidth(), Parameters.getDefaultDataWidth()));
		//second part of FDCT
		// iterators
		module_for for_i = (module_for)this.addComponent(new module_for("for_i", Parameters.getDefaultAddressWidth(), num_fdcts, N*N));
		module_for for_j = (module_for)this.addComponent(new module_for("for_j", Parameters.getDefaultAddressWidth(), N, N));
		// cosine coefficients
		const_op c0 = (const_op)this.addComponent(new const_op("c0", 0xB505, 32));
		const_op c1 = (const_op)this.addComponent(new const_op("c1", 0x2C62, 32)); 
		const_op c2 = (const_op)this.addComponent(new const_op("c2", 0x29CF, 32));                  
		const_op c3 = (const_op)this.addComponent(new const_op("c3", 0x25A0, 32));
		const_op c5 = (const_op)this.addComponent(new const_op("c5", 0x1924, 32));
		const_op c6 = (const_op)this.addComponent(new const_op("c6", 0x1151, 32));      
		const_op c7 = (const_op)this.addComponent(new const_op("c6", 0x08D4, 32));                  
		// registers
		add_reg_op_s i1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("i1", Parameters.getDefaultAddressWidth()));
		add_reg_op_s j1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("j1", Parameters.getDefaultAddressWidth()));
		add_reg_op_s i_1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("i_1", Parameters.getDefaultAddressWidth()));
		reg_op f0 = (reg_op)this.addComponent(new reg_op("f0"));
		reg_op f1 = (reg_op)this.addComponent(new reg_op("f1"));
		reg_op f2 = (reg_op)this.addComponent(new reg_op("f2"));
		reg_op f3 = (reg_op)this.addComponent(new reg_op("f3"));
		reg_op f4 = (reg_op)this.addComponent(new reg_op("f4"));
		reg_op f5 = (reg_op)this.addComponent(new reg_op("f5"));
		reg_op f6 = (reg_op)this.addComponent(new reg_op("f6"));
		reg_op f7 = (reg_op)this.addComponent(new reg_op("f7"));
		add_reg_op_s g0 = (add_reg_op_s)this.addComponent(new add_reg_op_s("g0"));
		add_reg_op_s g1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("g1"));
		add_reg_op_s h0 = (add_reg_op_s)this.addComponent(new add_reg_op_s("h0"));
		add_reg_op_s h1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("h1"));
		add_reg_op_s p0 = (add_reg_op_s)this.addComponent(new add_reg_op_s("p0"));
		add_reg_op_s p1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("p1"));
		sub_reg_op_s r0 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("r0"));
		sub_reg_op_s r1 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("r1"));
		add_reg_op_s P_0 = (add_reg_op_s)this.addComponent(new add_reg_op_s("P_0"));
		sub_reg_op_s P_1 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("P_1"));
		sub_reg_op_s R_0 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("R_0"));
		add_reg_op_s R_1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("R_1"));
		sub_reg_op_s g2 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("g2"));
		sub_reg_op_s g3 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("g3"));
		sub_reg_op_s h2 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("h2"));
		sub_reg_op_s h3 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("h3"));
		sub_reg_op_s q0a = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("q0a"));
		add_reg_op_s s0a = (add_reg_op_s)this.addComponent(new add_reg_op_s("s0a"));
		sub_reg_op_s Q_0 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("Q_0"));
		add_reg_op_s Q_1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("Q_1"));
		sub_reg_op_s S_0 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("S_0"));
		add_reg_op_s S_1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("S_1"));
		reg_op q0 = (reg_op)this.addComponent(new reg_op("q0"));
		reg_op q1 = (reg_op)this.addComponent(new reg_op("q1"));
		reg_op s0 = (reg_op)this.addComponent(new reg_op("ss0"));
		reg_op s1 = (reg_op)this.addComponent(new reg_op("ss1"));
		reg_op F_0 = (reg_op)this.addComponent(new reg_op("F_0", 32));
		add_reg_op_s F_1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("F_1", 32));
		reg_op F_2 = (reg_op)this.addComponent(new reg_op("F_2", 32));
		sub_reg_op_s F_3 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("F_3", 32));
		reg_op F_4 = (reg_op)this.addComponent(new reg_op("F_4", 32));
		add_reg_op_s F_5 = (add_reg_op_s)this.addComponent(new add_reg_op_s("F_5", 32));
		reg_op F_6 = (reg_op)this.addComponent(new reg_op("F_6", 32));
		sub_reg_op_s F_7 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("F_7", 32));
		// arith
		mult_op_s s0aMultC0 = (mult_op_s)this.addComponent(new mult_op_s("s0aMultC0", 32)); 
		mult_op_s q0aMultC0 = (mult_op_s)this.addComponent(new mult_op_s("q0aMultC0", 32)); 
		add_op_s s0aMultC0Plus0x7fff = (add_op_s)this.addComponent(new add_op_s("s0aMultC0Plus0x7fff", 32)); 
		add_op_s q0aMultC0Plus0x7fff = (add_op_s)this.addComponent(new add_op_s("q0aMultC0Plus0x7fff", 32));
		shr_c_op s0aMultC0Plus0x7fffShr16 = (shr_c_op)this.addComponent(new shr_c_op("s0aMultC0Plus0x7fffShr16", 16, 32));
		shr_c_op q0aMultC0Plus0x7fffShr16 = (shr_c_op)this.addComponent(new shr_c_op("q0aMultC0Plus0x7fffShr16", 16, 32));

		mult_op_s c6MultR1 = (mult_op_s)this.addComponent(new mult_op_s("c6MultR1", 32));
		mult_op_s c2MultR0 = (mult_op_s)this.addComponent(new mult_op_s("c2MultR0", 32));
		mult_op_s c6MultR0 = (mult_op_s)this.addComponent(new mult_op_s("c6MultR0", 32));
		mult_op_s c2MultR1 = (mult_op_s)this.addComponent(new mult_op_s("c2MultR1", 32));
		
		mult_op_s c7MultQ1 = (mult_op_s)this.addComponent(new mult_op_s("c7MultQ1", 32));
		mult_op_s c1MultS1 = (mult_op_s)this.addComponent(new mult_op_s("c1MultS1", 32));
		mult_op_s c7MultS1 = (mult_op_s)this.addComponent(new mult_op_s("c7MultS1", 32));
		mult_op_s c1MultQ1 = (mult_op_s)this.addComponent(new mult_op_s("c1MultQ1", 32));
		mult_op_s c3MultQ0 = (mult_op_s)this.addComponent(new mult_op_s("c3MultQ0", 32));
		mult_op_s c5MultS0 = (mult_op_s)this.addComponent(new mult_op_s("c5MultS0", 32));
		mult_op_s c3MultS0 = (mult_op_s)this.addComponent(new mult_op_s("c3MultS0", 32));
		mult_op_s c5MultQ0 = (mult_op_s)this.addComponent(new mult_op_s("c5MultQ0", 32));

		shr_c_op F_1Shr13 = (shr_c_op)this.addComponent(new shr_c_op("F_1Shr13", 13, 32));
		shr_c_op F_2Shr13 = (shr_c_op)this.addComponent(new shr_c_op("F_2Shr13", 13, 32));
		shr_c_op F_3Shr13 = (shr_c_op)this.addComponent(new shr_c_op("F_3Shr13", 13, 32));
		shr_c_op F_5Shr13 = (shr_c_op)this.addComponent(new shr_c_op("F_5Shr13", 13, 32));
		shr_c_op F_6Shr13 = (shr_c_op)this.addComponent(new shr_c_op("F_6Shr13", 13, 32));
		shr_c_op F_7Shr13 = (shr_c_op)this.addComponent(new shr_c_op("F_7Shr13", 13, 32));
		
		mux_op mj1 = (mux_op)this.addComponent(new mux_op("mj1", Parameters.getDefaultAddressWidth()));
		mux_op mi_1 = (mux_op)this.addComponent(new mux_op("mi_1", Parameters.getDefaultAddressWidth()));
		mux_op m_tmp = (mux_op)this.addComponent(new mux_op("m_tmp", Parameters.getDefaultAddressWidth()));
		mux_m_op mf = (mux_m_op)this.addComponent(new mux_m_op("mf", Parameters.getDefaultDataWidth()*2, 8, 7));
		
		delay_op init2 = (delay_op)this.addComponent(new delay_op("init2", 1, 2));
		
		delay_step_op for_j_step16delay8 = (delay_step_op)this.addComponent(new delay_step_op("for_j_step16delay8", 8));
		
		not_op for_i_step2Not = (not_op)this.addComponent(new not_op("for_i_step2Not", 1));
		not_op for_j_step1Not = (not_op)this.addComponent(new not_op("for_j_step1Not", 1));
		
		//second part of FDCT 
		// iterators
		module_for xfor_i = (module_for)this.addComponent(new module_for("xfor_i", Parameters.getDefaultAddressWidth(), num_fdcts*N*N));
		module_for xi_1 = (module_for)this.addComponent(new module_for("xi_1", Parameters.getDefaultAddressWidth(), num_fdcts*N, N));
		// registers
		reg_op xf0 = (reg_op)this.addComponent(new reg_op("xf0"));
		reg_op xf1 = (reg_op)this.addComponent(new reg_op("xf1"));
		reg_op xf2 = (reg_op)this.addComponent(new reg_op("xf2"));
		reg_op xf3 = (reg_op)this.addComponent(new reg_op("xf3"));
		reg_op xf4 = (reg_op)this.addComponent(new reg_op("xf4"));
		reg_op xf5 = (reg_op)this.addComponent(new reg_op("xf5"));
		reg_op xf6 = (reg_op)this.addComponent(new reg_op("xf6"));
		reg_op xf7 = (reg_op)this.addComponent(new reg_op("xf7"));
		add_reg_op_s xg0 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xg0"));
		add_reg_op_s xg1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xg1"));
		add_reg_op_s xh0 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xh0"));
		add_reg_op_s xh1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xh1"));
		add_reg_op_s xp0 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xp0"));
		add_reg_op_s xp1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xp1"));
		sub_reg_op_s xr0 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xr0"));
		sub_reg_op_s xr1 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xr1"));
		add_reg_op_s xP_0 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xP_0"));
		sub_reg_op_s xP_1 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xP_1"));
		sub_reg_op_s xR_0 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xR_0"));
		add_reg_op_s xR_1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xR_1"));
		sub_reg_op_s xg2 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xg2"));
		sub_reg_op_s xg3 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xg3"));
		sub_reg_op_s xh2 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xh2"));
		sub_reg_op_s xh3 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xh3"));
		sub_reg_op_s xq0a = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xq0a"));
		add_reg_op_s xs0a = (add_reg_op_s)this.addComponent(new add_reg_op_s("xs0a"));
		sub_reg_op_s xQ_0 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xQ_0"));
		add_reg_op_s xQ_1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xQ_1"));
		sub_reg_op_s xS_0 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xS_0"));
		add_reg_op_s xS_1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xS_1"));
		reg_op xq0 = (reg_op)this.addComponent(new reg_op("xq0"));
		reg_op xq1 = (reg_op)this.addComponent(new reg_op("xq1"));
		reg_op xs0 = (reg_op)this.addComponent(new reg_op("xss0"));
		reg_op xs1 = (reg_op)this.addComponent(new reg_op("xss1"));
		reg_op xF_0 = (reg_op)this.addComponent(new reg_op("xF_0", 32));
		add_reg_op_s xF_1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xF_1", 32));
		reg_op xF_2 = (reg_op)this.addComponent(new reg_op("xF_2", 32));
		sub_reg_op_s xF_3 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xF_3", 32));
		reg_op xF_4 = (reg_op)this.addComponent(new reg_op("xF_4", 32));
		add_reg_op_s xF_5 = (add_reg_op_s)this.addComponent(new add_reg_op_s("xF_5", 32));
		reg_op xF_6 = (reg_op)this.addComponent(new reg_op("xF_6", 32));
		sub_reg_op_s xF_7 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("xF_7", 32));

		add_reg_op_s xF0r = (add_reg_op_s)this.addComponent(new add_reg_op_s("xF0r", 32));
		add_reg_op_s xF1r = (add_reg_op_s)this.addComponent(new add_reg_op_s("xF1r", 32));
		add_reg_op_s xF2r = (add_reg_op_s)this.addComponent(new add_reg_op_s("xF2r", 32));
		add_reg_op_s xF3r = (add_reg_op_s)this.addComponent(new add_reg_op_s("xF3r", 32));
		add_reg_op_s xF4r = (add_reg_op_s)this.addComponent(new add_reg_op_s("xF4r", 32));
		add_reg_op_s xF5r = (add_reg_op_s)this.addComponent(new add_reg_op_s("xF5r", 32));
		add_reg_op_s xF6r = (add_reg_op_s)this.addComponent(new add_reg_op_s("xF6r", 32));
		add_reg_op_s xF7r = (add_reg_op_s)this.addComponent(new add_reg_op_s("xF7r", 32));
		
		// arith
		mult_op_s xs0aMultC0 = (mult_op_s)this.addComponent(new mult_op_s("xs0aMultC0", 32)); 
		mult_op_s xq0aMultC0 = (mult_op_s)this.addComponent(new mult_op_s("xq0aMultC0", 32)); 
		add_op_s xs0aMultC0Plus0x7fff = (add_op_s)this.addComponent(new add_op_s("xs0aMultC0Plus0x7fff", 32)); 
		add_op_s xq0aMultC0Plus0x7fff = (add_op_s)this.addComponent(new add_op_s("xq0aMultC0Plus0x7fff", 32));
		shr_c_op xs0aMultC0Plus0x7fffShr16 = (shr_c_op)this.addComponent(new shr_c_op("xs0aMultC0Plus0x7fffShr16", 16, 32));
		shr_c_op xq0aMultC0Plus0x7fffShr16 = (shr_c_op)this.addComponent(new shr_c_op("xq0aMultC0Plus0x7fffShr16", 16, 32));

		mult_op_s xc6MultR1 = (mult_op_s)this.addComponent(new mult_op_s("xc6MultR1", 32));
		mult_op_s xc2MultR0 = (mult_op_s)this.addComponent(new mult_op_s("xc2MultR0", 32));
		mult_op_s xc6MultR0 = (mult_op_s)this.addComponent(new mult_op_s("xc6MultR0", 32));
		mult_op_s xc2MultR1 = (mult_op_s)this.addComponent(new mult_op_s("xc2MultR1", 32));
		
		mult_op_s xc7MultQ1 = (mult_op_s)this.addComponent(new mult_op_s("xc7MultQ1", 32));
		mult_op_s xc1MultS1 = (mult_op_s)this.addComponent(new mult_op_s("xc1MultS1", 32));
		mult_op_s xc7MultS1 = (mult_op_s)this.addComponent(new mult_op_s("xc7MultS1", 32));
		mult_op_s xc1MultQ1 = (mult_op_s)this.addComponent(new mult_op_s("xc1MultQ1", 32));
		mult_op_s xc3MultQ0 = (mult_op_s)this.addComponent(new mult_op_s("xc3MultQ0", 32));
		mult_op_s xc5MultS0 = (mult_op_s)this.addComponent(new mult_op_s("xc5MultS0", 32));
		mult_op_s xc3MultS0 = (mult_op_s)this.addComponent(new mult_op_s("xc3MultS0", 32));
		mult_op_s xc5MultQ0 = (mult_op_s)this.addComponent(new mult_op_s("xc5MultQ0", 32));

		shr_c_op xF0rShr3 = (shr_c_op)this.addComponent(new shr_c_op("xF0rShr3", 3, 32));
		shr_c_op xF1rShr16 = (shr_c_op)this.addComponent(new shr_c_op("xF1rShr16", 16, 32));
		shr_c_op xF2rShr16 = (shr_c_op)this.addComponent(new shr_c_op("xF2rShr16", 16, 32));
		shr_c_op xF3rShr16 = (shr_c_op)this.addComponent(new shr_c_op("xF3rShr16", 16, 32));
		shr_c_op xF4rShr3 = (shr_c_op)this.addComponent(new shr_c_op("xF4rShr3", 3, 32));
		shr_c_op xF5rShr16 = (shr_c_op)this.addComponent(new shr_c_op("xF5rShr16", 16, 32));
		shr_c_op xF6rShr16 = (shr_c_op)this.addComponent(new shr_c_op("xF6rShr16", 16, 32));
		shr_c_op xF7rShr16 = (shr_c_op)this.addComponent(new shr_c_op("xF7rShr16", 16, 32));

		delay_op xi_1_step1 = (delay_op)this.addComponent(new delay_op("xi_1_step1", 1));
		delay_op xi_1_step2 = (delay_op)this.addComponent(new delay_op("xi_1_step2", 1));
		delay_op xi_1_step3 = (delay_op)this.addComponent(new delay_op("xi_1_step3", 1));
		delay_op xi_1_step4 = (delay_op)this.addComponent(new delay_op("xi_1_step4", 1));
		delay_op xi_1_step5 = (delay_op)this.addComponent(new delay_op("xi_1_step5", 1));
		delay_op xi_1_step6 = (delay_op)this.addComponent(new delay_op("xi_1_step6", 1));
		delay_op xi_1_step7 = (delay_op)this.addComponent(new delay_op("xi_1_step7", 1));
		delay_op xi_1_step8 = (delay_op)this.addComponent(new delay_op("xi_1_step8", 1));
		delay_op xi_1_step9 = (delay_op)this.addComponent(new delay_op("xi_1_step9", 1));
		delay_op xi_1_step10 = (delay_op)this.addComponent(new delay_op("xi_1_step10", 1));
		delay_op xi_1_step11 = (delay_op)this.addComponent(new delay_op("xi_1_step11", 1));
		delay_op xi_1_step12 = (delay_op)this.addComponent(new delay_op("xi_1_step12", 1));
		delay_op xi_1_step13 = (delay_op)this.addComponent(new delay_op("xi_1_step13", 1));
		delay_op xi_1_step14 = (delay_op)this.addComponent(new delay_op("xi_1_step14", 1));
		delay_op xi_1_step15 = (delay_op)this.addComponent(new delay_op("xi_1_step15", 1));
		delay_op xi_1_step16 = (delay_op)this.addComponent(new delay_op("xi_1_step16", 1));
		delay_op xi_1_step17 = (delay_op)this.addComponent(new delay_op("xi_1_step17", 1));
		delay_op xi_1_step18 = (delay_op)this.addComponent(new delay_op("xi_1_step18", 1));
		delay_op xi_1_step19 = (delay_op)this.addComponent(new delay_op("xi_1_step19", 1));
		delay_op xi_1_step20 = (delay_op)this.addComponent(new delay_op("xi_1_step20", 1));
		delay_op xi_1_step21 = (delay_op)this.addComponent(new delay_op("xi_1_step21", 1));

		delay_op xfor_i_step15 = (delay_op)this.addComponent(new delay_op("xfor_i_step15", 1, 15));
		delay_op xfor_i_delayed15 = (delay_op)this.addComponent(new delay_op("xfor_i_delayed15", Parameters.getDefaultAddressWidth(), 15));
		delay_op xfor_i_doneDelayed15 = (delay_op)this.addComponent(new delay_op("xfor_i_doneDelayed15", 1, 15));
		mux_m_op xmf = (mux_m_op)this.addComponent(new mux_m_op("xmf", Parameters.getDefaultDataWidth()*2, 8, 7));
		
		try {
			init.connectComponent(for_i, "clk_en");
			init.connectComponent(init2);
			init2.connectComponent(for_j, "clk_en");

			for_i.connectComponent("step", i1, "we");
			for_i.connectComponent("step", for_j, "clear");
			for_i.connectComponent("step",mj1);
			for_i.connectComponent("step",for_i_step2Not);
			for_i_step2Not.connectComponent(j1);
			
			for_j.connectComponent("step", j1, "we");
			for_j.connectComponent("step",for_j_step1Not);
			for_j.connectComponent("step",mi_1);
			for_j_step1Not.connectComponent(i_1);
			
			i1.connectComponentI0I1(i1, this.addComponent(new const_op(64, Parameters.getDefaultAddressWidth())));
			j1.connectComponentI0I1(mj1, this.addComponent(new const_op(1, Parameters.getDefaultAddressWidth())));
			i_1.connectComponentI0I1(mi_1, this.addComponent(new const_op(8, Parameters.getDefaultAddressWidth())));
			mj1.connectComponentI0I1(j1, i1);
			mi_1.connectComponentI0I1(i_1, j1);
			i_1.connectComponent(dct_io_ptr);
						
			dct_io_ptr.connectComponent(f0);
			dct_io_ptr.connectComponent(f1);
			dct_io_ptr.connectComponent(f2);
			dct_io_ptr.connectComponent(f3);
			dct_io_ptr.connectComponent(f4);
			dct_io_ptr.connectComponent(f5);
			dct_io_ptr.connectComponent(f6);
			dct_io_ptr.connectComponent(f7);
			
			for_j.connectComponent("step",f0, "we");
			for_j.connectComponent("step",f1, "we");
			for_j.connectComponent("step",f2, "we");
			for_j.connectComponent("step",f3, "we");
			for_j.connectComponent("step",f4, "we");
			for_j.connectComponent("step",f5, "we");
			for_j.connectComponent("step",f6, "we");
			for_j.connectComponent("step",f7, "we");
			
			g0.connectComponentI0I1(f0, f7);
			g1.connectComponentI0I1(f1, f6);
			h1.connectComponentI0I1(f2, f5);
			h0.connectComponentI0I1(f3, f4);
			p0.connectComponentI0I1(g0, h0);
			p1.connectComponentI0I1(g1, h1);
			
			h2.connectComponentI0I1(f0, f7);
			h3.connectComponentI0I1(f1, f6);
			g3.connectComponentI0I1(f2, f5);
			g2.connectComponentI0I1(f3, f4);
			r0.connectComponentI0I1(g0, h0);
			r1.connectComponentI0I1(g1, h1);

			g2.connectComponent(q1);
			h2.connectComponent(s1);
			
			s0aMultC0.setGenericValue("w_in1", 16); 
			q0aMultC0.setGenericValue("w_in1", 16); 
			s0a.connectComponentI0I1(h3, g3);
			q0a.connectComponentI0I1(h3, g3);
			s0aMultC0.connectComponentI0I1(s0a, c0);
			q0aMultC0.connectComponentI0I1(q0a, c0);
			
			
			s0aMultC0Plus0x7fff.connectComponentI0I1(s0aMultC0, this.addComponent(new const_op(0x7FFF, 32)));
			q0aMultC0Plus0x7fff.connectComponentI0I1(q0aMultC0, this.addComponent(new const_op(0x7FFF, 32)));
			s0aMultC0Plus0x7fff.connectComponent(s0aMultC0Plus0x7fffShr16);
			s0aMultC0Plus0x7fffShr16.connectComponent(s0);
			q0aMultC0Plus0x7fff.connectComponent(q0aMultC0Plus0x7fffShr16);
			q0aMultC0Plus0x7fffShr16.connectComponent(q0);

			P_0.connectComponentI0I1(p0, p1);
			P_1.connectComponentI0I1(p0, p1);

			c2MultR0.setGenericValue("w_in2", 16);
			c6MultR1.setGenericValue("w_in2", 16);
			c6MultR0.setGenericValue("w_in2", 16);
			c2MultR1.setGenericValue("w_in2", 16);
			c6MultR1.connectComponentI0I1(c6, r1);
			c2MultR0.connectComponentI0I1(c2, r0);
			c6MultR0.connectComponentI0I1(c6, r0);
			c2MultR1.connectComponentI0I1(c2, r1);
			R_1.connectComponentI0I1(c6MultR1, c2MultR0);
			R_0.connectComponentI0I1(c6MultR0, c2MultR1);

			Q_0.connectComponentI0I1(q1, q0);
			Q_1.connectComponentI0I1(q1, q0);
			S_0.connectComponentI0I1(s1, s0);
			S_1.connectComponentI0I1(s1, s0);
			
			P_0.setGenericValue("w_out", 32);
			P_1.setGenericValue("w_out", 32);
			R_0.setGenericValue("w_out", 32);
			R_1.setGenericValue("w_out", 32);
			P_0.connectComponent(F_0);
			R_1.connectComponent(F_2);
			P_1.connectComponent(F_4);
			R_0.connectComponent(F_6);

			c7MultQ1.setGenericValue("w_in2", 16);
			c1MultS1.setGenericValue("w_in2", 16);
			c7MultS1.setGenericValue("w_in2", 16);
			c1MultQ1.setGenericValue("w_in2", 16);
			c3MultQ0.setGenericValue("w_in2", 16);
			c5MultS0.setGenericValue("w_in2", 16);
			c3MultS0.setGenericValue("w_in2", 16);
			c5MultQ0.setGenericValue("w_in2", 16);

			c7MultQ1.connectComponentI0I1(c7, Q_1);
			c1MultS1.connectComponentI0I1(c1, S_1);
			c7MultS1.connectComponentI0I1(c7, S_1);
			c1MultQ1.connectComponentI0I1(c1, Q_1);
			c3MultQ0.connectComponentI0I1(c3, Q_0);
			c5MultS0.connectComponentI0I1(c5, S_0);
			c3MultS0.connectComponentI0I1(c3, S_0);
			c5MultQ0.connectComponentI0I1(c5, Q_0);
			
			F_1.connectComponentI0I1(c7MultQ1, c1MultS1);
			F_7.connectComponentI0I1(c7MultS1, c1MultQ1);
			F_5.connectComponentI0I1(c3MultQ0, c5MultS0);
			F_3.connectComponentI0I1(c3MultS0, c5MultQ0);

			F_1.connectComponent(F_1Shr13);
			F_2.connectComponent(F_2Shr13);
			F_3.connectComponent(F_3Shr13);
			F_5.connectComponent(F_5Shr13);
			F_6.connectComponent(F_6Shr13);
			F_7.connectComponent(F_7Shr13);
			
			for_j.connectComponent("step", F_0, "we");
			for_j.connectComponent("step", F_1, "we");
			for_j.connectComponent("step", F_2, "we");
			for_j.connectComponent("step", F_3, "we");
			for_j.connectComponent("step", F_4, "we");
			for_j.connectComponent("step", F_5, "we");
			for_j.connectComponent("step", F_6, "we");
			for_j.connectComponent("step", F_7, "we");
			
			for_j.connectComponent("step", mf, "Sel");
			for_j.connectComponent("step", mf, "Sel");
			for_j.connectComponent("step", mf, "Sel");
			for_j.connectComponent("step", mf, "Sel");
			for_j.connectComponent("step", mf, "Sel");
			for_j.connectComponent("step", mf, "Sel");
			for_j.connectComponent("step", mf, "Sel");
			
			F_0.connectComponent(mf, "I0");
			F_1Shr13.connectComponent(mf, "I0");
			F_2Shr13.connectComponent(mf, "I0");
			F_3Shr13.connectComponent(mf, "I0");
			F_4.connectComponent(mf, "I0");
			F_5Shr13.connectComponent(mf, "I0");
			F_6Shr13.connectComponent(mf, "I0");
			F_7Shr13.connectComponent(mf, "I0");
			
			mf.connectComponent(dct_io_tmp, "data_in");
			for_j_step16delay8.connectComponent(dct_io_tmp, "we");
			m_tmp.connectComponentI0I1(i_1, xfor_i);
			m_tmp.connectComponent(dct_io_tmp);
/////////// second part of FDCT /////////////////////////////////////////////////////////////////////////////////////////////////////////////

			for_i.connectComponent("done", xfor_i, "clk_en");
			for_i.connectComponent("done", xi_1, "clk_en");
			xfor_i.connectComponent("step", m_tmp);
			xfor_i.connectComponent("step", xfor_i_step15);
			xfor_i.connectComponent(xfor_i_delayed15);
			xfor_i.connectComponent("done", xfor_i_doneDelayed15);
			xfor_i_doneDelayed15.connectComponent(done);
			
			dct_io_tmp.connectComponent(xf0);
			dct_io_tmp.connectComponent(xf1);
			dct_io_tmp.connectComponent(xf2);
			dct_io_tmp.connectComponent(xf3);
			dct_io_tmp.connectComponent(xf4);
			dct_io_tmp.connectComponent(xf5);
			dct_io_tmp.connectComponent(xf6);
			dct_io_tmp.connectComponent(xf7);

			xi_1_step1.connectComponent(xf0, "we");
			xi_1_step2.connectComponent(xf1, "we");
			xi_1_step3.connectComponent(xf2, "we");
			xi_1_step4.connectComponent(xf3, "we");
			xi_1_step5.connectComponent(xf4, "we");
			xi_1_step6.connectComponent(xf5, "we");
			xi_1_step7.connectComponent(xf6, "we");
			xi_1_step8.connectComponent(xf7, "we");

			xi_1.connectComponent("step", xi_1_step1);
			xi_1_step1.connectComponent(xi_1_step2);
			xi_1_step2.connectComponent(xi_1_step3);
			xi_1_step3.connectComponent(xi_1_step4);
			xi_1_step4.connectComponent(xi_1_step5);
			xi_1_step5.connectComponent(xi_1_step6);
			xi_1_step6.connectComponent(xi_1_step7);
			xi_1_step7.connectComponent(xi_1_step8);
			xi_1_step8.connectComponent(xi_1_step9);
			xi_1_step9.connectComponent(xi_1_step10);
			xi_1_step10.connectComponent(xi_1_step11);
			xi_1_step11.connectComponent(xi_1_step12);
			xi_1_step12.connectComponent(xi_1_step13);
			xi_1_step13.connectComponent(xi_1_step14);
			xi_1_step14.connectComponent(xi_1_step15);
			xi_1_step15.connectComponent(xi_1_step16);
			xi_1_step16.connectComponent(xi_1_step17);
			xi_1_step17.connectComponent(xi_1_step18);
			xi_1_step18.connectComponent(xi_1_step19);
			xi_1_step19.connectComponent(xi_1_step20);
			xi_1_step20.connectComponent(xi_1_step21);
			
			xg0.connectComponentI0I1(xf0, xf7);
			xg1.connectComponentI0I1(xf1, xf6);
			xh1.connectComponentI0I1(xf2, xf5);
			xh0.connectComponentI0I1(xf3, xf4);
			xp0.connectComponentI0I1(xg0, xh0);
			xp1.connectComponentI0I1(xg1, xh1);
			
			xh2.connectComponentI0I1(xf0, xf7);
			xh3.connectComponentI0I1(xf1, xf6);
			xg3.connectComponentI0I1(xf2, xf5);
			xg2.connectComponentI0I1(xf3, xf4);
			xr0.connectComponentI0I1(xg0, xh0);
			xr1.connectComponentI0I1(xg1, xh1);

			xg2.connectComponent(xq1);
			xh2.connectComponent(xs1);
			
			xs0aMultC0.setGenericValue("w_in1", 16); 
			xq0aMultC0.setGenericValue("w_in1", 16); 
			xs0a.connectComponentI0I1(xh3, xg3);
			xq0a.connectComponentI0I1(xh3, xg3);
			xs0aMultC0.connectComponentI0I1(xs0a, c0);
			xq0aMultC0.connectComponentI0I1(xq0a, c0);
			
			
			xs0aMultC0Plus0x7fff.connectComponentI0I1(xs0aMultC0, this.addComponent(new const_op(0x7FFF, 32)));
			xq0aMultC0Plus0x7fff.connectComponentI0I1(xq0aMultC0, this.addComponent(new const_op(0x7FFF, 32)));
			xs0aMultC0Plus0x7fff.connectComponent(xs0aMultC0Plus0x7fffShr16);
			xs0aMultC0Plus0x7fffShr16.connectComponent(xs0);
			xq0aMultC0Plus0x7fff.connectComponent(xq0aMultC0Plus0x7fffShr16);
			xq0aMultC0Plus0x7fffShr16.connectComponent(xq0);

			xP_0.connectComponentI0I1(xp0, xp1);
			xP_1.connectComponentI0I1(xp0, xp1);

			xc2MultR0.setGenericValue("w_in2", 16);
			xc6MultR1.setGenericValue("w_in2", 16);
			xc6MultR0.setGenericValue("w_in2", 16);
			xc2MultR1.setGenericValue("w_in2", 16);
			xc6MultR1.connectComponentI0I1(c6, xr1);
			xc2MultR0.connectComponentI0I1(c2, xr0);
			xc6MultR0.connectComponentI0I1(c6, xr0);
			xc2MultR1.connectComponentI0I1(c2, xr1);
			xR_1.connectComponentI0I1(xc6MultR1, xc2MultR0);
			xR_0.connectComponentI0I1(xc6MultR0, xc2MultR1);

			xQ_0.connectComponentI0I1(xq1, xq0);
			xQ_1.connectComponentI0I1(xq1, xq0);
			xS_0.connectComponentI0I1(xs1, xs0);
			xS_1.connectComponentI0I1(xs1, xs0);
			
			xP_0.setGenericValue("w_out", 32);
			xP_1.setGenericValue("w_out", 32);
			xR_0.setGenericValue("w_out", 32);
			xR_1.setGenericValue("w_out", 32);
			xP_0.connectComponent(xF_0);
			xR_1.connectComponent(xF_2);
			xP_1.connectComponent(xF_4);
			xR_0.connectComponent(xF_6);

			xc7MultQ1.setGenericValue("w_in2", 16);
			xc1MultS1.setGenericValue("w_in2", 16);
			xc7MultS1.setGenericValue("w_in2", 16);
			xc1MultQ1.setGenericValue("w_in2", 16);
			xc3MultQ0.setGenericValue("w_in2", 16);
			xc5MultS0.setGenericValue("w_in2", 16);
			xc3MultS0.setGenericValue("w_in2", 16);
			xc5MultQ0.setGenericValue("w_in2", 16);

			xc7MultQ1.connectComponentI0I1(c7, xQ_1);
			xc1MultS1.connectComponentI0I1(c1, xS_1);
			xc7MultS1.connectComponentI0I1(c7, xS_1);
			xc1MultQ1.connectComponentI0I1(c1, xQ_1);
			xc3MultQ0.connectComponentI0I1(c3, xQ_0);
			xc5MultS0.connectComponentI0I1(c5, xS_0);
			xc3MultS0.connectComponentI0I1(c3, xS_0);
			xc5MultQ0.connectComponentI0I1(c5, xQ_0);
			
			xF_1.connectComponentI0I1(xc7MultQ1, xc1MultS1);
			xF_7.connectComponentI0I1(xc7MultS1, xc1MultQ1);
			xF_5.connectComponentI0I1(xc3MultQ0, xc5MultS0);
			xF_3.connectComponentI0I1(xc3MultS0, xc5MultQ0);

			xi_1_step12.connectComponent(xF_0, "we");
			xi_1_step12.connectComponent(xF_1, "we");
			xi_1_step12.connectComponent(xF_2, "we");
			xi_1_step12.connectComponent(xF_3, "we");
			xi_1_step12.connectComponent(xF_4, "we");
			xi_1_step12.connectComponent(xF_5, "we");
			xi_1_step12.connectComponent(xF_6, "we");
			xi_1_step12.connectComponent(xF_7, "we");

			xF0r.connectComponentI0I1(xF_0, this.addComponent(new const_op(0x0006, 32)));
			xF1r.connectComponentI0I1(xF_1, this.addComponent(new const_op(0x7fff, 32)));
			xF2r.connectComponentI0I1(xF_2, this.addComponent(new const_op(0x7fff, 32)));
			xF3r.connectComponentI0I1(xF_3, this.addComponent(new const_op(0x7fff, 32)));
			xF4r.connectComponentI0I1(xF_4, this.addComponent(new const_op(0x0004, 32)));
			xF5r.connectComponentI0I1(xF_5, this.addComponent(new const_op(0x7fff, 32)));
			xF6r.connectComponentI0I1(xF_6, this.addComponent(new const_op(0x7fff, 32)));
			xF7r.connectComponentI0I1(xF_7, this.addComponent(new const_op(0x7fff, 32)));

			xi_1_step13.connectComponent(xF0r, "we");
			xi_1_step13.connectComponent(xF1r, "we");
			xi_1_step13.connectComponent(xF2r, "we");
			xi_1_step13.connectComponent(xF3r, "we");
			xi_1_step13.connectComponent(xF4r, "we");
			xi_1_step13.connectComponent(xF5r, "we");
			xi_1_step13.connectComponent(xF6r, "we");
			xi_1_step13.connectComponent(xF7r, "we");

			xF0r.connectComponent(xF0rShr3);
			xF1r.connectComponent(xF1rShr16);
			xF2r.connectComponent(xF2rShr16);
			xF3r.connectComponent(xF3rShr16);
			xF4r.connectComponent(xF4rShr3);
			xF5r.connectComponent(xF5rShr16);
			xF6r.connectComponent(xF6rShr16);
			xF7r.connectComponent(xF7rShr16);
			
			xi_1_step15.connectComponent(xmf, "Sel");
			xi_1_step16.connectComponent(xmf, "Sel");
			xi_1_step17.connectComponent(xmf, "Sel");
			xi_1_step18.connectComponent(xmf, "Sel");
			xi_1_step19.connectComponent(xmf, "Sel");
			xi_1_step20.connectComponent(xmf, "Sel");
			xi_1_step21.connectComponent(xmf, "Sel");
			
			xF0rShr3.connectComponent(xmf, "I0");
			xF1rShr16.connectComponent(xmf, "I0");
			xF2rShr16.connectComponent(xmf, "I0");
			xF3rShr16.connectComponent(xmf, "I0");
			xF4rShr3.connectComponent(xmf, "I0");
			xF5rShr16.connectComponent(xmf, "I0");
			xF6rShr16.connectComponent(xmf, "I0");
			xF7rShr16.connectComponent(xmf, "I0");			

			xmf.connectComponent(dct_o, "data_in");
			xfor_i_step15.connectComponent(dct_o, "we");
			xfor_i_delayed15.connectComponent(dct_o);
			
			dct_o.connectComponent(output);
		} catch (Exception e) {
			e.printStackTrace();
			return;
		}
	}					
}
