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
import java.util.Calendar;
import java.util.HashSet;
import java.util.TreeMap;
import java.util.Vector;
import java.util.Map.Entry;

import lalp.components.delay_op;
import lalp.core.Component;
import lalp.core.Design;
import lalp.core.IComponent;
import lalp.core.Port;
import lalp.core.PortType;
import lalp.core.Signal;
import lalp.core.VHDLType;



/**
 * Generates graph representations using <a href="http://www.graphviz.org"/>Graphviz</a> 
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version October, 2008
 */
public class Graphviz {
	
//	private final static String DEFAULT_DIRECTORY = "out";
	private final static String DEFAULT_DIRECTORY = "/Users/ricardomenotti/Documents/workspace/designs/lalps";

	private boolean legend = false;
	private boolean schedulingTimes = false;
	private boolean sccLevels = false;
	private boolean rank = false;
	private boolean lines = false;
	private TreeMap<Integer,Vector<Component>> ranks = new TreeMap<Integer,Vector<Component>>();
	private boolean dominator = false;
	private String fileName = null;

	/**
	 * Show legend
	 */
	public void setLegend(boolean b) {
		this.legend = b;
	}
	
	/**
	 * Show scheduling times calculated by {@link Scheduling}
	 */
	public void setSchedulingTimes(boolean b) {
		this.schedulingTimes = b;
	}
	
	/**
	 * Show SCC levels calculated by {@link StrongConnectedComponents}
	 */
	public void setSccLevels(boolean b) {
		this.sccLevels = b;
	}
	
	/**
	 * Show source code lines
	 */
	public void setLines(boolean b) {
		this.lines = b;
	}
	
	/**
	 * Rank nodes by {@link Component#getASAP()} value
	 */
	public void setRank(boolean b) {
		this.rank = b;
	}

	/**
	 * Show imediate dominator calculated by {@link Dominators}
	 */
	public void setDominator(boolean b) {
		this.dominator = b;
	}
	/**
	 * Generate the Graphviz edges
	 * @param dos The <code>DataOutputStream</code> for the Graphviz file
	 * @throws IOException
	 */
	private void generateHardwareEdges(Design design, DataOutputStream dos) throws IOException {
		dos.writeBytes("\n\t// Signals (Edges)\n");
		for (Signal s : design.getSignals()) {
			Port pFrom = s.getSourcePort();
			Port pTo = s.getDestPort();
//			DEBUG print port names 
//			System.out.println("Port: " + pTo.getName());
			Component cFrom = pFrom.getComponent();
			Component cTo  = pTo.getComponent();
			// "component"
			dos.writeBytes("\t\"" + cFrom.getName() + "\"");
			// :port
			if (cFrom.isIComponent())
				dos.writeBytes(":" + pFrom.getName());
			// -> "component"
			dos.writeBytes(" -> \"" + cTo.getName() + "\"");
			// :port
			if (cTo.isIComponent())
				dos.writeBytes(":" + pTo.getName());
			// [label="signal[size]" color=color];
			dos.writeBytes(" [label=\"" + s.getNameSized());
			if (s.getDataType() == VHDLType.STD_LOGIC)
				dos.writeBytes("\" color=olivedrab");
			else
				dos.writeBytes("\" color=red fontcolor=red");
			if (s.isBackEdge())
				dos.writeBytes(" style=dashed");
			dos.writeBytes("];\n");			
		}
		if (rank)
			dumpSchedulingLevels(dos);
		dos.writeBytes("}");
	}
	
