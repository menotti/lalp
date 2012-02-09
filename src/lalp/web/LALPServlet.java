/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lalp.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.StringTokenizer;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;

/*import lalp.algorithms.Dijkstra;
 import lalp.algorithms.StrongConnectedComponents;
 import lalp.core.Design;
 import lalp.core.Parameters;
 import lalp.parser.GraphParser;
 import lalp.parser.LangParser;
 import lalp.parser.lang.SimpleNode;*/
import lalp.core.*;
import lalp.modGui.LalpIDE;
import lalp.parser.*;
import lalp.parser.lang.*;
import lalp.algorithms.*;

/**
 * 
 * @author Gabriel, Túlio
 */

@SuppressWarnings("serial")
@WebServlet("/LALPServlet")
public class LALPServlet extends HttpServlet {
	
	/* $ which dot
	 * public static final String DOT_COMMAND = "/usr/bin/dot";
	 * public static final String DOT_COMMAND = "C:\\Graphviz\\dot.exe";
	 */
	public static final String DOT_COMMAND = "/usr/local/bin/dot";

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();

		response.setContentType("text/xml");
		// response.setContentType("text/plain");

		String fileName = request.getParameter("fileName");
		String graphType = request.getParameter("graphType"); // SW | HW

		if (graphType.equals("sw")) {
			fileName = fileName.replace(".alp", "_sw.dot");
		} else if (graphType.equals("hw")) {
			fileName = fileName.replace(".alp", "_hw.dot");
		}

		// Choose Type
		// String type = ".gif";
		// String type = ".dot";
		// String type = ".fig"; // open with xfig
		// String type = ".pdf";
		// String type = ".ps";
		String type = ".svg"; // open with inkscape
		// String type = ".png";
		// String type = ".plain";

		// read graph files from server and create visualization files
		// (default svg)
		String realPath = this.getServletConfig().getServletContext().getRealPath("/");
		File dotFile = new File(realPath + fileName);
		File imgFile = new File(realPath + dotFile.getName().replace(".dot", type));
	
