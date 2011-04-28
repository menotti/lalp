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

package lalp.algorithms;

import lalp.core.Component;
import lalp.core.Design;
import lalp.core.IComponent;
import lalp.core.Port;

/* TODO FIXME
 * Considenrando somente os SCC propagar o atraso desde o inicio e remover a aresta que apresentar a 
 * maior diferenca entre seu tempo e o componente que que ela chega, desde que seja parte do ciclo (scc)
 * Fazer isso iterativamente ate que se obtenha um grafo aciclico...
 */


/** * implementations 
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version March, 2008
 */
public class Misc {

	public void UpdatePortTime(Design design) {
		zeroUnconnectedPortTimes(design);
		Component init = (Component)design.getInit();
		Port p = init.getDefaultOutput();
		p.updateTime(0);
	}
	
	public void zeroUnconnectedPortTimes(Design design) {
		for (Component c : design.getComponents())
			if (c instanceof IComponent) {
				for (Port p : ((IComponent)c).getPortsByName().values()) {
					if (p.getSignal() == null)
						p.setTime(0);
				}
			}
	}
}