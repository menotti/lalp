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
 * The unsigned SUB operation.
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>


 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version September, 2007
 */
public class sub_op extends IComponent {
	public sub_op() {
		super();
		setSync(false);
		Generic generic;
		generic = new Generic("w_in1", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("I0", PortType.INPUT, Parameters.getDefaultDataWidth(), generic));
		generic = new Generic("w_in2", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("I1", PortType.INPUT, Parameters.getDefaultDataWidth(), generic));
		generic = new Generic("w_out", "integer", 32);
		super.addGeneric(generic);
		super.addPort(new Port("O0", PortType.OUTPUT, Parameters.getDefaultDataWidth(), generic), true);
	}
	public sub_op(String name) {
		this();
		super.name = name;
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component sub_op\n";  
		d += "generic (\n";
		d += "	w_in1	: integer := 16;\n";
		d += "	w_in2	: integer := 16;\n";
		d += "	w_out	: integer := 32\n";
		d += ");\n";
		d += "port (\n";
		d += "	I0	: in	std_logic_vector(w_in1-1 downto 0);\n";
		d += "	I1	: in	std_logic_vector(w_in2-1 downto 0);\n";
		d += "	O0	: out	std_logic_vector(w_out-1 downto 0)\n";
		d += ");\n";
		d += "end component;\n";
		d += "\n";
		return d;
	}
	public String getDotName() {
		return super.name + ":-";
	}
}
