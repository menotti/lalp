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
 * The NONE operation.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>  
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version December, 2009
 */
public class none_op extends IComponent {
	public none_op() {
		this(Parameters.getDefaultDataWidth());
	}
	public none_op(int width) {	
		super(width);
		setSync(false);
		Generic generic;
		generic = new Generic("w_in", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("I0", PortType.INPUT, width, generic), true);
		generic = new Generic("w_out", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("O0", PortType.OUTPUT, width, generic), true);
	}
	public none_op(String name) {
		this();
		super.name = name;
	}
	public none_op(String name, int width) {
		this(width);
		super.name = name;
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component none_op\n";  
		d += "generic (\n";
		d += "	w_in	: integer := 16;\n";
		d += "	w_out	: integer := 16\n";
		d += ");\n";
		d += "port (\n";
		d += "	I0	: in	std_logic_vector(w_in-1 downto 0);\n";
		d += "	O0	: out	std_logic_vector(w_out-1 downto 0)\n";
		d += ");\n";
		d += "end component;\n";
		d += "\n";
		return d;
	}
	public String getDotName() {
		return super.name + "=";
	}
}