	private void generateHardwareVertices(Design design, DataOutputStream dos) throws IOException {
		boolean b;
		dos.writeBytes("digraph " + design.getName() + " {\n");
		if (rank) 
			dumpSchedulingRule(dos, design.getMaxSchedulingTime());
		dos.writeBytes("\t// Components (Nodes)\n");
		for (Component c : design.getComponents()) {
			if (c.isIComponent()) {
				IComponent ic = (IComponent)c;
				// Components: "component" [shape=record, fontcolor=blue label="{{
				dos.writeBytes("\t\"" + ic.getName() + "\" [shape=record, fontcolor=blue, ");
				if (c.getSync()) {
					dos.writeBytes("style=\"filled\", fillcolor=\"lightgray\", ");
					if (rank && ! (c instanceof delay_op))
						ranks.get(ic.getASAP()).add(c);
				}
				dos.writeBytes("label=\"{{");
				b = false; 
//				for (Port p : ic.getPorts()) {
				for (Port p : ic.getPortsByName().values()) {
					if (p.getType() == PortType.INPUT) {
						if (b) 
							dos.writeBytes("|");
						else
							b = true;
						// Input ports: |<port>port[size]
						dos.writeBytes("<" + p.getName() + ">" + p.getNameSizedTimed());
					}
				}
				// Component: |class:name|
				if (schedulingTimes)
					dos.writeBytes("}|" + ic.getNodeName()+"\\nASAP="+ic.getASAP()+"\\nALAP="+ic.getALAP() + "|{");
				else
					dos.writeBytes("}|" + ic.getNodeName()+ "|{");
				b = false;
//				for (Port p : ic.getPorts()) {
				for (Port p : ic.getPortsByName().values()) {
					if (p.getType() != PortType.INPUT) {
						if (b) 
							dos.writeBytes("|");
						else
							b = true;
						// Output ports: |<port>port[size]
						dos.writeBytes("<" + p.getName() + ">" + p.getNameSizedTimed());
					}
				}
				dos.writeBytes("}}\"];\n");
			}
			// constants
			else {
				if (c.isIOComponent()) {
					dos.writeBytes("\t\"" + c.getName() + "\" [shape=msquare fontcolor=blue label=\"" + c.getName() + "\"];\n");
				}
				else {
					dos.writeBytes("\t\"" + c.getName() + "\" [fontcolor=red label=\"" + c.getNodeName() + "\"];\n");
				}
			}
		}
	}
    
	/**
	 * Generate the Graphviz file
	 * @param design The design to be represented
	 */
	public void generateHardwareVisualization(Design design) {
		System.out.print("\nGenerating Graphviz Hardware Representation...");
		fileName = design.getName() + "_hw.dot";
		try {
			FileOutputStream outputFile = new FileOutputStream(DEFAULT_DIRECTORY + System.getProperty("file.separator") + fileName);
			DataOutputStream dataOut = new DataOutputStream(outputFile);
			generateHardwareVertices(design, dataOut);
			//generateGraphvizSimpleVertices(design, dataOut, horizontal);
			generateHardwareEdges(design, dataOut);
			dataOut.close();
		}
		catch(IOException e) {
			System.out.println("Problem creating file!");
			e.printStackTrace();
		}		
		System.out.println("Ok!");
	}
    
	/**
	 * Generate the Graphviz edges
	 * @param dos The <code>DataOutputStream</code> for the Graphviz file
	 * @throws IOException
	 */
	private void generateSoftwareEdges(Design design, DataOutputStream dos) throws IOException {
		dos.writeBytes("\n\t// Signals (Edges)\n");
		for (Signal s : design.getSignals()) {
			Component cFrom = (Component)s.getSource();
			Component cTo  = (Component)s.getDest();
			dos.writeBytes("\t\"" + cFrom.getName() + "\"");
			dos.writeBytes(" -> \"" + cTo.getName() + "\"");
			if (s.isBackEdge())
				dos.writeBytes(" [style=dashed];");
			if (cTo instanceof delay_op)
				dos.writeBytes(":input");
			dos.writeBytes("\n");			
		}
		if (rank) 
			dumpSchedulingLevels(dos);
		dos.writeBytes("}");
	}
	
	
	private void generateSoftwareVertices(Design design, DataOutputStream dos, Integer subgraph) throws IOException {
		String color;
		dos.writeBytes("digraph " + design.getName() + " {\n");
		if (subgraph == null && legend) {
			dos.writeBytes("subgraph cluster {\n");
			dos.writeBytes("	label = \"Generated on "+Calendar.getInstance().getTime() +"\";\n");
			dos.writeBytes("	node [rank=max,shape=box,style=filled];\n");
			dos.writeBytes("	\"legend1\" [label=\"Regular Nodes\", color=dodgerblue2];\n");
			dos.writeBytes("	\"legend2\" [label=\"SCC\", color=blue];\n");
			dos.writeBytes("	\"legend3\" [label=\"Bigest Cycle\", color=green];\n");
			dos.writeBytes("	\"legend4\" [label=\"Input/Output/Const\", color=bisque4];\n");
			dos.writeBytes("}\n");
		}
		if (rank) 
			dumpSchedulingRule(dos, design.getMaxSchedulingTime());
		dos.writeBytes("\t// Components (Nodes)\n");
		dos.writeBytes("\tnode [shape=ellipse, style=filled, color=dodgerblue2];\n");
		for (Component c : design.getComponents()) {
			color = "dodgerblue2";
			if (c.isIComponent()) {
				IComponent ic = (IComponent)c;
				dos.writeBytes("\t\"" + ic.getName() + "\" [");
				dos.writeBytes("label=\""+ic.getDotName());
				if (! (ic instanceof delay_op)) {
					// emph scc nodes
					if ((ic.getUserDatum("scc") != null) && (! ic.getUserDatum("scc").equals(0))) {
						// print scc levels
						color="blue";
						if (sccLevels)
							dos.writeBytes("\\nSCC="+ic.getUserDatum("scc"));
					}
					if (schedulingTimes)
						dos.writeBytes("\\nASAP="+ic.getASAP()+"\\nALAP="+ic.getALAP());
					if (dominator)
						dos.writeBytes("\\n"+ic.level+" iDom="+ic.idom.getName());
					if (lines) {
						int line = ic.getLine();
						if (line != 0)
							dos.writeBytes("\\nline="+line);
					}
				}
				dos.writeBytes("\" ");
				if (c.getSync()) {
					dos.writeBytes("shape="+ic.getDotShape()+" ");
					if (rank && ! (c instanceof delay_op))
						ranks.get(ic.getASAP()).add(c);
				}
				if ((c.getUserDatum("cycle") != null) && (c.getUserDatum("cycle").equals(1))) {
					color="green";
				}
				dos.writeBytes(" color="+color+" ");					
				dos.writeBytes("];\n");
			}
			// constants
			else {
				dos.writeBytes("\t\"" + c.getName() + "\" [color=bisque4 shape=invtriangle label=\"" + c.getDotName() + "\"];\n");
			}
		}
	}

