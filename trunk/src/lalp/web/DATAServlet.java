package lalp.web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.Connection;  
import java.sql.DriverManager;  
import java.sql.SQLException;  

import java.sql.*;  


/**
 * Servlet implementation class DATAServlet
 * 
 * @Author Tulio
 */

@SuppressWarnings("serial")
@WebServlet("/DATAServlet")
public class DATAServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		PrintWriter out = response.getWriter();
		
		response.setContentType("text/plain");

		String fname = request.getParameter("first");
		String lname = request.getParameter("last");
		String email = request.getParameter("email");
		String org = request.getParameter("org");
		String why = request.getParameter("why");
		String urldest = request.getParameter("url");
		String role = "false";
		
		System.out.println(fname + lname + email + org + why + urldest);
		
        String url = "jdbc:mysql://localhost:3306/lalp";  
        String usuario = "root";  
        String senha = "123789";  
        Connection con;  
        Statement stmt;
        
        try {  
            Class.forName("com.mysql.jdbc.Driver").newInstance();  
        }  
        catch(Exception e){  }
        
        try{  
            con= DriverManager.getConnection(url, usuario, senha);  
            stmt=con.createStatement();  

            stmt.executeUpdate("INSERT INTO userdata (fname, lname, email, org, why) VALUES('"+fname+"', '"+lname+"','"+email+"','"+org+"','"+why+"')");
            stmt.executeUpdate("INSERT INTO userrole (email, role) VALUES('"+email+"','"+role+"')");
 
            stmt.close();  
            con.close();  
            }  
        
        catch(SQLException ex){  }  
    }
		


}
