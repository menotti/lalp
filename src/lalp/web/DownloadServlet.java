package lalp.web;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DownloadServlet
 */
@WebServlet("/DownloadServlet")
public class DownloadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 * 
	 */
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		out.println("Download Servlet");
	}

	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String fileName = request.getParameter("fileName");
		String sourceCode = request.getParameter("sourceCode");
		response.addHeader("Cache-Control:", "Cache-Control: ");
		response.addHeader("Content-Disposition:",
				"Content-Disposition: attachment; filename=" + fileName.concat(".alp"));
		response.setContentType("Content-type: text/plain");
		PrintWriter out = response.getWriter();

		try {
			File file = File.createTempFile(fileName, ".alp");
			FileWriter fstream = new FileWriter(file);
			BufferedWriter outFile = new BufferedWriter(fstream);
			outFile.write(sourceCode);
			outFile.close();
			out.println(sourceCode);
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			out.close();
		}
	}
}
