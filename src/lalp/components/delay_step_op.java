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

package lalp.components;

import lalp.core.Generic;
import lalp.core.IComponent;
import lalp.core.Port;
import lalp.core.PortType;

/**
 * The delay step component 
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version September, 2007
 */
public class delay_step_op extends IComponent {
	public delay_step_op() {
		super();
		super.addGeneric(new Generic("bits", "integer", 8));
		super.addGeneric(new Generic("delay", "integer", 1));
		super.addPort(new Port("a", PortType.INPUT), true);
		super.addPort(new Port("clk", PortType.INPUT));
		super.addPort(new Port("reset", PortType.INPUT));
		super.addPort(new Port("a_delayed", PortType.OUTPUT), true);
	}	
	public delay_step_op(int delay) {
		this();
		setDelay(delay);
	}
	public delay_step_op(String name) {
		this();
		super.name = name;
	}
	public delay_step_op(String name, int delay) {
		this(delay);
		super.name = name;
	}
	public String getNodeName() {
		return this.getClass().getSimpleName() + ":" + super.name + "\\ndelay=" + super.delay;
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component delay_step_op\n";  
		d += "generic (\n";
		d += "	bits	: integer := 8;\n";
		d += "	delay	: integer := 1\n";
		d += ");\n";
		d += "port (\n";
		d += "	a			: in	std_logic;\n";
		d += "	clk			: in	std_logic;\n";
		d += "	reset		: in	std_logic;\n";
		d += "	a_delayed	: out	std_logic\n";
		d += ");\n";
		d += "end component;\n";
		d += "\n";
		return d;
	}
	public void setDelay(int delay) {
		super.setDelay(delay);
		try {
			setGenericValue("delay", delay);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
