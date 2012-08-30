package br.ufscar.dc.lalp.web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.Connection;  
import java.sql.DriverManager;  
import java.sql.SQLException;  
import java.sql.Statement;
import java.io.PrintWriter;  
import java.sql.*; 

import br.ufscar.dc.lalp.LALP;


/**
 * Servlet implementation class DATACheckServlet
 * 
 * @author Tulio
 */
@WebServlet("/DATACheckServlet")
public class DATACheckServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	private static final String url = "jdbc:mysql://localhost:3306/lalp";  
	private static final String usuario = "root";  
	private static final String senha = "root";  
       
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		//PrintWriter out = response.getWriter();
		
		response.setContentType("text/plain");

		String email = request.getParameter("email");
		String index = request.getParameter("index");
		
		
		System.out.println(email);
		
        Connection con;  
        Statement stmt;
        
        try {  
            Class.forName("com.mysql.jdbc.Driver").newInstance();  
        }  
        catch(Exception e){  }
        
        try{  
            con= DriverManager.getConnection(url, usuario, senha);  
            stmt=con.createStatement();  
            
            ResultSet rs = stmt.executeQuery("SELECT enabled FROM userrole WHERE role='use' AND email='" + email +"'"); 
            
            rs.next();
            try {
                String userRole = rs.getString("enabled"); 
                System.out.println(userRole);
                
                if (userRole.equals("false")) {
                	response.sendRedirect("http://www.google.com.br/accounts/o8/ud");
                }
            } catch (SQLException ex){
            	if (index.equals("0")){
            	response.sendRedirect("http://www.google.com.br/accounts/o8/ud");
            	}
            	            	
            }

            stmt.close();  
            con.close();  
            }  
        catch(SQLException ex){  } 
        
        
        PrintWriter out = response.getWriter();
        String versao = getversion();
        try {
			out.print(versao); // response
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			out.flush();
			out.close();
			response.getWriter().flush();
			response.getWriter().close();
		}
        
        
    }
	
	public String getversion() {
		LALP lalp = new LALP();
        return lalp.getVersion();
	}
	
	
	}

