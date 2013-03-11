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

package br.ufscar.dc.lalp;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.StringTokenizer;

import br.ufscar.dc.lalp.algorithms.ALPG;
import br.ufscar.dc.lalp.algorithms.Dijkstra;
import br.ufscar.dc.lalp.algorithms.Dominators;
import br.ufscar.dc.lalp.algorithms.Graphviz;
import br.ufscar.dc.lalp.algorithms.Scheduling;
import br.ufscar.dc.lalp.algorithms.StrongConnectedComponents;
import br.ufscar.dc.lalp.algorithms.VHDL;
import br.ufscar.dc.lalp.core.Design;
import br.ufscar.dc.lalp.core.Parameters;
import br.ufscar.dc.lalp.parser.GraphParser;
import br.ufscar.dc.lalp.parser.LangParser;
import br.ufscar.dc.lalp.parser.lang.SimpleNode;




/**
 * The LALP compiler
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>
 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version January, 2010
 * @see "Aggressive Loop Pipelining"
 * @see "Language for Aggressive Loop Pipelining"
 * @see "Aggressive Loop Pipelining for Reconfigurable Architectures"
 */
public class LALP {

	private final static String version = "LALP version 0.1 release 107, Copyright (c) 2012 Ricardo Menotti, Joao V. B. Moreira, Gabriel J. Trabasso, Tulio J. Duarte";
	
	public String getVersion() { 
		return version; 
	}
	
	private static final String usage =  
		"Usage: LALP [-options] file\n" +
		"where options include:\n" +
		"  -as       run SCC algorithm\n" + 
		"  -ad       run Dijkstra algorithm\n" + 
		"  -ao       run Dominators algorithm\n" + 
		"  -aa       run AsapAlap scheduling algorithm\n" + 
		"  -at       run Topological algorithm\n" +
		"  -ab       run Balance algorithm\n" +
		"  -do       generate debug output pins\n" +
		"  -gv       generate Graphviz\n" +
		"  -gs       generate Graphviz subgraphs\n" +
		"  -vh       generate VHDL\n" + 
		"  -vi       generate VHDL memory initialization\n" + 
		"  -vt       generate VHDL testbench\n" + 
		"  -alpg     generate ALPG source code\n" + 
		"  -verbose  print verbose output\n" + 
		"  -version  print product version and exit\n";
	
