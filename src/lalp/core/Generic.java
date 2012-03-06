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

/**
 * A class to store the <code>generic map</code> session of the components.
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>


 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version September, 2007
 * 
 * @see IComponent
 */
public class Generic {
	private String name;
	private String type;
	// TODO: sometimes value is not integer (e.g. std_logic)
	private int value;
	private Component component;
	
	public Generic(String name, String type, int value) {
		this.name = name;
		this.type = type;
		this.value = value;
	}
	public Component getComponent() {
		return component;
	}
	public String getName() {
		return name;
	}
	public String getType() {
		return type;
	}
	public int getValue() {
		return value;
	}
	public void setComponent(Component component) {
		this.component = component;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setType(String type) {
		this.type = type;
	}
	public void setValue(int value) {
		this.value = value;
	}
}
