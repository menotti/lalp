package br.ufscar.dc.lalp.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class admServlet
 */
@WebServlet("/admServlet")
public class admServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final String url = "jdbc:mysql://localhost:3306/lalp";  
	private static final String usuario = "root";  
	private static final String senha = "****"; 
	
	private static final String SERVER_PATH= "http://lalp.dc.ufscar.br:8080/lalp/";
       
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setContentType("text/plain");
		
		//response.sendRedirect("http://www.google.com.br");
		
		String dstringpage = request.getParameter("dpage");
		if (dstringpage ==null) {
			dstringpage = "0";
		}
		
		String estringpage = request.getParameter("epage");
		if (estringpage ==null) {
			estringpage = "0";
		}
		
		int dpage = Integer.parseInt(dstringpage);
		int epage = Integer.parseInt(estringpage);
		
		String dusr[] = new String[5];
		
	/*	usr[0] = "usr1=";
		usr[1] = "usr2=";
		usr[2] = "usr3=";
		usr[3] = "usr4=";
		usr[4] = "usr5=";*/
		

        Connection con;  
        Statement stmt;
        
        try {  
            Class.forName("com.mysql.jdbc.Driver").newInstance();  
        }  
        catch(Exception e){  }
        
        try{  
            con= DriverManager.getConnection(url, usuario, senha);  
            stmt=con.createStatement();  
            
            ResultSet rs = stmt.executeQuery("SELECT email FROM userrole WHERE enabled='false' AND role='use'"); 
            
            int contador = 0;
            
            int dpagecounter = dpage * 5;
            
            for (int i = 0; i < dpagecounter; i++)
            {
            	rs.next();
            }
            
            while (rs.next() && contador < 5) {
            	try {
            		String email = rs.getString("email");
            		System.out.println(email);
            		dusr[contador] = "dusr" + contador + "=" + email + "&";
            		contador++;
            		
            	} catch (SQLException ex){ }
            }

            stmt.close();  
            con.close();  
        } catch(SQLException ex){  }
        
        
        String dretorno = "dpage=" + dpage + "&" + dusr[0] + dusr[1] + dusr[2] + dusr[3] + dusr[4];
        
        
        // usuarios habilitados
        String eusr[] = new String[5];
		
    	/*	usr[0] = "usr1=";
    		usr[1] = "usr2=";
    		usr[2] = "usr3=";
    		usr[3] = "usr4=";
    		usr[4] = "usr5=";*/
    		

            Connection con1;  
            Statement stmt1;
            
            try {  
                Class.forName("com.mysql.jdbc.Driver").newInstance();  
            }  
            catch(Exception e){  }
            
            try{  
                con1= DriverManager.getConnection(url, usuario, senha);  
                stmt1=con1.createStatement();  
                
                ResultSet rs = stmt1.executeQuery("SELECT email FROM userrole WHERE enabled='true' AND role='use'"); 
                
                int contador = 0;
                
                int epagecounter = epage * 5;
                
                for (int i = 0; i < epagecounter; i++)
                {
                	rs.next();
                }
                
                while (rs.next() && contador < 5) {
                	try {
                		String email = rs.getString("email");
                		System.out.println(email);
                		eusr[contador] = "eusr" + contador + "=" + email + "&";
                		contador++;
                		
                	} catch (SQLException ex){ }
                }

                stmt1.close();  
                con1.close();  
            } catch(SQLException ex){  }
            
      String eretorno = "epage=" + epage + "&" + eusr[0] + eusr[1] + eusr[2] + eusr[3] + eusr[4];
        
      String retorno = dretorno + "&" + eretorno;
            
      response.sendRedirect(SERVER_PATH + "adm.jsp?" + retorno);
		
		
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		PrintWriter out = response.getWriter();
		
		response.setContentType("text/plain");
		
		String dusr0 = request.getParameter("dusr0");
		String dusr1 = request.getParameter("dusr1");
		String dusr2 = request.getParameter("dusr2");
		String dusr3 = request.getParameter("dusr3");
		String dusr4 = request.getParameter("dusr4");
		String dargs[] = new String[5];
		dargs = request.getParameterValues("dargs[]");
		
		String eusr0 = request.getParameter("eusr0");
		String eusr1 = request.getParameter("eusr1");
		String eusr2 = request.getParameter("eusr2");
		String eusr3 = request.getParameter("eusr3");
		String eusr4 = request.getParameter("eusr4");
		String eargs[] = new String[5];
		eargs = request.getParameterValues("eargs[]");
		
		 	Connection con;  
	        Statement stmt;
	        
	        try {  
	            Class.forName("com.mysql.jdbc.Driver").newInstance();  
	        }  
	        catch(Exception e){  }
	        
	        try{  
	            con= DriverManager.getConnection(url, usuario, senha);  
	            stmt=con.createStatement();  
	            
	            try {
	            for (int i = 0; i < 4; i++){
	            	if (dargs[i].equals("dusr0")) {
	            		String sql = "UPDATE userrole SET enabled='true' WHERE email='" + dusr0 + "'";
	            		stmt.executeUpdate(sql);
	            	}
	            	
	            	if (dargs[i].equals("dusr1")) {
	            		String sql = "UPDATE userrole SET enabled='true' WHERE email='" + dusr1 + "'";
	            		stmt.executeUpdate(sql);
	            	}
	            	
	            	if (dargs[i].equals("dusr2")) {
	            		String sql = "UPDATE userrole SET enabled='true' WHERE email='" + dusr2 + "'";
	            		stmt.executeUpdate(sql);
	            	}
	            	
	            	if (dargs[i].equals("dusr3")) {
	            		String sql = "UPDATE userrole SET enabled='true' WHERE email='" + dusr3 + "'";
	            		stmt.executeUpdate(sql);
	            	}
	            	
	            	if (dargs[i].equals("dusr4")) {
	            		String sql = "UPDATE userrole SET enabled='true' WHERE email='" + dusr4 + "'";
	            		stmt.executeUpdate(sql);
	            	}
	            }
	            } catch (Exception e){  }
	            
	            try {
	            for (int j = 0; j < 4; j++){
	            	if (eargs[j].equals("eusr0")) {
	            		String sql = "UPDATE userrole SET enabled='false' WHERE email='" + eusr0 + "'";
	            		stmt.executeUpdate(sql);
	            	}
	            	
	            	if (eargs[j].equals("eusr1")) {
	            		String sql = "UPDATE userrole SET enabled='false' WHERE email='" + eusr1 + "'";
	            		stmt.executeUpdate(sql);
	            	}
	            	
	            	if (eargs[j].equals("eusr2")) {
	            		String sql = "UPDATE userrole SET enabled='false' WHERE email='" + eusr2 + "'";
	            		stmt.executeUpdate(sql);
	            	}
	            	
	            	if (eargs[j].equals("eusr3")) {
	            		String sql = "UPDATE userrole SET enabled='false' WHERE email='" + eusr3 + "'";
	            		stmt.executeUpdate(sql);
	            	}
	            	
	            	if (eargs[j].equals("eusr4")) {
	            		String sql = "UPDATE userrole SET enabled='false' WHERE email='" + eusr4 + "'";
	            		stmt.executeUpdate(sql);
	            	}
	            }
	            } catch (Exception e){  }
	            	
	            stmt.close();  
	            con.close();
	            
	        } catch(SQLException ex){  }
		
		
		
	}
}