	public void generateSoftwareVisualization(Design design) {
		generateSoftwareVisualization(design, DEFAULT_DIRECTORY);
	}
	
	public void generateSoftwareVisualization(Design design, String path) {
		System.out.print("\nGenerating Graphviz Software Representation...");
		generateSoftwareVisualization(design, path, null);
		System.out.println("Ok!");
	}
	
	public void generateSoftwareVisualization(Design design, String path, Integer subgraph) {
		if (subgraph == null)
			fileName = design.getName() + "_sw.dot";
		else
			fileName = design.getName() + "_sw_" + subgraph + ".dot";
		try {
			FileOutputStream outputFile = new FileOutputStream(path + System.getProperty("file.separator") + fileName);
			DataOutputStream dataOut = new DataOutputStream(outputFile);
			generateSoftwareVertices(design, dataOut, subgraph);
			generateSoftwareEdges(design, dataOut);
			dataOut.close();
		}
		catch(IOException e) {
			System.out.println("Problem creating file!");
			e.printStackTrace();
		}		
	}

	public void generateSCCSubgraphs(Design design) {
		generateSCCSubgraphs(design, DEFAULT_DIRECTORY);
	}
	
	public void generateSCCSubgraphs(Design design, String path) {
		HashSet<Integer> sccLevels = new HashSet<Integer>();
		System.out.print("Generating SCC Subgraphs Representation...");
		for (Component i : design.getComponents()) {
			if ((i.getUserDatum("scc") != null) && (! i.getUserDatum("scc").equals(0))) {
				int n = (Integer)i.getUserDatum("scc");
				sccLevels.add(n);
			}
		}
		setRank(false);
		for (int n: sccLevels) {
			Design gt = new Design(design.getName());
			for (Component i : design.getComponents())
				if (i.getUserDatum("scc").equals(n))
					((Component)i).copy(gt);
			for (Component i : design.getComponents()) {
				if (i.getUserDatum("scc").equals(n))
					for (Component j : ((Component)i).getSuccessors())
						if (j.getUserDatum("scc").equals(n))
							gt.addSignal(new Signal((Component)((Component)i).getEqualVertex(gt), (Component)((Component)j).getEqualVertex(gt)));
			}		
			generateSoftwareVisualization(gt, path, n);
		}
		System.out.println("Ok!");
	}
	
	public String getFileName() {
		return this.fileName;
	}
	
	public void dumpSchedulingRule(DataOutputStream dos, int max) throws IOException {
		if (rank) {
			dos.writeBytes("\t{ //Scheduling rule\n\t\tnode [shape=plaintext];\n");
			for (int i=0; i<=max; i++) {
				dos.writeBytes("\t\t\""+i+"\"");
				if (i == max)
					dos.writeBytes(";");
				else
					dos.writeBytes(" -> ");						
				dos.writeBytes("\n");
				ranks.put(i, new Vector<Component>());
			}
			dos.writeBytes("\t}\n\n");
		}
	}
	
	public void dumpSchedulingLevels(DataOutputStream dos) throws IOException {
		dos.writeBytes("\n\t//Scheduling levels\n");
		for (Entry<Integer,Vector<Component>> i : ranks.entrySet()) {
			dos.writeBytes("\t{rank=same;\""+i.getKey()+"\";");
			for (Component comps : i.getValue()) {
				dos.writeBytes("\""+comps.getName()+"\";");
			}
			dos.writeBytes("}\n");
		}
	}
}