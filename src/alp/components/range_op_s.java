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
public class range_op_s extends IComponent {
	protected int min = 0;
	protected int max = 255;
	public range_op_s() {
		super();
		Generic generic;
		generic = new Generic("min", "integer", 0);
		super.addGeneric(generic);
		generic = new Generic("max", "integer", 255);
		super.addGeneric(generic);
		generic = new Generic("w_in", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("clk", PortType.INPUT));
		super.addPort(new Port("reset", PortType.INPUT));
		super.addPort(new Port("we", PortType.INPUT));
		super.addPort(new Port("I0", PortType.INPUT, Parameters.getDefaultDataWidth(), generic), true);
		super.addPort(new Port("O0", PortType.OUTPUT, Parameters.getDefaultDataWidth(), generic), true);
	}
	public range_op_s(String name) {
		this();
		super.name = name;
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component range_op_s\n";  
		d += "generic (\n";
		d += "	w_in	: integer := 16;\n";
		d += "	min		: integer := 0;\n";
		d += "	max		: integer := 255\n";
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
	public void setRange(int min, int max) {
		try {
			super.setGenericValue("min", min);
			super.setGenericValue("max", max);
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.min = min;
		this.max = max;
	}
}
