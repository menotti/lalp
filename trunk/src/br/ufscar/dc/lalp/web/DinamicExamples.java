package br.ufscar.dc.lalp.web;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DinamicExamples
 */
@WebServlet("/DinamicExamples")
public class DinamicExamples extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	Configs configs = new Configs();
	
	private String EXAMPLES_PATH = configs.getExamplesPath(); 

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		
		response.setContentType("text/plain");
		
			
		final File folder = new File(EXAMPLES_PATH);
		String examples = listFilesForFolder(folder);
		
		System.out.println(examples);
		
        PrintWriter out = response.getWriter();
		try {
			out.print(examples.trim());
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
	
	public String listFilesForFolder(final File folder) {
		
		List<String> ex = new ArrayList<String>();
		int i = 0;
		
		for (final File fileEntry : folder.listFiles()) 
		{
	        if (fileEntry.isDirectory()) 
	        {
	            listFilesForFolder(fileEntry);
	        }
	        else 
	        {
	            System.out.println(fileEntry.getName());
	            String temp = fileEntry.getName();
	            ex.add("&ex" + i + "=" + temp);
	            i++;
	        }
	    }
		
		String examples = "";
		
		for (int j = 0; j < ex.size(); j++) 
		{
			examples += ex.get(j);
		}
		
		return examples;
		
	}

}
