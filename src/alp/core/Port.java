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

package alp.core;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;


/**
 * Specifies Input/Output parameters for <code>Component</code> and <code>Signal</code>.
 * The default constructors creates a single bit port with STD_LOGIC type 
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 * 
 * @see Signal
 * @see Component
 */
public class Port {
	private Component component;
	private VHDLType dataType = VHDLType.STD_LOGIC;
	private Generic genericWidth;
	private String name;
	private PortType type;
	protected int width = 1;
	Signal signal;
	private int time = -1;
	
	//user for update por time
	public boolean visited = false;
	
	public Port(String name, PortType type) {
		this.name = name;
		this.type = type;
	}
	public Port(String name, PortType type, Generic generic) {
		this(name, type);
		this.genericWidth = generic;
	}
	public Port(String name, PortType type, int width) {
		this(name, type);
		this.width = width;
		this.dataType = VHDLType.STD_LOGIC_VECTOR;
	}
	public Port(String name, PortType type, int width, Generic generic) {
		this(name, type, width);
		this.genericWidth = generic;
		generic.setValue(width);
	}
	public Component getComponent() {
		return component;
	}
	public VHDLType getDataType() {
		return dataType;
	}
	public Generic getGeneric() {
		return genericWidth;
	}
	public Generic getGenericWidth() {
		return genericWidth;
	}
	public String getName() {
		return name;
	}
	public String getNameSized() {
		if (dataType == VHDLType.STD_LOGIC_VECTOR)
			return getName() + "[" + width + "]";
		else
			return getName();
	}
	public String getNameSizedTimed() {
		if (getTime() < 0)
			return getNameSized();
		else
			return "t" + getTime() + ":" + getNameSized();
				
	}
	public PortType getType() {
		return type;
	}
	public int getTime() {
		return time;
	}
	public int getWidth() {
		return width;
	}
	public void setComponent(Component component) {
		this.component = component;
	}
	public void setDataType(VHDLType dataType) {
		this.dataType = dataType;
	}
	public void setGeneric(Generic generic) {
		this.genericWidth = generic;
	}
	public void setGenericWidth(Generic genericWidth) {
		this.genericWidth = genericWidth;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setTime(int time) {
		this.time = time;
	}
	public void setType(PortType type) {
		this.type = type;
	}
	/**
	 * Update port width and the associated generic if it applies 
	 * @param width
	 */
	public void setWidth(int width) {
		this.width = width;
		if (genericWidth != null)
			genericWidth.setValue(width);
	}
	public Signal getSignal() {
		return signal;
	}
	public void setSignal(Signal signal) {
		if (this.signal == null)
			this.signal = signal;
		else
			this.signal.setSignal(signal);
	}
	//TODO: need to check if the cleared signal does't have an alias
	public void clearSignal() {
		this.signal = null;
	}
	public void resetTime() {
		this.time = -1;
	}
	public void updateTime(int inputTime) {
		if (this.time < 0) {
//			DEBUG print port times 
//			System.out.println("Port " + getNameSized() + " of Component " + getComponent().getFullName() + " has time " + inputTime);
			this.time = inputTime;
			if (getType() == PortType.OUTPUT) {
				Signal s = getSignal();
				while (s != null) {
					s.getDestPort().updateTime(inputTime);
					s = s.getSignal();
				}
			}
			if (getType() == PortType.INPUT) {
				Component c = getComponent();
				if (c.getTime() < 0) {
					c.setTime(inputTime);
					if (c instanceof IComponent) {
						Map<String,Port> ports = ((IComponent)c).getPortsByName();
						for (Map.Entry<String,Port> sp : ports.entrySet()) {
							if (sp.getValue().getType() == PortType.OUTPUT)
								sp.getValue().updateTime(inputTime + c.getDelay());
						}
					}
				}
			}
		}
	}
	public boolean isVisited() {
		return visited;
	}
	public void setVisited(boolean visited) {
		this.visited = visited;
	}
	public Set<Port> getOppositePorts() {
		Set<Port> ports = new HashSet<Port>();
		Signal s = this.getSignal();
		if (this.getType() == PortType.INPUT) {
			ports.add(s.getSourcePort());
		}
		else {
			while (s != null) {
				ports.add(s.getDestPort());
				s = s.getSignal();
			}
		}
		return ports;
	}
	public String toString() {
		return name;
	}
}