		try {
			// render visualization
			Runtime rt = Runtime.getRuntime();
			String[] dotArgs = { DOT_COMMAND, "-T" + type.replace(".", ""),
					dotFile.getAbsolutePath(), "-o", imgFile.getAbsolutePath() };
			Process p = rt.exec(dotArgs);
			p.waitFor();
			String result = readFile(imgFile.getAbsolutePath()); //read SVG file content
			out.print(result);
		} catch (Exception e) {
			e.printStackTrace(out);
			throw new RuntimeException(e);
		} finally {
			out.flush();
			out.close();
			response.getWriter().flush();
			response.getWriter().close();
		}
	}

	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		PrintWriter out = response.getWriter();

		response.setContentType("text/plain");

		String[] args = request.getParameterValues("args[]");
		String fileName = request.getParameter("fileName");
		String sourceCode = request.getParameter("sourceCode");	

		try {
			String result = compile(args, fileName, sourceCode);
			out.print(result); // response
		} catch (Exception e) {
			out.print("Choose parameters");
			throw new RuntimeException(e);
		} finally {
			out.flush();
			out.close();
			response.getWriter().flush();
			response.getWriter().close();
		}
	}

	public String compile(String[] args, String fileName, String sourceCode) throws IOException {

		// reset previous args
		// resetParameters();
		// only working configuration at the moment (all args enabled)
		setParameters();

		// from LALP.java, not accepting user args yet
		/*
		 * for (int i = 0; i < args.length; i++) { if (args[i].equals("-as")) {
		 * Parameters.runScc = true; } else if (args[i].equals("-ad")) {
		 * Parameters.runDijkstra = true; } else if (args[i].equals("-ao")) {
		 * Parameters.runDominators = true; } else if (args[i].equals("-aa")) {
		 * Parameters.runAsapAlap = true; } else if (args[i].equals("-at")) { if
		 * (Parameters.runAsapAlap) Parameters.runTopological = true; else
		 * error("Option -at requires option -aa before"); } else if
		 * (args[i].equals("-ab")) { if (Parameters.runAsapAlap)
		 * Parameters.runBalance = true; else
		 * error("Option -ab requires option -aa before"); } else if
		 * (args[i].equals("-do")) { Parameters.debugOutputs = true; } else if
		 * (args[i].equals("-gv")) { Parameters.graphviz = true; } else if
		 * (args[i].equals("-gs")) { if (Parameters.graphviz) {
		 * Parameters.graphvizSubgraphs = true; } else {
		 * error("Option -gs requires option -gv before"); } } else if
		 * (args[i].equals("-vh")) { Parameters.vhdl = true; } else if
		 * (args[i].equals("-vt")) { if (Parameters.vhdl) {
		 * Parameters.vhdlTestbench = true; } else {
		 * error("Option -vt requires option -vh before"); } } else if
		 * (args[i].equals("-vi")) { if (Parameters.vhdl) {
		 * Parameters.vhdlMemory = true; } else {
		 * error("Option -vi requires option -vh before"); } } else if
		 * (args[i].equals("-alpg")) { Parameters.alpg = true; } else if
		 * (args[i].equals("-verbose")) { Parameters.verbose = true; } else if
		 * (args[i].equals("-gui")) { Parameters.gui = true; } else if (i !=
		 * args.length - 1) { error("Unrecognized option: " + args[i]); } }
		 */

		String realPath = null;
		File inputFile = null;
		FileWriter fstream = null;
		BufferedWriter outFile = null;
		try {
			// server path for writing/reading files
			realPath = this.getServletConfig().getServletContext()
					.getRealPath("/");
			log("realPath=" + realPath);
			// creates input file and writes source code
			inputFile = new File(realPath + fileName);
			fstream = new FileWriter(inputFile);
			outFile = new BufferedWriter(fstream);
			outFile.write(sourceCode);
		} catch (Exception e) {
		} finally {
			outFile.flush();
			outFile.close();
		}

		String result = new String();
		FileInputStream inStream = null;
		InputStream is = null;
		Design design = null;
		LangParser lp = null;
		try {
			StringTokenizer st = new StringTokenizer(fileName, ".");
			st.nextToken();
			if (!st.hasMoreTokens()) {
				return result = error("Select file");
			}
			String extension = st.nextToken().toUpperCase();
			if (extension.equals("ALP")) {
				// System.out.print("Reading from file " +
				// args[args.length-1] + "...");
				inStream = new FileInputStream(inputFile);
				is = new ByteArrayInputStream(sourceCode.getBytes());
				lp = new LangParser(is);
				// System.out.println("Ok!");
				if (Parameters.verbose)
					lp.dump();
				lp.createComponents();
				design = lp.getDesign();
				// System.out.print("Connecting hardware components...");
				lp.getRoot().connectComponents();
				if (SimpleNode.allComponents.containsKey("init")) {
					lp.getParser().design.setInit(SimpleNode.allComponents
							.get("init"));
				}
				// System.out.println("Ok!");
			} else if (extension.equals("ALPG")) {
				// System.out.print("Reading from file "
				// + args[args.length - 1] + "...");
				inStream = new FileInputStream(inputFile);
				GraphParser gp = new GraphParser(inStream);
				design = gp.getDesign();
				// System.out.println("Ok!");
			} else {
				return result = error("Only .ALP or .ALPG files are accepted!");
			}
		} catch (Exception e) {
			return result = error(e.toString());
			// e.printStackTrace();
			// System.exit(1);
		} finally {
			inStream.close();
			is.close();
			if (lp != null)
				lp.getRoot().reset();
		}

		// from LALP.java
		try {
			int schedResult = -1;
			if (Parameters.runAsapAlap) {
				Scheduling aa = new Scheduling(design);
				if (Parameters.runTopological)
					aa.detectBackwardEdges(design, lp);
				// schedResult = aa.ASAP(design);
				schedResult = aa.ALAP(design);
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
				// Dominators dom = new Dominators();
				// dom.detectBackwardEdges(design);
				// dom.generateReport(design);
			}

			if (Parameters.graphviz) {
				Graphviz dot = new Graphviz(realPath);
				if (Parameters.runScc)
					dot.setSccLevels(true);
				// if (Parameters.runAsapAlap && schedResult == 0)
				// dot.setSchedulingTimes(true);
				// if (Parameters.runTopological)
				// dot.setLines(true);
				// if (schedResult == 0)
				// dot.setRank(true);
				// dot.setDominator(true);
				// write dot files in server
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
				VHDL vhd = new VHDL(realPath);
				vhd.generateVHDL(design);
				if (Parameters.vhdlMemory)
					vhd.generateVHDLInitialization(design);
				if (Parameters.vhdlTestbench)
					vhd.generateVHDLTestbench(lp);
			}

			if (Parameters.alpg) {
				ALPG alpg = new ALPG();
				alpg.generateALPG(design);
			}

			if (Parameters.gui) {
				LalpIDE gui;
				if (args.length == 1) {
					gui = new LalpIDE();
					gui.setVisible(true);
					while (!LalpIDE.inactive) {
					}
					System.out.println("GUI has terminated");
				}
				if (args.length == 2)
					gui = new LalpIDE(args[1]);
			}
		} catch (Exception e) {
			return result = error(e.toString());
		}
		// if result does not contain SVG file path it will receive VHD file
		// content
		if (result.isEmpty()) {
			File vhdFile = new File(realPath + fileName.replace(".alp", ".vhd"));
			result = readFile(vhdFile.getAbsolutePath());
		}
		return result.trim();
	}

	// working configuration
	private void setParameters() {
		Parameters.runScc = true;
		Parameters.runDijkstra = true;
		Parameters.runDominators = true;
		Parameters.runAsapAlap = true;
		Parameters.runTopological = true;
		Parameters.runBalance = true;
		Parameters.debugOutputs = true;
		Parameters.graphviz = true;
		Parameters.graphvizSubgraphs = true;
		Parameters.vhdl = true;
		Parameters.vhdlTestbench = true;
		Parameters.vhdlMemory = true;
		// requires .ALPG file
		// Parameters.alpg = true;
		Parameters.verbose = true;
		// invokes LalpGUI
		// Parameters.gui = true;
	}

	private void resetParameters() {
		Parameters.runScc = false;
		Parameters.runDijkstra = false;
		Parameters.runDominators = false;
		Parameters.runAsapAlap = false;
		Parameters.runTopological = false;
		Parameters.runBalance = false;
		Parameters.debugOutputs = false;
		Parameters.graphviz = false;
		Parameters.graphvizSubgraphs = false;
		Parameters.vhdl = false;
		Parameters.vhdlTestbench = false;
		Parameters.vhdlMemory = false;
		Parameters.alpg = false;
		Parameters.verbose = false;
		Parameters.gui = false;
	}

	public String info(String s) {
		return ("Info: " + s);
	}

	public String warning(String s) {
		return ("Warning: " + s);
	}

	public String error(String s) {
		return ("Error: " + s);
	}

	public String readFile(String fileName) throws IOException {

		StringWriter stringWriter = new StringWriter();
		IOUtils.copy(new FileInputStream(new File(fileName)), stringWriter);

		return stringWriter.toString();
	}
}
