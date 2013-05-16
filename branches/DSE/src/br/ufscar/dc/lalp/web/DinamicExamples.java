package br.ufscar.dc.lalp.web;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

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
		
        //FIXME: what if we have more than 6 examples?
		String ex[] = new String[6];
		
		ex[0] = "&ex1=";
		ex[1] = "&ex2=";
		ex[2] = "&ex3=";
		ex[3] = "&ex4=";
		ex[4] = "&ex5=";
		ex[5] = "&ex6=";
		
		int i = 0;
		
	    for (final File fileEntry : folder.listFiles()) {
	        if (fileEntry.isDirectory()) {
	            listFilesForFolder(fileEntry);
	        } else {
	            System.out.println(fileEntry.getName());
	            String temp = fileEntry.getName();
	            ex[i] = ex[i] + temp;
	            i++;
	            //FIXME
		        if (i > 5)
		        	break;
	        }
	    }
	    
	    while (i < 6) {
	    	ex[i] = ex[i] + "null";
	    	i++;
	    }
	    
	    String examples = ex[0] + ex[1] + ex[2] + ex[3] + ex[4] + ex[5];
	    
	    return examples;
	}

}
