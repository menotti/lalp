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
 * A multiplexer.
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>


 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version September, 2007
 */
public class mux_op extends IComponent {
	public mux_op() {
		this(Parameters.getDefaultDataWidth());
	}
	public mux_op(int width) {
		super(width);
		setSync(false);
		Generic generic;
		generic = new Generic("w_in", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("Sel1", PortType.INPUT, 1), true);
		super.addPort(new Port("I0", PortType.INPUT, width, generic));
		super.addPort(new Port("I1", PortType.INPUT, width, generic));
		super.addPort(new Port("O0", PortType.OUTPUT, width, generic), true);
	}
	public mux_op(String name) {
		this();
		super.name = name;
	}
	public mux_op(String string, int width) {
		this(width);
		super.name = name;
	}
	public String getVHDLDeclaration() {
		StringBuffer d = new StringBuffer();
		d.append("component mux_op\n");
		d.append("generic (w_in	: integer := 16);\n");
		d.append("port (\n");
		d.append("	I0		: in	std_logic_vector(w_in-1 downto 0);\n");
		d.append("	I1		: in	std_logic_vector(w_in-1 downto 0);\n");
		d.append("	Sel1	: in	std_logic_vector(0 downto 0);\n");
		d.append("	O0		: out	std_logic_vector(w_in-1 downto 0)\n");
		d.append(");\n");
		d.append("end component;\n");		
		return d.toString();
	}
}
