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

import java.util.Vector;

import alp.algorithms.*;
import alp.core.Design;


/**
 * Run all examples from a String Vector
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version October, 2008
 * @deprecated
 */
public class RunAll {

	Vector<String> tests = new Vector<String>();
	
	public RunAll() {
		
//		tests.add("alp.designs.tests.test_scc_hw");
//		tests.add("alp.designs.tests.nested_scc_hw");
//		tests.add("alp.designs.tests.simple_scc_hw");

//		tests.add("alp.designs.tests.asap_alap_test_hw");
//		tests.add("alp.designs.tests.test_balancing_hw");
//		tests.add("alp.designs.tests.test_module_for_hw");
		
		tests.add("alp.designs.basic.max_hw");
//		tests.add("alp.designs.basic.max_hw_auto");
		tests.add("alp.designs.basic.dotprod_hw");
//		tests.add("alp.designs.basic.dotprod_hw_auto");
		
//		tests.add("alp.designs.adpcm.adpcm_coder_hw_auto");
//		tests.add("alp.designs.adpcm.adpcm_coder_hw");
//		tests.add("alp.designs.adpcm.adpcm_decoder_hw_2c");
//		tests.add("alp.designs.adpcm.adpcm_decoder_hw");
		
//		tests.add("alp.designs.fdct.fdct_hw");
//		tests.add("alp.designs.fdct.fdct_hw_auto");
		
		for (String className : tests) {
			try {
				System.out.println();
				System.out.println("Running design " + className);
				Object test = Class.forName(className).newInstance();
				Design design = (Design)test;
				
//				design.organizeComponents();
//				design.organizeSignals();			
//
//				StrongConnectedComponents scc = new StrongConnectedComponents();
//				scc.detectStrongConnectedComponents(design);
//
//				Dijkstra path = new Dijkstra();
//				path.detectBigestCycle(design);
//
//				Dominators dom = new Dominators();
//				dom.detectBackwardEdges(design);
//
//				DepthFirstSearch dfs = new DepthFirstSearch();
//				dfs.DFS(design);
//
//				Scheduling m = new Scheduling();
//				
//				AsapAlap sched = new AsapAlap();
//				sched.ASAP(design);
//				sched.ALAP(design);

//				Debug debug = new Debug();
//				debug.designDump(design);

//				Jung jung = new Jung();
//				jung.jungVizualization(design);
				
				Graphviz dot = new Graphviz();
//				dot.setSccLevels(true);
//				dot.setSchedulingTimes(true);
//				dot.setRank(true);
				dot.generateSoftwareVisualization(design);
				dot.generateHardwareVisualization(design);
//				dot.generateSCCSubgraphs(design);
				
				VHDL vhd = new VHDL();
				vhd.generateVHDL(design);
				vhd.generateVHDLInitialization(design);
				vhd.generateVHDLTestbench(design);

			} catch (InstantiationException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static void main(String[] args) {
		new RunAll();
	}
}
