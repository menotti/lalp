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

import alp.core.IOComponent;
import alp.core.Parameters;
import alp.core.Port;
import alp.core.PortType;

/**
 * A constant signal of the <code>Design</code>.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version September, 2007
 */
public class const_op extends IOComponent {
	protected Long value = 0l;
	public const_op(int value) {
		this((long)value);
	}
	public const_op(long value) {
		this(value, Parameters.getDefaultDataWidth());
	}
	public const_op(int value, boolean bus) {
		this(value);
	}
	public const_op(int value, int width) {
		this((long)value, width);
	}
	public const_op(long value, int width) {
		super(width);
		super.type = PortType.INPUT;
		this.value = value;
		Port p = new Port(name, PortType.OUTPUT, width);
		super.setPort(p);
	}
	public const_op(String name, int value) {
		this(value);
		super.name = name;
	}
	public const_op(String name, int value, int width) {
		this(value, width);
		super.name = name;
	}
	public String getNodeName() {
		return super.name + "=0x" + Long.toHexString(this.value);
	}
	public String getDotName() {
		return "0x" + Long.toHexString(this.value);
	}
	public boolean isIOComponent() {
		return false;
	}
	public Long getValue() {
		return this.value;
	}
	public void setValue(long value) {
		this.value = value;
	}
}
