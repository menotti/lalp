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

import alp.components.and_op;
import alp.components.block_ram;
import alp.components.delay_op;
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
public class max_hw extends Design {
	final static int SIZE = 2048;
	public max_hw() {
		super("max");
		Parameters.setDefaultDataWidth(32);
		// input/output pins
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		output maxval = (output)this.addComponent(new output("maxval", Parameters.getDefaultDataWidth()));
		output done = (output)this.addComponent(new output("done", 1));
		// intermediate components
		module_for for1 = (module_for)this.addComponent(new module_for(11, SIZE));
		block_ram ram1 = (block_ram)this.addComponent(new block_ram("ram1", 11));
		// BEGIN: memory initialization
		int[] ram1contents = new int[SIZE];
		for (int i=0; i<ram1contents.length; i++)
			ram1contents[i] = (int)(Math.random()*1000);
		ram1.setInitialValue(ram1contents);
		// END: memory initialization
		delay_op d1 = (delay_op)this.addComponent(new delay_op("d1", 1, 2));
		delay_op d2 = (delay_op)this.addComponent(new delay_op("d2", 1, 2));
		reg_op r1 = (reg_op)this.addComponent(new reg_op());
		reg_op r2 = (reg_op)this.addComponent(new reg_op());
		if_gt_op_s comp = (if_gt_op_s)this.addComponent(new if_gt_op_s("comp"));
		and_op and1 = (and_op)this.addComponent(new and_op(1));
		try {
			init.connectComponent(for1, "clk_en");
			d2.connectComponent(done);
			for1.connectComponent("step", d1, "a");
			for1.connectComponent("done", d2, "a");
			for1.connectComponent("output", ram1, "address");
			d1.connectComponent("a_delayed", and1, "I0"); 
			comp.connectComponent(and1, "I1");
			and1.connectComponent(r2, "we");
			ram1.connectComponent(r1);
			r1.connectComponent(comp, "I0");
			r1.connectComponent(r2);
			r2.connectComponent(comp, "I1");
			r2.connectComponent(maxval);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
