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

import java.util.HashSet;
import java.util.Set;


/**
 * An Input/Output component.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version September, 2007
 * 
 * @see Component
 * @see Port
 */
public abstract class IOComponent extends Component implements ComponentInterface {
	protected Port port;
	protected PortType type;
	
	public IOComponent() {
		super();
		setSync(false);
	}
	public IOComponent(int width) {
		super(width);
		setSync(false);
	}
	public IOComponent(String name) {
		this();
		this.name = name;
	}
	public IOComponent(String name, int width) {
		this(width);
		this.name = name;
	}
	/**
	 * @return The component class and instance name in the "class:name" format and the size if it applies 
	 */
	public String getFullName() {
		if (port.getDataType() == VHDLType.STD_LOGIC)
			return this.getClass().getSimpleName() + ":" + name;
		else
			return this.getClass().getSimpleName() + ":" + name + "[" + getWidth() + "]";
	}
	public Port getPort() {
		return port;
	}
	public Set<Port> getPorts() {
		Set<Port> ports = new HashSet<Port>();
		ports.add(port);
		return ports;
	}
	public Port getDefaultInput() {
		return port;
	}
	public Port getDefaultOutput() {
		return port;
	}
	public PortType getType() {
		return this.type;
	}
	public boolean isIOComponent() {
		return true;
	}
	public void setPort(Port port) {
		this.port = port;
		super.defaultInput = port;
		super.defaultOutput = port;
		port.setComponent(this);
	}
}
