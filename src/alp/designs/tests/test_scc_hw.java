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
import alp.components.add_reg_op_s;
import alp.components.reg_op;
import alp.core.Design;
import alp.core.Parameters;

/** 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 * @deprecated
 */
public class test_scc_hw extends Design {
	final static int SIZE = 8;
	public test_scc_hw() {
		super("test_scc");
		Parameters.setDefaultDataWidth(16);
		add_reg_op_s f = (add_reg_op_s)this.addComponent(new add_reg_op_s("f"));
		add_reg_op_s h = (add_reg_op_s)this.addComponent(new add_reg_op_s("h"));
		add_op_s c = (add_op_s)this.addComponent(new add_op_s("c"));
		add_op_s g = (add_op_s)this.addComponent(new add_op_s("g"));
		reg_op a = (reg_op)this.addComponent(new reg_op("a"));
		reg_op b = (reg_op)this.addComponent(new reg_op("b"));
		reg_op d = (reg_op)this.addComponent(new reg_op("d"));
		reg_op e = (reg_op)this.addComponent(new reg_op("e"));
		try {
			a.connectComponent(b);
			b.connectComponent(c, "I0");
			b.connectComponent(e);
			b.connectComponent(f);
			c.connectComponent(d);
			c.connectComponent(g, "I0");
			d.connectComponent(c, "I1");
			d.connectComponent(h);
			e.connectComponent(a);
			e.connectComponent(f, "I0");
			f.connectComponent(g, "I1");
			g.connectComponent(f, "I1");
			g.connectComponent(h, "I0");
			h.connectComponent(h, "I1");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}
