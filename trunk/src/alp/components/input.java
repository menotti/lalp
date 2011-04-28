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
import alp.core.Port;
import alp.core.PortType;

/**
 * An INPUT signal of the <code>Design</code>.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version September, 2007
 */
public class input extends IOComponent {
	public input(String name) {
		super(name);
		super.type = PortType.INPUT;
		Port p = new Port(name, PortType.OUTPUT);
		super.setPort(p);
	}
	public input(String name, int width) {
		super(name, width);
		super.type = PortType.INPUT;
		Port p = new Port(name, PortType.OUTPUT, width);
		super.setPort(p);
	}
}
