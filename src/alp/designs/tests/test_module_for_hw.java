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

import alp.components.input;
import alp.components.module_for;
import alp.components.output;
import alp.core.Design;

/**
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version October, 2008
 * @deprecated
 */
public class test_module_for_hw extends Design {

	public test_module_for_hw() {
		super("test_module_for", 8);
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		output done = (output)this.addComponent(new output("done"));
		output step = (output)this.addComponent(new output("step"));
		output output = (output)this.addComponent(new output("output", true));
		module_for for1 = (module_for)this.addComponent(new module_for("for1", 8, 10, 3));
		try {
			init.connectComponent(for1, "clk_en");
			for1.connectComponent(output);
			for1.connectComponent("done", done);
			for1.connectComponent("step", step);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
