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

package lalp.core;

import lalp.components.delay_op;
import edu.uci.ics.jung.graph.impl.DirectedSparseEdge;

/**
 * A directed edge between <code>Component</code>s. 
 * The default constructors creates a single bit signal with STD_LOGIC type 
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>


 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version September, 2007
 * 
 * @see Design
 * @see Port
 */
public class Signal extends DirectedSparseEdge {
	private VHDLType dataType = VHDLType.STD_LOGIC;
	private Port destPort;
	private String name;
	private Port sourcePort;
	Signal alias;
	private int width = 1;
	private boolean backEdge = false; 
	
	public Signal(Component source, Component dest) {
		super(source, dest);
		this.name = "s" + super.id;
	}
	public Signal(Component source, Component dest, String name) {
		this(source, dest);
		this.name = name;
	}
	/**
	 * If the port is an output port update signal width, type and source port.
	 * @param p
	 * @throws Exception 
	 */
	public void connectPort(Port p) throws Exception {
		if (p.getType() == PortType.OUTPUT) {
			this.sourcePort = p;
			p.setSignal(this);
			setDataType(p.getDataType());
			if (p instanceof LargePort) {
				setWidth(p.getComponent().getWidth());
			}
			else {
				setWidth(p.getWidth());
			}
		}			
		else { // input port must have a single signal
			if (p instanceof LargePort) {
				if (!((LargePort)p).addSignal(this))
					throw new Exception("Can't connect port: " + p.getName() + " from component " + p.getComponent().getFullName());
				else
					this.destPort = p;
			}
			else {
				if (p.getSignal() == null) {
					p.setSignal(this);
					this.destPort = p;
				}
				else
					throw new Exception("Can't connect port: " + p.getName() + " from component " + p.getComponent().getFullName());
			}
		}
	}
	public Design getDesign() {
		return (Design)super.getGraph();
	}
	public VHDLType getDataType() {
		return dataType;
	}
	public Port getDestPort() {
		return destPort;
	}
	public String getName() {
		return name;
	}
	public String getNameSized() {
		if (dataType == VHDLType.STD_LOGIC_VECTOR)
			return name + "[" + width + "]";
		return name;
	}
	public Port getSourcePort() {
		return sourcePort;
	}
	public int getWidth() {
		return width;
	}
	public void setDataType(VHDLType dataType) {
		this.dataType = dataType;
	}
	public void setDestPorts(Port destPort) {
		this.destPort = destPort;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setSourcePort(Port sourcePort) {
		this.sourcePort = sourcePort;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public Signal getSignal() {
		return alias;
	}
	public void setSignal(Signal signal) {
		if (this.alias == null)
			this.alias = signal;
		else
			this.alias.setSignal(signal);
	}
	public boolean isCyclic() {
		if (destPort.getComponent().equals(sourcePort.getComponent()))
			return true;
		return false;
	}
	public void insertDelay() {
		insertDelay(1);
	}
	public Component insertDelay(int amount) {
		Design design = this.getDesign();
		Port source = sourcePort;
		Port dest = destPort;
		delay_op delay = (delay_op)design.addComponent(new delay_op(this.getWidth(), amount));
		design.removeSignal(this);
		try {
			source.getComponent().connectComponent(source, delay.getDefaultInput());
			delay.connectComponent(dest);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return delay;
	}
	public boolean isBackEdge() {
		return backEdge;
	}
	public void setBackEdge(boolean backEdge) {
		this.backEdge = backEdge;
	}
}
