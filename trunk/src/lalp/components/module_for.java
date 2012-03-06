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
 * A counter.
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>


 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version September, 2007
 */
public class module_for extends IComponent {
	protected int iterations = 256;
	protected int steps = 1;
	public module_for() {
		this(Parameters.getDefaultDataWidth());
	}
	public module_for(int width) {
		super(width);
		Generic generic;
		generic = new Generic("iterations", "integer", 256);
		super.addGeneric(generic);
		generic = new Generic("steps", "integer", 1);
		super.addGeneric(generic);
		generic = new Generic("bits", "integer", 9);
		super.addGeneric(generic);
		generic = new Generic("w_out", "integer", 8);
		super.addGeneric(generic);
		super.addPort(new Port("clk", PortType.INPUT));
		super.addPort(new Port("clk_en", PortType.INPUT), true);
		super.addPort(new Port("reset", PortType.INPUT));
		super.addPort(new Port("clear", PortType.INPUT));
		super.addPort(new Port("output", PortType.OUTPUT, width, generic), true);
		super.addPort(new Port("step", PortType.OUTPUT));
		super.addPort(new Port("done", PortType.OUTPUT));
	}
	public module_for(int width, int iterations) {
		this(width);
		try {
			setGenericValue("iterations", iterations);
			setGenericValue("bits", width+1);
			setGenericValue("w_out", width);
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.iterations = iterations;
	}
	public module_for(int width, int iterations, int steps) {
		this(width, iterations);
		try {
			setGenericValue("steps", steps);
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.steps = steps;
	}
	public module_for(String name) {
		this();
		super.name = name;
	}
	public module_for(String name, int width) {
		this(width);
		super.name = name;
	}
	public module_for(String name, int width, int iterations) {
		this(width, iterations);
		super.name = name;
	}
	public module_for(String name, int width, int iterations, int steps) {
		this(width, iterations, steps);
		super.name = name;
	}
	public String getNodeName() {
		return this.getClass().getSimpleName() + ":" + super.name + "\\niterations=" + iterations + "\\nsteps=" + steps;
	}
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component module_for\n";  
		d += "generic (\n";
		d += "	bits		: integer := 9;\n";
		d += "	iterations	: integer := 256;\n";
		d += "	steps		: integer := 1;\n";
		d += "	w_out		: integer := 8\n";
		d += ");\n";
		d += "port (\n";
		d += "	clk			: in	std_logic;\n";
		d += "	clk_en		: in	std_logic;\n";
		d += "	reset		: in	std_logic;\n";
		d += "	clear		: in	std_logic;\n";
		d += "	step		: out	std_logic;\n";
		d += "	done		: out	std_logic;\n";
		d += "	output		: out	std_logic_vector(w_out-1 downto 0)\n";
		d += ");\n";
		d += "end component;\n";
		d += "\n";
		return d;
	}
}
