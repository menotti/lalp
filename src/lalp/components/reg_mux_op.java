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
import lalp.core.Parameters;
import lalp.core.Port;
import lalp.core.PortType;

/**
 * A register with 2 inputs multiplexed
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version September, 2007
 */
public class reg_mux_op extends IComponent {
	private int initialValue = 0;
	public reg_mux_op() {
		this(Parameters.getDefaultDataWidth());
	}
	public reg_mux_op(int width) {
		super(width);
		Generic generic;
		generic = new Generic("w_in", "integer", width);
		super.addGeneric(generic);
		super.addPort(new Port("clk", PortType.INPUT));
		super.addPort(new Port("reset", PortType.INPUT));
		super.addPort(new Port("we", PortType.INPUT));
		super.addPort(new Port("Sel1", PortType.INPUT, 1), true);
		super.addPort(new Port("I0", PortType.INPUT, width, generic));
		super.addPort(new Port("I1", PortType.INPUT, width, generic));
		super.addPort(new Port("O0", PortType.OUTPUT, width, generic), true);
		generic = new Generic("initial", "integer", 0);
		super.addGeneric(generic);
	}
	public reg_mux_op(String name) {
		this();
		super.name = name;
	}
	public reg_mux_op(String name, int width) {
		this(width);
		super.name = name;
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component reg_mux_op\n";  
		d += "generic (\n";
		d += "	w_in	: integer := 16;\n";
		d += "	initial	: integer := 0\n";
		d += ");\n";
		d += "port (\n";
		d += "	clk	: in	std_logic;\n";
		d += "	reset	: in	std_logic;\n";
		d += "	we	: in	std_logic := '1';\n";
		d += "	Sel1	: in	std_logic_vector(0 downto 0);\n";
		d += "	I0	: in	std_logic_vector(w_in-1 downto 0);\n";
		d += "	I1	: in	std_logic_vector(w_in-1 downto 0);\n";
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
	public int getInitialValue() {
		return this.initialValue;
	}
}
