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

package br.ufscar.dc.lalp.core;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

/**
 * An intermediate component.
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>


 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version September, 2007
 * 
 * @see Component
 * @see Port
 * @see Generic
 */
public abstract class IComponent extends Component implements ComponentInterface {
	
	protected Map<String,Generic> generics = new TreeMap<String,Generic>();
	protected Map<String,Port> ports = new TreeMap<String,Port>();

	public IComponent() {
		super();
		this.width = Parameters.getDefaultDataWidth();
	}
	public IComponent(int width) {
		super();
		this.width = width;
	}
	public IComponent(String name) {
		this();
		super.name = name;
	}
	public IComponent(String name, int width) {
		this(width);
		super.name = name;
	}
	public void addGeneric(Generic generic) {
		this.generics.put(generic.getName(),generic);
		generic.setComponent(this);
	}
	/**
	 * Add Port to IComponent and update the Component reference in the Port
	 * @param port
	 */
	public void addPort(Port port) {
		this.ports.put(port.getName(), port);
		port.setComponent(this);
	}
	public void addPort(Port port, boolean defaultOutput) {
		addPort(port);
		if (defaultOutput) {
			if (port.getType() == PortType.INPUT)
				this.defaultInput = port;
			else
				this.defaultOutput = port;
		}
	}
	public Generic getGeneric(String name) {
		return generics.get(name);
	}
	public Map<String,Generic> getGenerics() {
		return generics;
	}
	public Port getPort(String name) {
		return ports.get(name);
	}
	public Map<String,Port> getPortsByName() {
		return ports;
	}
	public Set<Port> getPorts() {
		Set<Port> sp = new HashSet<Port>();
		for (Port p : ports.values())
			sp.add(p);
		return sp;
	}
	public String getVHDLDeclaration() {
		return "";
	}
	public String getVHDLInstantiation() {
		boolean f;
		StringBuffer inst = new StringBuffer();
		inst.append("\t\\" + getName() + "\\: " + getVHDLInstantiationName() + "\n");
		// list all generics
		if (!getGenerics().isEmpty()) {
			inst.append("\tgeneric map (\n");
			f = false;
			for ( Map.Entry<String,Generic> s: getGenerics().entrySet()) {
				if (f) {
					inst.append(",\n");
				}
				else {
					f = true;
				}
				inst.append("\t\t" + s.getKey() + " => " + s.getValue().getValue());
			}
			inst.append("\n\t)\n");
		}
		inst.append("\tport map (\n");
		f = false;
		for (Port p : getPortsByName().values()) {
			Signal s = p.getSignal();
			// port have an associated signal
			if (s != null) {  
				Signal alias = s.getSignal();
				while (alias != null) {
					s = alias;
					alias = s.getSignal();
				}
				if (f) {
					inst.append(",\n");
				}
				else {
					f = true;
				}
				// port and signal has the same type
				if (p.getDataType() == s.getDataType()) {
					// port and signal has the same width
					if (p.getWidth() == s.getWidth()) {
						inst.append("\t\t" + p.getName() + " => " + s.getName());
					}
					// assign lsb bits
					else {
						if (p.getWidth() < s.getWidth()) {
							inst.append("\t\t" + p.getName() + "(" + (p.getWidth()-1) + " downto 0) => " + s.getName() + "(" + (p.getWidth()-1) + " downto 0)");
						}
						else {
							inst.append("\t\t" + p.getName() + "(" + (s.getWidth()-1) + " downto 0) => " + s.getName() + "(" + (s.getWidth()-1) + " downto 0)");
						}
					}
				}
				//try to associate "std_logic" and "std_logic_vector(0 downto 0)" ports
				else { 
					if (s.getDataType() == VHDLType.STD_LOGIC)
						inst.append("\t\t" + p.getName() + "(0) => " + s.getName());
					else
						inst.append("\t\t" + p.getName() + " => " + s.getName() + "(0)");
				}
			}
			else {
				// special kind of port able to connect multiple signals
				if (p instanceof LargePort) {
					int bits = p.getWidth()-1;
					for ( Map.Entry<Integer,Signal> is : ((LargePort)p).getSignals().entrySet()) {
						if (f) {
							inst.append(",\n");
						}
						else {
							f = true;
						}
						Signal sp = is.getValue();
						Signal alias = sp.getSignal();
						while (alias != null) {
							sp = alias;
							alias = sp.getSignal();
						}
						///TODO: menotti??? I can't remember...
						inst.append("\t\t" + p.getName() + "(" + bits + " downto " + (-is.getKey()) + ") => " + sp.getName() + "(" + (sp.getWidth()-1) + " downto 0)");
						bits = -is.getKey()-1;
					}
				}
				// port does not have an associated signal, try to find a global signal
				// port with global name association
				else {
					if (getDesign().getGlobalComponent(p.getName()) != null) {
						if (f) {
							inst.append(",\n");
						}
						else {
							f = true;
						}
						inst.append("\t\t" + p.getName() + " => \\" + p.getName() + "\\");
					}
				}
			}
		}
		inst.append("\n\t);\n\n");
		return new String(inst);
	}
	public String getVHDLInstantiationName() {
		return getClass().getSimpleName();
	}
	public boolean isIComponent() {
		return true;
	}
//	public void rank(int weight) {
//		setTime(weight + getDelay() - 1);
//		for (Port sp : getPorts()) {
//			if (sp.getType() != PortType.INPUT) {
//				Signal s = sp.getSignal();
//				if (s != null) {
//					Port dp = s.getDestPort();
//					Component c = dp.getComponent();
//					if (c.isIComponent()) {
//						if (c.getTime()<0) {
//							((IComponent)c).rank(weight + getDelay());
//						}
//					}
//				}
//			}
//		}
//	}
	public void setGenerics(Map<String,Generic> generics) {
		this.generics = generics;
	}
	/**
	 * 
	 * @param name
	 * @param value
	 */
	public void setGenericValue(String name, int value) throws Exception { //TODO: port width
		Generic g = getGeneric(name); 
		if (g != null) {
			g.setValue(value);
			Component c = g.getComponent();
			if (c.isIComponent()) {
				IComponent ic = (IComponent)c;
				for (Port p : ic.getPortsByName().values()) {
					if (p.getGeneric() == g) {
						p.setWidth(value);
					}
				}
			}
			else {
				throw new Exception("Generic not found in this component");
			}
		}
	}
	public void setPorts(Map<String,Port> ports) {
		this.ports = ports;
	}
	public String getDotShape() {
		return "doubleoctagon";
	}
}
