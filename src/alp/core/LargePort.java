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

import java.util.Map;
import java.util.TreeMap;

/**
 * Specifies Input/Output parameters for <code>Component</code> and <code>Signal</code>.
 * Used for components which connects multiple signals in a single port (eg. bus mux) 
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version September, 2007
 * 
 * @see Signal
 * @see Component
 * @see Port
 */public class LargePort extends Port {
	Map<Integer,Signal> signals = new TreeMap<Integer,Signal>();
	int lastConnectedBit = -super.width;
	public LargePort(String name, PortType type, int width, Generic generic) {
		super(name, type, width, generic);
	}
	public LargePort(String name, PortType type, int width) {
		super(name, type, width);
	}
	public boolean addSignal(Signal s) {
		if (lastConnectedBit == 0)
			return false;
		else {
			lastConnectedBit += s.getWidth();
			signals.put(lastConnectedBit, s);
			return true;
		}
	}
	public Map<Integer,Signal> getSignals() {
		return signals;
	}
	public Signal getSignalAt(Integer i) {
		return signals.get(i);
	}
}
