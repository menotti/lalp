/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lalp.web;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lalp.core.Parameters;

/**
 * 
 * @author Gabriel
 */

// @WebServlet(name = "LALPServlet", urlPatterns = {"/LALPServlet"})
@SuppressWarnings("serial")
public class LALPServlet extends HttpServlet {

	/**
	 * @param args
	 *            the command line arguments
	 */
	/**
	 * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
	 * methods.
	 * 
	 * @param request
	 *            servlet request
	 * @param response
	 *            servlet response
	 * @throws ServletException
	 *             if a servlet-specific error occurs
	 * @throws IOException
	 *             if an I/O error occurs
	 */
	protected void processRequest(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		try {

			/* TODO output your page here */
			out.println("<html>");
			out.println("<head>");
			out.println("<title>Servlet SampleServlet</title>");
			out.println("</head>");
			out.println("<body>");
			out.println("<h1>Servlet SampleServlet at "
					+ request.getContextPath() + "</h1>");
			out.println("</body>");
			out.println("</html>");
		} finally {
			out.close();
		}
	}

	/**
	 * Handles the HTTP <code>GET</code> method.
	 * 
	 * @param request
	 *            servlet request
	 * @param response
	 *            servlet response
	 * @throws ServletException
	 *             if a servlet-specific error occurs
	 * @throws IOException
	 *             if an I/O error occurs
	 */
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

	/**
	 * Handles the HTTP <code>POST</code> method.
	 * 
	 * @param request
	 *            servlet request
	 * @param response
	 *            servlet response
	 * @throws ServletException
	 *             if a servlet-specific error occurs
	 * @throws IOException
	 *             if an I/O error occurs
	 */
	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		int length = Integer.parseInt(request.getParameter("length"));
		String[] args = new String[length];
		for (int i = 0; i < length; i++) {
			args[i] = request.getParameter("args"); // estudar o recebimento de um array Javascript (JSON)
		}
		String result = compile(args);
		response.setContentType("text/plain");
		PrintWriter out = response.getWriter();
		out.println(result); // resposta
	}

	/**
	 * Returns a short description of the servlet.
	 * 
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "Short description";
	}// </editor-fold>

	public String compile(String[] args) {
		final String version = "LALP version 0.1, Copyright (c) 2011 Ricardo Menotti";
		String result = new String();

		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-version")) {
				result = info(version);
			} else if (args[i].equals("-as")) {
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
