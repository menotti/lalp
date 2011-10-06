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
 * @author Gabriel
 */

@SuppressWarnings("serial")
@WebServlet("/LALPServlet")
public class LALPServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int length = Integer.parseInt(request.getParameter("length"));
		String[] args = new String[length];
		args = request.getParameterValues("args[]");
		String result = compile(args);
		response.setContentType("text/plain");
		PrintWriter out = response.getWriter();
		out.println(result); // response
	}

	public String compile(String[] args) {
		String result = new String();

		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-as")) {
				Parameters.runScc = true;
				result = "SCC Algorithm not working yet!";
			} else if (args[i].equals("-ad")) {
				Parameters.runDijkstra = true;
				result = "Dijkstra Algorithm not working yet!";
			}
		}
		return result;
	}

	public String info(String s) {
		return ("Info: " + s);
	}
}
