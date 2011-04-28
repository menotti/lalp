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

package alp.designs;

import alp.algorithms.Dijkstra;
import alp.algorithms.Dominators;
import alp.algorithms.Graphviz;
import alp.algorithms.StrongConnectedComponents;
import alp.algorithms.VHDL;
import alp.core.Design;

/**
 * Run a single example
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version October, 2008
 * @deprecated
 */
public class RunOne {
	
	public RunOne() {
		
		Design design = new alp.designs.fdct.fdct_hw();
//		Design design = new alp.designs.basic.fibonacci_hw();
//		Design design = new alp.designs.adpcm.adpcm_coder_hw();
		
		System.out.println("Design: " + design.getName());
				
//		design.organizeComponents();
//		design.organizeSignals();			
//
		StrongConnectedComponents scc = new StrongConnectedComponents();
		scc.detectStrongConnectedComponents(design);
//
		Dijkstra path = new Dijkstra();
		path.detectBigestCycle(design);
//
		Dominators dom = new Dominators();
		dom.detectBackwardEdges(design);
		dom.generateReport(design);
//
//		AsapAlap sched = new AsapAlap();
//		sched.ALAP(design);
//
//		DepthFirstSearch dfs = new DepthFirstSearch();
//		dfs.DFS(design);
		
		Graphviz dot = new Graphviz();
//		dot.setSccLevels(true);
//		dot.setSchedulingTimes(true);
//		dot.setRank(true);
//		dot.setDominator(true);
		dot.generateSoftwareVisualization(design);
		dot.generateHardwareVisualization(design);
		dot.generateSCCSubgraphs(design);

//		Scheduling m = new Scheduling();
				
//		Debug debug = new Debug();
//		debug.designDump(design);

//		Jung jung = new Jung();
//		jung.jungVizualization(design);
//				
		VHDL vhd = new VHDL();
		vhd.generateVHDL(design);
		vhd.generateVHDLInitialization(design);
		vhd.generateVHDLTestbench(design);

		System.out.println("Done!");
	}
	
	public static void main(String[] args) {
		new RunOne();
	}
}
