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

package br.ufscar.dc.lalp.components;

import br.ufscar.dc.lalp.core.IOComponent;
import br.ufscar.dc.lalp.core.Parameters;
import br.ufscar.dc.lalp.core.Port;
import br.ufscar.dc.lalp.core.PortType;

/**
 * An OUTPUT signal of the <code>Design</code>.
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>


 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version September, 2007
 */
public class output extends IOComponent {
	public output(String name) {
		super(name);
		super.type = PortType.OUTPUT;
		Port p = new Port(name, PortType.INPUT);
		super.setPort(p);
	}
	public output(String name, int width) {
		super(name, width);
		super.type = PortType.OUTPUT;
		Port p = new Port(name, PortType.INPUT, width);
		super.setPort(p);
	}
	public output(String name, boolean bus) {
		this(name, Parameters.getDefaultDataWidth());
	}
}
