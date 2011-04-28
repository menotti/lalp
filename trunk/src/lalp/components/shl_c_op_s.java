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
 * Signed SHifT Left by constant.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version September, 2007
 */
public class shl_c_op_s extends IComponent {
	protected int amount = 1;
	public shl_c_op_s() {
		this(1);
	}
	public shl_c_op_s(int amount) {
		this(amount, Parameters.getDefaultDataWidth());
	}
	public shl_c_op_s(int amount, int width) {
		super(width);
		setSync(false);
		Generic generic;
		generic = new Generic("w_in1", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("I0", PortType.INPUT, width, generic), true);
		generic = new Generic("w_out", "integer", 15);
		super.addGeneric(generic);
		super.addPort(new Port("O0", PortType.OUTPUT, width, generic), true);
		generic = new Generic("s_amount", "integer", 1);
		super.addGeneric(generic);
		setAmount(amount);
	}
	public shl_c_op_s(String name) {
		this();
		super.name = name;
	}
	public shl_c_op_s(String name, int amount) {
		this(amount);
		super.name = name;
	}
	public shl_c_op_s(String name, int amount, int width) {
		this(amount, width);
		super.name = name;
	}
	public String getNodeName() {
		return this.getClass().getSimpleName() + ":" + super.name + "\\namount=" + amount;
	}
	public String getVHDLDeclaration() {
		StringBuffer d = new StringBuffer();
		d.append("component shl_c_op_s\n");  
		d.append("generic (\n");
		d.append("	w_in1	: integer := 16;\n");
		d.append("	w_out	: integer := 15;\n");
		d.append("	s_amount	: integer := 1\n");
		d.append(");\n");
		d.append("port (\n");
		d.append("	I0	: in	std_logic_vector(w_in1-1 downto 0);\n");
		d.append("	O0	: out	std_logic_vector(w_out-1 downto 0)\n");
		d.append(");\n");
		d.append("end component;\n");
		d.append("\n");
		return d.toString();
	}
	public void setAmount(int amount) {
		try {
			setGenericValue("s_amount", amount);
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.amount = amount;
	}
	public String getDotName() {
		return super.name + ":<<";
	}
	public int getAmount() {
		return amount;
	}
}
