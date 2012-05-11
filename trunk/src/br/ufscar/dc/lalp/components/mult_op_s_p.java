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
 * The signed MULT operation with pipeline stages.
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>


 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version September, 2007
 */
public class mult_op_s_p extends IComponent {
	public mult_op_s_p() {
		this(Parameters.getDefaultDataWidth());
	}
	public mult_op_s_p(int width) {
		super(width);
		Generic generic;
		super.addPort(new Port("clk", PortType.INPUT));
		generic = new Generic("k", "integer", 5);
		super.addGeneric(generic);
		generic = new Generic("w_in1", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("I0", PortType.INPUT, width, generic));
		generic = new Generic("w_in2", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("I1", PortType.INPUT, width, generic));
		generic = new Generic("w_out", "integer", 32);
		super.addGeneric(generic);
		super.addPort(new Port("O0", PortType.OUTPUT, width, generic), true);
		setDelay(5);
	}
	public mult_op_s_p(String name) {
		this();
		super.name = name;
	}
	public mult_op_s_p(String name, int width) {
		this(width);
		super.name = name;
	}
	public mult_op_s_p(String name, int steps, int width) {
		this(width);
		super.name = name;
		setDelay(steps);
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component mult_op_s_p\n";  
		d += "generic (\n";
		d += "	w_in1	: integer := 16;\n";
		d += "	w_in2	: integer := 16;\n";
		d += "	w_out	: integer := 32;\n";
		d += "	k: integer := 5 -- number of pipeline stages\n";
		d += ");\n";
		d += "port (\n";
		d += "	clk	: in	std_logic;\n";
		d += "	I0	: in	std_logic_vector(w_in1-1 downto 0);\n";
		d += "	I1	: in	std_logic_vector(w_in2-1 downto 0);\n";
		d += "	O0	: out	std_logic_vector(w_out-1 downto 0)\n";
		d += ");\n";
		d += "end component;\n";
		d += "\n";
		return d;
	}
	public String getNodeName() {
		return this.getClass().getSimpleName() + ":" + super.name + "\\nk=" + super.delay;
	}

	public String getDotName() {
		return "*";
	}
	
	public void setDelay(int delay) {
		super.setDelay(delay);
		try {
			setGenericValue("k", delay);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
