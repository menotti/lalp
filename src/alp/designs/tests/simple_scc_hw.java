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

package alp.designs.tests;

import alp.components.add_reg_op_s;
import alp.components.block_ram;
import alp.components.delay_op;
import alp.components.input;
import alp.components.module_for;
import alp.components.output;
import alp.components.reg_op;
import alp.components.sub_reg_op_s;
import alp.core.Design;
import alp.core.Parameters;

/**
 * A simple example with 2 SCC
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 * @deprecated
 */
public class simple_scc_hw extends Design {
	final static int SIZE = 8;
	public simple_scc_hw() {
		super("simple_scc");
		Parameters.setDefaultDataWidth(16);
		// input/output pins
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		output sum_val = (output)this.addComponent(new output("sum_val", Parameters.getDefaultDataWidth()));
		output done = (output)this.addComponent(new output("done", 1));
		// intermediate components
		module_for for1 = (module_for)this.addComponent(new module_for(3, SIZE));
		block_ram indata = (block_ram)this.addComponent(new block_ram("indata", 3));
		// BEGIN: memory initialization
		int indatacontents[] = {12, 41, 96, 87, 56, 25, 69, 31};
		indata.setInitialValue(indatacontents);
		// END: memory initialization
		add_reg_op_s sum = (add_reg_op_s)this.addComponent(new add_reg_op_s("sum"));
		reg_op a = (reg_op)this.addComponent(new reg_op("a"));
		sub_reg_op_s b = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("b"));
		add_reg_op_s c = (add_reg_op_s)this.addComponent(new add_reg_op_s("c"));
		delay_op doneDelayed = (delay_op)this.addComponent(new delay_op("doneDelayed", 1, 2));
		try {
			init.connectComponent(for1, "clk_en");
			for1.connectComponent("done", doneDelayed);
			for1.connectComponent("output", indata, "address");
			doneDelayed.connectComponent(done);
			indata.connectComponent(a);
			b.connectComponentI0I1(a, c);
			c.connectComponentI0I1(b, a);
			sum.connectComponentI0I1(sum, c);
			sum.connectComponent(sum_val);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
