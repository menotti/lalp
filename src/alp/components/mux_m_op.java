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
import alp.core.LargePort;
import alp.core.Parameters;
import alp.core.Port;
import alp.core.PortType;

/**
 * A multiplexer with M inputs.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version September, 2007
 */
public class mux_m_op extends IComponent {
	protected int nOps = 32;
	protected int nSels = 31;
	public mux_m_op() {
		this(Parameters.getDefaultDataWidth(), 32, 31);
	}
	public mux_m_op(int width, int nOps, int nSels) {
		super(width);
		this.nOps = nOps;
		this.nSels = nSels;
		setSync(false);
		Generic generic;
		generic = new Generic("w_in", "integer", width);
		super.addPort(new Port("O0", PortType.OUTPUT, width, generic), true);
		super.addGeneric(generic);
		generic = new Generic("N_sels", "integer", nSels);
		super.addPort(new LargePort("Sel", PortType.INPUT, nSels, generic), true);
		super.addGeneric(generic);
		super.addPort(new LargePort("I0", PortType.INPUT, width*nOps));
		generic = new Generic("N_ops", "integer", nOps);
		super.addGeneric(generic);
	}
	public mux_m_op(String name) {
		this();
		super.name = name;
	}
	public mux_m_op(String name, int width, int nOps, int nSels) {
		this(width, nOps, nSels);
		super.name = name;
	}
	public String getVHDLDeclaration() {
		StringBuffer d = new StringBuffer();
		d.append("component mux_m_op\n");
		d.append("generic (\n");
		d.append("	w_in	: integer := 32;\n");
		d.append("	N_ops	: integer := 32;\n");
		d.append("	N_sels	: integer := 31\n");
		d.append(");\n");
		d.append("port (\n");
		d.append("	I0	: in	std_logic_vector((w_in*N_ops)-1 downto 0);\n");
		d.append("	Sel	: in	std_logic_vector(N_sels-1 downto 0);\n");
		d.append("	O0	: out	std_logic_vector(w_in-1 downto 0)\n");
		d.append(");\n");
		d.append("end component;\n");		
		return d.toString();
	}
	public int getNOps() {
		return nOps;
	}
	public void setNOps(int ops) {
		nOps = ops;
	}
	public int getNSels() {
		return nSels;
	}
	public void setNSels(int sels) {
		nSels = sels;
	}
}
