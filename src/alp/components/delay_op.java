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

package alp.components;

import alp.core.Generic;
import alp.core.IComponent;
import alp.core.Parameters;
import alp.core.Port;
import alp.core.PortType;

/**
 * The delay component for bus or single bit
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 */
public class delay_op extends IComponent {
	public delay_op() {
		this(Parameters.getDefaultDataWidth());
	}
	public delay_op(int width) {
		this(width, 1);
	}
	public delay_op(int width, int delay) {
		super(width);
		Generic generic;
		generic = new Generic("bits", "integer", 8);
		super.addGeneric(generic);
		super.addGeneric(new Generic("delay", "integer", delay));
		super.addPort(new Port("a", PortType.INPUT, width, generic), true);
		super.addPort(new Port("clk", PortType.INPUT));
		super.addPort(new Port("reset", PortType.INPUT));
		super.addPort(new Port("a_delayed", PortType.OUTPUT, width, generic), true);
		setDelay(delay);
	}	
	public delay_op(String name) {
		this();
		super.name = name;
	}
	public delay_op(String name, int width) {
		this(width);
		super.name = name;
	}
	public delay_op(String name, int width, int delay) {
		this(width, delay);
		super.name = name;
	}
	public String getNodeName() {
		return this.getClass().getSimpleName() + ":" + super.name + "\\ndelay=" + super.delay;
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component delay_op\n";  
		d += "generic (\n";
		d += "	bits	: integer := 8;\n";
		d += "	delay	: integer := 1\n";
		d += ");\n";
		d += "port (\n";
		d += "	a			: in	std_logic_vector(bits-1 downto 0);\n";
		d += "	clk			: in	std_logic;\n";
		d += "	reset		: in	std_logic;\n";
		d += "	a_delayed	: out	std_logic_vector(bits-1 downto 0) := (others=>'0')\n";
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
	public String getDotName() {
		String dotName = "{";
		for (int i=1; i<delay; i++)
			dotName += "|";
		dotName += "}";
		return dotName;
	}
	public String getDotShape() {
		return "record fillcolor=lightgray";
	}
}
