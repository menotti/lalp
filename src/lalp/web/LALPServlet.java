/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lalp.web;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lalp.core.Parameters;

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
			String sourceCode = request.getParameter("sourceCode");
			String result = compile(args, sourceCode);
			out.println(result); // response
		} catch (Exception e) {
			out.println("Choose parameters");
			throw new RuntimeException(e);			
		} finally {
			out.close();
		}
	}

	public String compile(String[] args, String sourceCode) {
		String result = new String();

		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-as")) {
				Parameters.runScc = true;
				result = info("SCC Algorithm not working yet!");
			} else if (args[i].equals("-ad")) {
				Parameters.runDijkstra = true;
				result = info("Dijkstra Algorithm not working yet!");
			}
		}
		return result;
	}

	public String info(String s) {
		return ("Info: " + s);
	}
}
