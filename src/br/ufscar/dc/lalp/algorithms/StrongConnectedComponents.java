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

package br.ufscar.dc.lalp.algorithms;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import br.ufscar.dc.lalp.core.Component;
import br.ufscar.dc.lalp.core.Design;
import br.ufscar.dc.lalp.core.Signal;



import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.Vertex;
import edu.uci.ics.jung.utils.UserData;

/**
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>
 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version October, 2008
 * @see http://www.personal.kent.edu/~rmuhamma/Algorithms/MyAlgorithms/GraphAlgor/strongComponent.htm
 * @see http://www.patentstorm.us/patents/7444628/description.html
 */
public class StrongConnectedComponents {
	// SCC algorithm variables
	int dfs;
	int level;
	// transpose graph
	Design gt;
	// Stores nodes with finish reverse order
	Map<Integer, Object> sccMap;
	// Stores levels that contains SCC
	Set<Integer> sccLevels;
	public void detectStrongConnectedComponents(Design design) {
		System.out.print("\nCalculating Strong Connected Components...");
		ExecutionTimer t = new ExecutionTimer();
		t.start();
		dfs = 1;
		level = 0;
		gt = new Design();
		sccMap = new TreeMap<Integer, Object>();
		sccLevels = new HashSet<Integer>();
		// initialize visit/finish
		for (Object i : design.getComponents()) {
			if (((Component)i).getUserDatum("visit") == null)
				((Component)i).addUserDatum("visit", new Integer(0), UserData.SHARED);
			else
				((Component)i).setUserDatum("visit", new Integer(0), UserData.SHARED);
			if (((Component)i).getUserDatum("finish") == null)
				((Component)i).addUserDatum("finish", new Integer(0), UserData.SHARED);
			else
				((Component)i).setUserDatum("finish", new Integer(0), UserData.SHARED);
			if (((Component)i).getUserDatum("level") == null)
				((Component)i).addUserDatum("level", new Integer(0), UserData.SHARED);
			else
				((Component)i).setUserDatum("level", new Integer(0), UserData.SHARED);
			if (((Component)i).getUserDatum("scc") == null)
				((Component)i).addUserDatum("scc", new Integer(0), UserData.SHARED);
			else
				((Component)i).setUserDatum("scc", new Integer(0), UserData.SHARED);
		}
		// create transpose graph
		for (Object i : design.getComponents())
			((Component)i).copy(gt);
		for (Object i : design.getComponents()) {
			for (Object j : ((Component)i).getSuccessors())
				gt.addSignal(new Signal((Component)((Component)j).getEqualVertex(gt), (Component)((Component)i).getEqualVertex(gt)));
		}
		// DFS G
		visit(design.getInit());
		for (Object i : design.getVertices())
			if (((Vertex)i).getUserDatum("visit").equals(0))
				visit(i);
		// list in reverse order
		for (Object i : sccMap.values()) {
			level++;
			if (((Vertex)i).getUserDatum("level").equals(0))
				visitT(design, i);
		}
		// update scc field 
		for (Object i : design.getComponents()) {
			int nodeLevel = (Integer)((Vertex)i).getUserDatum("level");
			if (sccLevels.contains(nodeLevel))
				((Component)i).setUserDatum("scc", nodeLevel, UserData.SHARED);
		}	
	    t.end();
	    System.out.println("Ok! " + t.duration() + " ms");
	}
	// visit node and update visit/finish
	private void visit(Object v) {
		((Vertex)v).setUserDatum("visit", dfs++, UserData.SHARED);
		for (Object vr : ((Vertex)v).getSuccessors())
			if (((Vertex)vr).getUserDatum("visit").equals(new Integer(0)))
				visit((Vertex)vr);
		sccMap.put(-dfs, ((Vertex)v).getEqualVertex(gt));
		((Vertex)v).setUserDatum("finish", dfs++, UserData.SHARED);
	}

	// visit node transpose graph
	private void visitT(Graph g, Object v) {
		((Vertex)v).getEqualVertex(g).setUserDatum("level", level, UserData.SHARED);
		((Vertex)v).setUserDatum("level", level, UserData.SHARED);
		for (Object i : ((Vertex)v).getSuccessors()) {
			if (((Vertex)i).getUserDatum("level").equals(0))
				visitT(g, i);
			else
				if (((Vertex)i).getUserDatum("level").equals(level))
					sccLevels.add(level);
		}
	}
}