	/**
	 * @param args options and input file
	 */
	public static void main(String[] args) {
		
		FileInputStream inStream;
		Design design = null;
		LangParser lp = null;

		if (args.length == 0) {
			info(usage);
			System.exit(0);
		}

		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-version")) {
				info(version);
				System.exit(0);
			}
			else if (args[i].equals("-as")) {
				Parameters.runScc = true;
			}
			else if (args[i].equals("-ad")) {
				Parameters.runDijkstra = true;
			}
			else if (args[i].equals("-ao")) {
				Parameters.runDominators = true;
			}
			else if (args[i].equals("-aa")) {
				Parameters.runAsapAlap = true;
			}
			else if (args[i].equals("-at")) {
				if (Parameters.runAsapAlap)
					Parameters.runTopological = true;
				else
					error("Option -at requires option -aa before");
			}
			else if (args[i].equals("-ab")) {
				if (Parameters.runAsapAlap)
					Parameters.runBalance = true;
				else
					error("Option -ab requires option -aa before");
			}
			else if (args[i].equals("-do")) {
				Parameters.debugOutputs = true;
			}
			else if (args[i].equals("-gv")) {
				Parameters.graphviz = true;
			} else if (args[i].equals("-gs")) {
				if (Parameters.graphviz) {
					Parameters.graphvizSubgraphs = true;
				}
				else {
					error("Option -gs requires option -gv before");
				}
			} else if (args[i].equals("-vh")) {
				Parameters.vhdl = true;
			} else if (args[i].equals("-vt")) {
				if (Parameters.vhdl) {
					Parameters.vhdlTestbench = true;
				}
				else {
					error("Option -vt requires option -vh before");
				}
			} else if (args[i].equals("-vi")) {
				if (Parameters.vhdl) {
					Parameters.vhdlMemory = true;
				}
				else {
					error("Option -vi requires option -vh before");
				}
			} else if (args[i].equals("-alpg")) {
				Parameters.alpg = true;
			} else if (args[i].equals("-verbose")) {
				Parameters.verbose = true;
			} else if (i != args.length-1) {
				error("Unrecognized option: " + args[i]);
			}
		}
		
		try {
			StringTokenizer st = new StringTokenizer(args[args.length-1], ".");
			st.nextToken();
			if (!st.hasMoreTokens()) {
				error(usage);
			}
			String extension = st.nextToken().toUpperCase();
		
			if (extension.equals("ALP")) {
				System.out.print("Reading from file " + args[args.length-1] + "...");
				inStream = new FileInputStream(args[args.length-1]);
				lp = new LangParser(inStream);
				System.out.println("Ok!");
				if (Parameters.verbose)
					lp.dump();
				lp.createComponents();
				design = lp.getDesign();
				System.out.print("Connecting hardware components...");
				lp.getRoot().connectComponents();
				if (SimpleNode.allComponents.containsKey("init")) {
					lp.getParser().design.setInit(SimpleNode.allComponents.get("init"));
				}
				System.out.println("Ok!");
			}
			else if (extension.equals("ALPG")) {
				System.out.print("Reading from file " + args[args.length-1] + "...");
				inStream = new FileInputStream(args[args.length-1]);
				GraphParser gp = new GraphParser(inStream);
				design = gp.getDesign();
				System.out.println("Ok!");
			}
			else {
				error("Only .ALP or .ALPG files are accepted!");
			}
		} catch (FileNotFoundException e) {
			error("File " + args[args.length-1] + " not found.");
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
		
		int schedResult = -1;
		if (Parameters.runAsapAlap) {
			Scheduling aa = new Scheduling(design);
			if (Parameters.runTopological)
				aa.detectBackwardEdges(design, lp);
//			schedResult  = aa.ASAP(design);
			schedResult  = aa.ALAP(design);
			if (Parameters.runBalance)
				aa.balanceAndSyncrhonize(design);
		}
		
		if (Parameters.runScc) {
			StrongConnectedComponents scc = new StrongConnectedComponents(); 
			scc.detectStrongConnectedComponents(design);
		}
		
		if (Parameters.runDijkstra) {
			Dijkstra dijkstra = new Dijkstra();
			dijkstra.detectBigestCycle(design);
		}
		
		if (Parameters.runDominators) {
//			Dominators dom = new Dominators();
//			dom.detectBackwardEdges(design);
//			dom.generateReport(design);
		}
		
		if (Parameters.graphviz) {
			Graphviz dot = new Graphviz();
			if (Parameters.runScc)
				dot.setSccLevels(true);
//			if (Parameters.runAsapAlap && schedResult == 0)
//				dot.setSchedulingTimes(true);
//			if (Parameters.runTopological)
//				dot.setLines(true);
//			if (schedResult == 0)
//				dot.setRank(true);
//			dot.setDominator(true);
			dot.generateHardwareVisualization(design);
			dot.generateSoftwareVisualization(design);
			if (Parameters.graphvizSubgraphs)
				dot.generateSCCSubgraphs(design);			
		}
		
		if (Parameters.debugOutputs) {
			try {
				design.generateDebugOutputs();
			} catch (Exception e) {
				e.printStackTrace();
				System.exit(1);
			}
		}
		
		if (Parameters.vhdl) { // && schedResult == 0) {
			VHDL vhd = new VHDL();
			vhd.generateVHDL(design);
			if (Parameters.vhdlMemory)
				vhd.generateVHDLInitialization(design);
			if (Parameters.vhdlTestbench)
				if (lp!=null)
					vhd.generateVHDLTestbench(lp);
       
		}
		
		if (Parameters.alpg) {
			ALPG alpg = new ALPG();
			alpg.generateALPG(design);
		}
		System.exit(0);
	}
	
	public static void info(String s) {
		System.out.println("Info: " + s);
	}

	public static void warning(String s) {
		System.out.println("Warning: " + s);
	}

	public static void error(String s) {
		System.err.println("Error: " + s);
		System.exit(1);
	}
}




