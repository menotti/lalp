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

package br.ufscar.dc.lalp.components;

import br.ufscar.dc.lalp.core.Generic;
import br.ufscar.dc.lalp.core.IComponent;
import br.ufscar.dc.lalp.core.Parameters;
import br.ufscar.dc.lalp.core.Port;
import br.ufscar.dc.lalp.core.PortType;

/**
 * The signed NEG operation.
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>


 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version September, 2007
 */
public class neg_op_s extends IComponent {
	public neg_op_s() {
		this(Parameters.getDefaultDataWidth());
	}
	public neg_op_s(int width) {
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
	public neg_op_s(String name) {
		this();
		super.name = name;
	}
	public neg_op_s(String name, int width) {
		this(width);
		super.name = name;
	}
	public String getVHDLDeclaration() {
		StringBuffer d = new StringBuffer();
		d.append("component neg_op_s\n");  
		d.append("generic (\n");
		d.append("	w_in	: integer := 16;\n");
		d.append("	w_out	: integer := 16\n");
		d.append(");\n");
		d.append("port (\n");
		d.append("	I0	: in	std_logic_vector(w_in-1 downto 0);\n");
		d.append("	O0	: out	std_logic_vector(w_out-1 downto 0)\n");
		d.append(");\n");
		d.append("end component;\n");
		d.append("\n");
		return d.toString();
	}
	public String getDotName() {
		return "!";
	}
}