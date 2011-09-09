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
 * The signed GE (greater then or equal) zero operation.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version September, 2007
 */
public class ge_op_s extends IComponent {
	public ge_op_s() {
		super();
		setSync(false);
		Generic generic;
		generic = new Generic("w_in", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("I0", PortType.INPUT, Parameters.getDefaultDataWidth(), generic), true);
		generic = new Generic("w_out", "integer", 1);
		super.addGeneric(generic);
		super.addPort(new Port("O0", PortType.OUTPUT, 1, generic), true);
	}
	public ge_op_s(String name) {
		this();
		super.name = name;
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component ge_op_s\n";  
		d += "generic (\n";
		d += "	w_in	: integer := 16;\n";
		d += "	w_out	: integer := 1\n";
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
		return super.name + ":>=0";
	}
}