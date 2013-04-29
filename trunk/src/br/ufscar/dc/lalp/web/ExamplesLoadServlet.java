package br.ufscar.dc.lalp.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;

/**
 * Servlet implementation class ExamplesLoadServlet
 */
@WebServlet("/ExamplesLoadServlet")
public class ExamplesLoadServlet extends HttpServlet {
	
	
	Configs configs = new Configs();
	
	private String EXAMPLES_PATH = configs.getExamplesPath();
	private static final long serialVersionUID = 1L;
   
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setContentType("text/plain");
		
		String fileName = request.getParameter("file");
		
		System.out.println(fileName);
		
		String result = new String();
		
		result = readFile(EXAMPLES_PATH + fileName);
		
		//return result.trim();
		
        PrintWriter out = response.getWriter();
		try {
			out.print(result.trim());
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
	
	public String readFile(String fileName) throws IOException {

		StringWriter stringWriter = new StringWriter();
		IOUtils.copy(new FileInputStream(new File(fileName)), stringWriter);

		return stringWriter.toString();
	}

}
