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

package alp.designs.basic;


import alp.components.add_reg_op_s;
import alp.components.block_ram;
import alp.components.input;
import alp.components.module_for;
import alp.components.mult_op_s;
import alp.components.output;
import alp.core.Design;
import alp.core.Parameters;

/**
 * Obtain the product of two vectors.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 * @deprecated
 */
public class dotprod_hw_auto extends Design {
	final static int SIZE = 2048;
	public dotprod_hw_auto() {
		super("dotprod_auto");
		Parameters.setDefaultDataWidth(16);
		// input/output pins
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		output sum = (output)this.addComponent(new output("sum", Parameters.getDefaultDataWidth()));
		output done = (output)this.addComponent(new output("done", 1));
		// intermediate components
		module_for for1 = (module_for)this.addComponent(new module_for("for1", 11, SIZE));
		block_ram ramx = (block_ram)this.addComponent(new block_ram("ramx", 11));
		block_ram ramy = (block_ram)this.addComponent(new block_ram("ramy", 11));
		// BEGIN: memory initialization
		int[] ramXcontents = new int[SIZE];
		int[] ramYcontents = new int[SIZE];
		for (int i=0; i<SIZE; i++) {
			ramXcontents[i] = (int)(Math.random()*10);
			ramYcontents[i] = (int)(Math.random()*10);
		}
		ramx.setInitialValue(ramXcontents);
		ramy.setInitialValue(ramYcontents);
		// END: memory initialization
		mult_op_s mult1 = (mult_op_s)this.addComponent(new mult_op_s("mult1"));
		add_reg_op_s acc1 = (add_reg_op_s)this.addComponent(new add_reg_op_s("acc1")); 
		try {
			init.connectComponent(for1, "clk_en");
			for1.connectComponent("done", done);
			for1.connectComponent("step", acc1, "we");
			for1.connectComponent(ramx);
			for1.connectComponent(ramy);
			mult1.connectComponentI0I1(ramx, ramy);
			acc1.connectComponentI0I1(acc1, mult1);
			acc1.connectComponent(sum);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}