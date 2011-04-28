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

import alp.components.add_op_s;
import alp.components.mult_op_s;
import alp.components.reg_op;
import alp.components.sub_op_s;
import alp.core.Design;

/**
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version October, 2008
 * @deprecated
 */
public class test_balancing_hw extends Design {

	public test_balancing_hw() {
		super("test_balancing");
		reg_op a = (reg_op)this.addComponent(new reg_op("a"));
		this.setInit(a);
		reg_op b = (reg_op)this.addComponent(new reg_op("b"));
		reg_op c = (reg_op)this.addComponent(new reg_op("c"));
		reg_op d = (reg_op)this.addComponent(new reg_op("d"));
		add_op_s ab = (add_op_s)this.addComponent(new add_op_s());
		mult_op_s abc = (mult_op_s)this.addComponent(new mult_op_s());
		sub_op_s abcd = (sub_op_s)this.addComponent(new sub_op_s());
		reg_op s = (reg_op)this.addComponent(new reg_op("s"));
		try {
			ab.connectComponentI0I1(a, b);
			abc.connectComponentI0I1(ab, c);
			abcd.connectComponentI0I1(abc, d);
			abcd.connectComponent(s);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
