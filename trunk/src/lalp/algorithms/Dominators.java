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

import java.io.DataOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import lalp.core.Component;
import lalp.core.Design;
import lalp.core.Signal;



/**
 * Just for single entry loops
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version March, 2008
 * @deprecated
 * @see http://compilers.iecc.com/comparch/article/94-01-053
 */
public class Dominators {
	
	public static final int WHITE = 0;
	public static final int GRAY = 1;
	public static final int BLACK = 2;
	public int level = 0;
	public Map<Integer, Component> doms;
	Component new_idom;

	public void detectBackwardEdges(Design design) {
		calculateDominatorsWikipedia(design, design.getInit());
		for (Signal s : design.getSignals()) {
			Component source = (Component)s.getSource();
			Component dest = (Component)s.getDest();
			if (source.dominators.contains(dest)) {
				s.setBackEdge(true);
			}
		}
	}
	
	public void calculateDominatorsCooper1999(Design design, Component entryPoint) {
		System.out.print("Calculating dominators...");
		ExecutionTimer t = new ExecutionTimer();
		t.start();
		doms = new TreeMap<Integer, Component>();
		for (Component c : design.getComponents())
			c.domStatus = WHITE;
		visit(entryPoint);
		entryPoint.idom = entryPoint;
		boolean changed = true;
		while (changed) {
			changed = false;
			for (Map.Entry<Integer, Component> eb : doms.entrySet()) {
				Component b = eb.getValue();
				if (b != entryPoint) {
					new_idom = null;
					for (Component p : b.getPredecessors()) {
						if (new_idom == null) {
							b.idom = p;
							new_idom = p;
						}
						else {
							if (p.idom != null) {
								new_idom = intersect(p, new_idom);
								b.idom = new_idom;
							}
						}
					}
					if (b.idom != new_idom) {
						b.idom = new_idom;
						changed = true;
					}
				}
			}
		}
		// update domintors Set for each Component
		for (Component c : design.getComponents()) {
			c.dominators = new HashSet<Component>();
			c.dominators.add(c);
			new_idom = c.idom;
			c.dominators.add(new_idom);
			do {
				new_idom = new_idom.idom;
				c.dominators.add(new_idom);
			} while (new_idom != entryPoint);
		}
	    t.end();
	    System.out.println("Ok! " + t.duration() + " ms");
	}
	
	public void visit(Component c) {
		c.domStatus = GRAY;
		for (Component succ : c.getSuccessors()) {
			if (succ.domStatus == WHITE)
				visit(succ);
		}
		c.level = ++level;
		doms.put(-level, c);
		c.domStatus = BLACK;
	}
	
	public Component intersect(Component b1, Component b2) {
		Component finger1 = b1;
		Component finger2 = b2;
		while (finger1 != finger2) {
			while (finger1.level < finger2.level)
				finger1 = finger1.idom;
			while (finger2.level < finger1.level)
				finger2 = finger2.idom;
		}
		return finger1;
	}
	
	public void calculateDominatorsWikipedia(Design design, Component entryPoint) {
		System.out.print("Calculating dominators...");
		ExecutionTimer t = new ExecutionTimer();
		t.start();
		boolean change = true;
		boolean allPredecessors;
		for (Component c : design.getComponents()) {
			c.dominators = new HashSet<Component>();
			if (c != entryPoint) {
				for (Component d : design.getComponents())
					c.dominators.add(d);
			}
			else {
				c.dominators.add(c);
			}
		}
		while (change) {
			change = false;
			for (Component n : design.getComponents()) {
				if (n != entryPoint) {
					Set<Component> dominators = new HashSet<Component>();
					dominators.add(n);
					for (Component p : design.getComponents()) {
						allPredecessors = true;
						if (p.getPredecessors().size() == 0)
							allPredecessors = false;
						for (Component a : (Set<Component>)n.getPredecessors()) {
							if (!a.dominators.contains(p))
								allPredecessors = false;
						}
						if (allPredecessors) {
							dominators.add(p);
						}
					}
					if (!n.dominators.equals(dominators)) {
						change = true;
						n.dominators = dominators;
					}
				}
			}
		}
	    t.end();
	    System.out.println("Ok! " + t.duration() + " ms");
	}
	
	public void generateReport(Design design) {
		System.out.print("Generating Dominators Report...");
		String fileName;
		fileName = design.getName() + ".dominators.html";
		try {
			FileOutputStream outputFile = new FileOutputStream("out" + System.getProperty("file.separator") + fileName);
			DataOutputStream dataOut = new DataOutputStream(outputFile);
			dataOut.writeBytes("<html>\n");
			dataOut.writeBytes("<head>\n");
			dataOut.writeBytes("<title>Dominators in design "+design.getName()+"</title>\n");
			dataOut.writeBytes("</head>\n");
			dataOut.writeBytes("<body>\n");
			dataOut.writeBytes("<pre>\n");
			for (Component c : design.getComponents()) {
				dataOut.writeBytes("\n"+c.getFullName()+"\n");			
				for (Component d : c.dominators) {
					dataOut.writeBytes("\t"+d.getFullName()+"\n");			
				}
			}
			dataOut.writeBytes("</pre>\n");
			dataOut.writeBytes("</body>\n");
			dataOut.writeBytes("</html>\n");
			dataOut.close();
		}
		catch(IOException e) {
			System.out.println("Problem creating file!");
			e.printStackTrace();
		}	
		System.out.println("Ok!");

	}
}