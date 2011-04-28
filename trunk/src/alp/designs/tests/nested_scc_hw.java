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
import alp.components.mult_op_s;
import alp.components.output;
import alp.components.sub_reg_op_s;
import alp.core.Design;
import alp.core.Parameters;

/**
 * A example with nested SCCs
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 * @deprecated
 */
public class nested_scc_hw extends Design {
	final static int SIZE = 8;
	public nested_scc_hw() {
		super("nested_scc");
		Parameters.setDefaultDataWidth(16);
		Parameters.setDefaultAddressWidth(3);
		// input/output pins
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		output output = (output)this.addComponent(new output("output", Parameters.getDefaultDataWidth()));
		output done = (output)this.addComponent(new output("done", 1));
		// intermediate components
		module_for for1 = (module_for)this.addComponent(new module_for(3, SIZE));
		block_ram a = (block_ram)this.addComponent(new block_ram("a", 3));
		block_ram b = (block_ram)this.addComponent(new block_ram("b", 3));
		block_ram x = (block_ram)this.addComponent(new block_ram("x", 3));
		// BEGIN: memory initialization
		int acontents[] = {2, 1, 6, 7, 6, 5, 9, 1};
		int bcontents[] = {4, 9, 8, 5, 2, 6, 3, 1};
		int xcontents[] = {1, 6, 5, 6, 5, 9, 1, 4};
		a.setInitialValue(acontents);
		b.setInitialValue(bcontents);
		x.setInitialValue(xcontents);
		// END: memory initialization
		add_reg_op_s c = (add_reg_op_s)this.addComponent(new add_reg_op_s("c"));
		add_reg_op_s e = (add_reg_op_s)this.addComponent(new add_reg_op_s("e"));
		sub_reg_op_s d = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("d"));
		sub_reg_op_s f = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("f"));
		mult_op_s g = (mult_op_s)this.addComponent(new mult_op_s("g")); 
		delay_op doneDelayed = (delay_op)this.addComponent(new delay_op("doneDelayed", 1, 2));
		delay_op iDelayed = (delay_op)this.addComponent(new delay_op("iDelayed", 3, 4));
		try {
			init.connectComponent(for1, "clk_en");
			for1.connectComponent("done", doneDelayed);
			for1.connectComponent("output", a, "address");
			for1.connectComponent("output", b, "address");
			for1.connectComponent("output", iDelayed);
			iDelayed.connectComponent(x);
			doneDelayed.connectComponent(done);
			c.connectComponentI0I1(a, g);
			d.connectComponentI0I1(a, b);
			e.connectComponentI0I1(c, g);
			f.connectComponentI0I1(c, d);
			g.connectComponentI0I1(e, f);
			g.connectComponent(x, "data_in");
			x.connectComponent(output);
		} catch (Exception ex) {
			ex.printStackTrace();
		}		
	}
}
