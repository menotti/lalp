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
 * A counter with load, variable stop condition and increment.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version January, 2009
 */
public class counter extends IComponent {
	protected int condition = 0;
	protected int increment = 1;
	protected int steps = 1;
	protected int down = 0;
	public counter() {
		this(Parameters.getDefaultDataWidth());
	}
	public counter(String name) {
		this();
		super.name = name;
	}
	public counter(int width) {
		super(width);
		Generic generic;
		generic = new Generic("steps", "integer", 1);
		super.addGeneric(generic);
		generic = new Generic("increment", "integer", 1);
		super.addGeneric(generic);
		generic = new Generic("down", "integer", 0);
		super.addGeneric(generic);
		generic = new Generic("condition", "integer", 0);
		super.addGeneric(generic);
		generic = new Generic("bits", "integer", 8);
		super.addGeneric(generic);
		super.addPort(new Port("input", PortType.INPUT, width, generic), true);
		super.addPort(new Port("termination", PortType.INPUT, width, generic));
		super.addPort(new Port("clk", PortType.INPUT));
		super.addPort(new Port("clk_en", PortType.INPUT), true);
		super.addPort(new Port("reset", PortType.INPUT));
		super.addPort(new Port("load", PortType.INPUT));
		super.addPort(new Port("output", PortType.OUTPUT, width, generic), true);
		super.addPort(new Port("step", PortType.OUTPUT));
		super.addPort(new Port("done", PortType.OUTPUT));
	}
	public counter(String name, int width) {
		this(width);
		super.name = name;
	}
	public counter(String name, int width, int steps, int increment, int down, int condition) {
		this(width, steps, increment, down, condition);
		super.name = name;
	}
	public counter(int width, int steps, int increment, int down, int condition) {
		this(width);
		try {
			setGenericValue("steps", steps);
			setGenericValue("increment", increment);
			setGenericValue("down", down);
			setGenericValue("condition", condition);
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.steps = steps;
		this.increment = increment;
		this.down = down;
		this.condition = condition;
	}
	public static int getConditionValue(String s) {
		int condition = 0;
		if (s.equals("<="))
			condition = 1;
		else if (s.equals(">"))
			condition = 2;
		else if (s.equals(">="))
			condition = 3;
		else if (s.equals("=="))
			condition = 4;
		else if (s.equals("!="))
			condition = 5;
		return condition;
	}
	public String getConditionText() {
		return getConditionText(this.condition);
	}
	public static String getConditionText(int condition) {
		switch (condition) {
		case 0:
			return "<";
		case 1:
			return "<=";
		case 2:
			return ">";
		case 3:
			return ">=";
		case 4:
			return "==";
		case 5:
			return "!=";
		default:
			return "";
		}
	}
	public String getNodeName() {
		return this.getClass().getSimpleName() + ":" + super.name + "\\n\\" + 
		getConditionText() + "\\n"+(down==0?"+=":"-=") +increment+ "\\nsteps=" + steps;
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component counter\n";
		d += "generic (\n";
		d += "	bits		: integer := 8;\n";
		d += "	steps		: integer := 1;\n";
		d += "	increment	: integer := 1;\n";
		d += "	down	: integer := 0;\n";
		d += "	condition : integer := 0\n";
		d += ");\n";
		d += "port (\n";
		d += "	input		: in	std_logic_vector(bits-1 downto 0);\n";
		d += "	termination	: in	std_logic_vector(bits-1 downto 0);\n";
		d += "	clk			: in	std_logic;\n";
		d += "	clk_en		: in	std_logic := '1';\n";
		d += "	reset		: in	std_logic;\n";
		d += "	load		: in	std_logic := '0';\n";
		d += "	step		: out	std_logic;\n";
		d += "	done		: out	std_logic;\n";
		d += "	output		: out	std_logic_vector(bits-1 downto 0)\n";
		d += ");\n";
		d += "end component;\n";
		d += "\n";
		return d;
	}
	public int getCondition() {
		return condition;
	}
	public void setCondition(int condition) {
		this.condition = condition;
	}
	public int getIncrement() {
		return increment;
	}
	public void setIncrement(int increment) {
		this.increment = increment;
	}
	public int getSteps() {
		return steps;
	}
	public void setSteps(int steps) {
		this.steps = steps;
	}
	public int getDown() {
		return down;
	}
	public void setDown(int down) {
		this.down = down;
	}
}
