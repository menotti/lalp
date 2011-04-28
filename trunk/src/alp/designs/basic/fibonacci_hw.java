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
import alp.components.output;
import alp.components.reg_op;
import alp.core.Design;
import alp.core.Parameters;

/**
 * Obtain the Fibonacci sequence
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 * @deprecated
 */
public class fibonacci_hw extends Design {
	final static int SIZE = 32;
	public fibonacci_hw() {
		super("fibonacci");
		Parameters.setDefaultDataWidth(32);
		// input/output pins
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		output output = (output)this.addComponent(new output("output", Parameters.getDefaultDataWidth()));
		output done = (output)this.addComponent(new output("done", 1));
		// intermediate components
		module_for i = (module_for)this.addComponent(new module_for("i", 5, SIZE));
		block_ram v = (block_ram)this.addComponent(new block_ram("v", 5));
		reg_op a = (reg_op)this.addComponent(new reg_op());
		add_reg_op_s b = (add_reg_op_s)this.addComponent(new add_reg_op_s());
		try {
			init.connectComponent(i, "clk_en");
			i.connectComponent("done", done);
			i.connectComponent("step", a, "we");
			i.connectComponent("step", b, "we");
			i.connectComponent("output", v, "address");
			a.connectComponent(b, "I1");
			a.connectComponent(v, "data_in");
			b.connectComponent(b, "I0");
			b.connectComponent(a);
			v.connectComponent(output);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
