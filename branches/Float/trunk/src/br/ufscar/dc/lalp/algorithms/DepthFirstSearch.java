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

import br.ufscar.dc.lalp.core.Component;
import br.ufscar.dc.lalp.core.Design;
import br.ufscar.dc.lalp.core.Signal;

/**
 * Used do detect backedges
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>
 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version October, 2008
 */
public class DepthFirstSearch {

	public static final int WHITE = 0;
	public static final int GRAY = 1;
	public static final int BLACK = 2;
	
	public void DFS(Design design) {
		System.out.print("Running Depth First Search...");
		for (Component component : design.getComponents()) {
			component.setDFS(WHITE);
		}
		DFSVisit(design, design.getInit());
		System.out.println("Ok!");
	}
	public void DFSVisit(Design design, Component component) {
		component.setDFS(GRAY);
		for (Component successor : component.getSuccessors()) {
			if (successor.getDFS() == WHITE) {
				// is a tree edge
				DFSVisit(design, successor);
			}
			else
				if (successor.getDFS() == GRAY) {
					// is a back edge
					for (Object o : component.getOutEdges()) {
						Signal s = (Signal)o;
						if (s.getDest() == successor) {
							s.setBackEdge(true);
						}
					}
				}
				else {
					if (successor.getDFS() == BLACK) {
						// is a cross or forward edge
					}
				}
		}
		component.setDFS(BLACK);
		return;
	}
}
