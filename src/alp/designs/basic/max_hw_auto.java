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

import alp.components.block_ram;
import alp.components.if_gt_op_s;
import alp.components.input;
import alp.components.module_for;
import alp.components.output;
import alp.components.reg_op;
import alp.core.Design;
import alp.core.Parameters;

/**
 * Obtain the max value of a vector.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 * @deprecated
 */
public class max_hw_auto extends Design {
	final static int SIZE = 2048;
	public max_hw_auto() {
		super("max_auto");
		Parameters.setDefaultDataWidth(16);
		// input/output pins
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		output maxval = (output)this.addComponent(new output("maxval", Parameters.getDefaultDataWidth()));
		output done = (output)this.addComponent(new output("done", 1));
		// intermediate components
		module_for for1 = (module_for)this.addComponent(new module_for("for", 11, SIZE));
		block_ram ram1 = (block_ram)this.addComponent(new block_ram("ram1", 11));
		// BEGIN: memory initialization
		int[] ram1contents = new int[SIZE];
		for (int i=0; i<ram1contents.length; i++)
			ram1contents[i] = (int)(Math.random()*1000);
		ram1.setInitialValue(ram1contents);
		// END: memory initialization
		reg_op r1 = (reg_op)this.addComponent(new reg_op("r1"));
		reg_op r2 = (reg_op)this.addComponent(new reg_op("r2"));
		if_gt_op_s comp = (if_gt_op_s)this.addComponent(new if_gt_op_s());
		try {
			init.connectComponent(for1, "clk_en");
			for1.connectComponent("done", done);
			for1.connectComponent("output", ram1, "address");
			ram1.connectComponent(r1);
			r1.connectComponent(comp, "I0");
			r1.connectComponent(r2);
			r2.connectComponent(comp, "I1");
			r2.connectComponent(maxval);
			comp.connectComponent(r2, "we");
			// manual identify backedges
			comp.getPort("O0").getSignal().setBackEdge(true);
			// manual insert delay
//			for1.getPort("done").getSignal().insertDelay();
//			for1.getPort("done").getSignal().insertDelay(4);
//			for1.getPort("done").getSignal().insertDelay();
//			r1.getPort("O0").getSignal().getSignal().insertDelay();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
