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

package alp.algorithms;

import java.util.HashSet;
import java.util.Set;

import alp.ALP;
import alp.core.Component;
import alp.core.Design;
import alp.core.Parameters;
import edu.uci.ics.jung.utils.UserData;

/**
 * Used to determine cycles 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version March, 2008
 */
public class Dijkstra {
	
	int cycle, bigest = 0;
	
	public int detectBigestCycle(Design design) {
		System.out.print("\nCalculating Dijkstra for bigest cycle...");
		ExecutionTimer t = new ExecutionTimer();
		t.start();
		HashSet<Component> bigestNodes = null;
		int dist;
		bigest = 0;
		for (Component c : design.getComponents()) {
			if ((c.getUserDatum("scc") != null) && (c.getUserDatum("scc").equals(0)))
				continue;
			HashSet<Component> nodes = new HashSet<Component>();
			design.resetComponentDistances();
			dist = calculateDijkstraDistance(design, c, c, nodes);
			if ((dist > bigest) && (dist != Integer.MAX_VALUE)) {
				bigest = dist;
				bigestNodes = nodes;
				if (Parameters.verbose)
					ALP.info("from component " + c + ": " + bigest + " cycles");
			}
		}
		
		for (Component c : design.getComponents()) {
			if (bigestNodes != null && bigestNodes.contains(c)) {
				if (((Component)c).getUserDatum("cycle") == null)
					((Component)c).addUserDatum("cycle", new Integer(1), UserData.SHARED);
				else
					((Component)c).setUserDatum("cycle", new Integer(1), UserData.SHARED);
			}
		}
	    t.end();
	    System.out.println(bigest+" Ok! " + t.duration() + " ms");
		return bigest;
	}
	
	public int calculateDijkstraDistance(Design design, Component source, Component dest, HashSet<Component> path) {
		int ant, nova;
		Component u;
		Set<Component> q = new HashSet<Component>();
		Set<Component> s = new HashSet<Component>();
		for (Component c : design.getComponents()) {
			q.add(c);
			nova = getSucessorDistance(source, c);
			c.setDistance(nova);
			c.setPrevious(null);
		}
		while (!q.isEmpty()) {
			u = null;
			// procura minimo
			for (Component c : q) {
				if (u == null)
					u = c;
				nova = u.getDistance();
				ant = c.getDistance();
				if (nova > ant)
					u = c;
			}
			s.add(u);
			q.remove(u);
			for (Object o : u.getSuccessors()) {
				Component v = (Component)o;
				nova = u.getDistance() + getSucessorDistance(u, v);
				ant = v.getDistance();
				if (nova < ant)
					if (getSucessorDistance(u, v) != Integer.MAX_VALUE && u.getDistance() != Integer.MAX_VALUE) {
						v.setDistance(nova);
						v.setPrevious(u);
					}
			}
		}
		if (source.getDistance() != Integer.MAX_VALUE) {
			u = source;
			path.add(u);
			u = u.getPrevious();
			while ((u != null) && (u != source)) {
				path.add(u);
				u = u.getPrevious();
			}
		}
		return source.getDistance();
	}
	
	/**
	 * @param source
	 * @param dest
	 * @return The delay of source component or infinite 
	 */
	public int getSucessorDistance(Component source, Component dest) {
		if (dest.isSuccessorOf(source))
			return source.getDelay();
		else
			return Integer.MAX_VALUE;
	}
}