/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lalp.web;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.StringTokenizer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		out.println("LALP Servlet");
	}

	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		response.setContentType("text/plain");
		PrintWriter out = response.getWriter();
		
		try {
			String[] args = request.getParameterValues("args[]");
			String fileName = request.getParameter("fileName");
			String sourceCode = request.getParameter("sourceCode");
			String result = compile(args, fileName, sourceCode);
			out.println(result); // response
		} catch (Exception e) {
			out.println("Choose parameters");
			throw new RuntimeException(e);
		} finally {
			out.close();
		}
	}

	public String compile(String[] args, String fileName, String sourceCode) {
		String result = new String();
		FileInputStream inStream;
		Design design = null;
		LangParser lp = null;

		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-as")) {
				Parameters.runScc = true;
				// result = info("SCC Algorithm not working yet!");
			} else if (args[i].equals("-ad")) {
				Parameters.runDijkstra = true;
				// result = info("Dijkstra Algorithm not working yet!");
			}

			try {
				StringTokenizer st = new StringTokenizer(fileName, ".");
				st.nextToken();
				if (!st.hasMoreTokens()) {
					return result = error("Select file");
				}
				//server path for writing/reading files
				String realPath = this.getServletConfig().getServletContext().getRealPath("/");
				log ("realPath=" + realPath);
				//creates input file and writes source code
				File inputFile = new File(realPath + fileName);
				FileWriter fstream = new FileWriter(inputFile);
				BufferedWriter outFile = new BufferedWriter(fstream);
				outFile.write(sourceCode);
				outFile.close();
				String extension = st.nextToken().toUpperCase();								
				if (extension.equals("ALP")) {
					// System.out.print("Reading from file " +
					// args[args.length-1] + "...");					
					inStream = new FileInputStream(inputFile);
					lp = new LangParser(inStream);
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
			} catch (Exception e) {
				return result = error(e.toString());
			}
		}
		return result = "ok";
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
}
