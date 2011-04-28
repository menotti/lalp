/* Copyright (c) 2007 Ricardo Menotti, All Rights Reserved.
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

package alp.algorithms;

import java.util.Map;

import alp.core.Component;
import alp.core.Design;
import alp.core.IComponent;
import alp.core.IOComponent;
import alp.core.Port;
import alp.core.Signal;


/**
 * Used for dump informations about designs
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version October, 2008
 * @see Design
 * @see Port
 * @see Component
 * @see Signal
 */
public class Debug {
	/**
	 * Dump a text representation of the design on standard output
	 */
	public void designDump(Design design) {
		System.out.println("Design: " + design.getName() + "\nPorts:");
		for (Map.Entry<String,Component> s : design.getGlobalComponents().entrySet()) {
			System.out.println("\t" + ((IOComponent)s.getValue()).getFullName() + "(G)");
		}
		for (Component c : design.getComponents()) {
			if (c.isIOComponent()) {
				System.out.print("\t" + ((IOComponent)c).getFullName());
				Signal s = ((IOComponent)c).getPort().getSignal();
				if (s != null)
					System.out.println("\t => " + s.getNameSized());
				else
					System.out.println();
			}
		}
		System.out.println("Signals:");
		for (Signal s : design.getSignals()) {
			System.out.println("\t" + s.getNameSized());
		}
		System.out.println("Components:"); 
		for (Component c : design.getComponents()) {
			if (c.isIComponent()) {
				System.out.println("\t" + c.getFullName());
				for (Port p : ((IComponent)c).getPortsByName().values()) {
					System.out.print("\t\t" + p.getType() + "\t" + p.getNameSized());
					Signal s = p.getSignal();
					if (s != null)
						System.out.println("\t => " + s.getNameSized());
					else
						System.out.println();
				}
			}
		}
	}
}
