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
 * A register.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 */
public class reg_op extends IComponent {
	private long initialValue = 0;
	public reg_op() {
		this(Parameters.getDefaultDataWidth());
	}
	public reg_op(long width) {
		this((int)width);
	}
	public reg_op(int width) {
		super(width);
		Generic generic;
		generic = new Generic("w_in", "integer", width);
		super.addGeneric(generic);
		super.addPort(new Port("clk", PortType.INPUT));
		super.addPort(new Port("reset", PortType.INPUT));
		super.addPort(new Port("we", PortType.INPUT));
		super.addPort(new Port("I0", PortType.INPUT, width, generic), true);
		super.addPort(new Port("O0", PortType.OUTPUT, width, generic), true);
		generic = new Generic("initial", "integer", 0);
		super.addGeneric(generic);
	}
	public reg_op(String name) {
		this();
		super.name = name;
	}
	public reg_op(String name, int width) {
		this(width);
		super.name = name;
	}
	public reg_op(String name, long width) {
		this(width);
		super.name = name;
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component reg_op\n";  
		d += "generic (\n";
		d += "	w_in	: integer := 16;\n";
		d += "	initial	: integer := 0\n";
		d += ");\n";
		d += "port (\n";
		d += "	clk	: in	std_logic;\n";
		d += "	reset	: in	std_logic;\n";
		d += "	we	: in	std_logic := '1';\n";
		d += "	I0	: in	std_logic_vector(w_in-1 downto 0);\n";
		d += "	O0	: out	std_logic_vector(w_in-1 downto 0)\n";
		d += ");\n";
		d += "end component;\n";
		d += "\n";
		return d;
	}
	public void setInitialValue(int initialValue) {
		this.initialValue = initialValue;
		getGeneric("initial").setValue(initialValue);
	}
	public void setInitialValue(long initialValue) {
		this.initialValue = initialValue;
		getGeneric("initial").setValue((int)initialValue);
	}
	public long getInitialValue() {
		return this.initialValue;
	}
}
