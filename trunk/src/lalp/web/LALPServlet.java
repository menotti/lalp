/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lalp.web;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
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

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		out.print("LALP Servlet");
	}

	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		PrintWriter out = response.getWriter();		

		String[] args = request.getParameterValues("args[]");
		String fileName = request.getParameter("fileName");
		String sourceCode = request.getParameter("sourceCode");
		String graphViz = request.getParameter("graphViz");

		if (graphViz.equals("yes")) {			
			response.setContentType("text/xml");
		} else {
			response.setContentType("text/plain");
		}

		try {
			String result = compile(args, fileName, sourceCode);

			if (graphViz.equals("yes")) {
				File imgFile = new File(result);
				result = readFile(imgFile.getAbsolutePath());
				out.print(result);
			} else
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

	public String compile(String[] args, String fileName, String sourceCode)
			throws IOException {

		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-as")) {
				Parameters.runScc = true;
				// result = info("SCC Algorithm not working yet!");
			} else if (args[i].equals("-ad")) {
				Parameters.runDijkstra = true;
				// result = info("Dijkstra Algorithm not working yet!");
			} else if (args[i].equals("-gv")) {
				Parameters.graphviz = true;
			} else if (args[i].equals("-gs")) {
				if (Parameters.graphviz) {
					Parameters.graphvizSubgraphs = true;
				} else {
					error("Option -gs requires option -gv before");
				}
			}
		}

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

		String result = null;
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
		}

		try {
			if (Parameters.runScc) {
				StrongConnectedComponents scc = new StrongConnectedComponents();
				scc.detectStrongConnectedComponents(design);
				return result = design.toString();
			}

			if (Parameters.runDijkstra) {
				Dijkstra dijkstra = new Dijkstra();
				dijkstra.detectBigestCycle(design);
				return result = design.toString();
			}

			if (Parameters.graphviz) {
				Graphviz dot = new Graphviz();
				if (Parameters.runScc)
					dot.setSccLevels(true);
				// if (Parameters.runAsapAlap && schedResult == 0)
				// dot.setSchedulingTimes(true);
				// if (Parameters.runTopological)
				// dot.setLines(true);
				// if (schedResult == 0)
				// dot.setRank(true);
				// dot.setDominator(true);
				// write graph files in server
				dot.generateHardwareVisualization(design);
				dot.generateSoftwareVisualization(design);
				if (Parameters.graphvizSubgraphs)
					dot.generateSCCSubgraphs(design);

				GraphViz gv = new GraphViz();
				// read graph files from server
				File dotSW = new File(realPath
						+ fileName.replace(".alp", "_sw.dot"));
				File dotHW = new File(realPath
						+ fileName.replace(".alp", "_hw.dot"));

				gv.readSource(dotSW.getAbsolutePath());
				result = gv.getDotSource();

				// Choose Type
				// String type = ".gif";
				// String type = ".dot";
				// String type = ".fig"; // open with xfig
				// String type = ".pdf";
				// String type = ".ps";
				String type = ".svg"; // open with inkscape
				// String type = ".png";
				// String type = ".plain";
				Runtime rt = Runtime.getRuntime();

				// create visualization files
				File imgFile = new File(realPath
						+ dotSW.getName().replace(".dot", type)); // Linux
				String[] dotArgs = { "dot", "-T" + type.replace(".", ""),
						dotSW.getAbsolutePath(), "-o",
						imgFile.getAbsolutePath() };
				Process p = rt.exec(dotArgs);
				p.waitFor();

				imgFile = new File(realPath
						+ dotHW.getName().replace(".dot", type)); // Linux
				dotArgs = new String[] { "dot", "-T" + type.replace(".", ""),
						dotHW.getAbsolutePath(), "-o",
						imgFile.getAbsolutePath() };
				p = rt.exec(dotArgs);
				p.waitFor();

				result = imgFile.getAbsolutePath();
			}
		} catch (Exception e) {
			return result = error(e.toString());
		}
		return result;
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
