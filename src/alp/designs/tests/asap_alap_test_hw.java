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
import alp.components.input;
import alp.components.module_for;
import alp.components.output;
import alp.core.Design;
import alp.core.Parameters;

/**
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>  * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version October, 2008
 * @deprecated
 */
public class asap_alap_test_hw extends Design {
	final static int SIZE = 2048;
	public asap_alap_test_hw() {
		super("asap_alap_test");
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		module_for for1 = (module_for)this.addComponent(new module_for("for1", 11, SIZE));
		block_ram rama = (block_ram)this.addComponent(new block_ram("rama", 11));
		block_ram ramb = (block_ram)this.addComponent(new block_ram("ramb", 11));
		block_ram ramc = (block_ram)this.addComponent(new block_ram("ramc", 11));
		add_reg_op_s ab = (add_reg_op_s)this.addComponent(new add_reg_op_s("ab")); 
		add_reg_op_s abc = (add_reg_op_s)this.addComponent(new add_reg_op_s("abc")); 
		output output = (output)this.addComponent(new output("output", Parameters.getDefaultDataWidth()));
		output done = (output)this.addComponent(new output("done"));
		output step = (output)this.addComponent(new output("step"));
		try {
			init.connectComponent(for1, "clk_en");
			for1.connectComponent(rama);
			for1.connectComponent(ramb);
			for1.connectComponent(ramc);
			ab.connectComponentI0I1(rama, ramb);
			abc.connectComponentI0I1(ab, ramc);
			abc.connectComponent(output);
			for1.connectComponent("done", done);
			for1.connectComponent("step", step);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
