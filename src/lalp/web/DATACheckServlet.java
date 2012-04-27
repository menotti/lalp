package lalp.web;

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


/**
 * Servlet implementation class DATACheckServlet
 * 
 * @author Tulio
 */
@WebServlet("/DATACheckServlet")
public class DATACheckServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
       
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
		
		String url = "jdbc:mysql://localhost:3306/lalp";  
        String usuario = "root";  
        String senha = "******";  
        Connection con;  
        Statement stmt;
        
        try {  
            Class.forName("com.mysql.jdbc.Driver").newInstance();  
        }  
        catch(Exception e){  }
        
        try{  
            con= DriverManager.getConnection(url, usuario, senha);  
            stmt=con.createStatement();  
            
            ResultSet rs = stmt.executeQuery("SELECT role FROM userrole WHERE email='" + email +"'"); 
            
            rs.next();
            try {
                String userRole = rs.getString("role"); 
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
    }
	
	}

