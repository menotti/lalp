package br.ufscar.dc.lalp.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

import java.io.IOException;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
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
	
	private static final String SERVER_PATH = Configs.getServerPath();
	private static final String EMAIL_PASS = Configs.getEMAIL_PASS();
	private static final String MYSQL_PASS = Configs.getMYSQL_PASS();
	
       
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
		
		String dname[] = new String[5];
		String dusr[] = new String[5];
		String dwhy[] = new String[5];
		
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
            con= DriverManager.getConnection(url, usuario, MYSQL_PASS);  
            stmt=con.createStatement();  
            
            //ResultSet nm = stmt.executeQuery("SELECT * FROM userdata;");
            ResultSet rs = stmt.executeQuery("SELECT * FROM userrole,userdata WHERE userrole.email=userdata.email and userrole.enabled='false';");
            
            int contador = 0;
            
            int dpagecounter = dpage * 5;
            
            for (int i = 0; i < dpagecounter; i++)
            {
            	rs.next();
            }
            
            while (rs.next()  && contador < 5) {
            	try {
            		String email = rs.getString("email");;
            		String firstname = rs.getString("fname");
            		String lastname = rs.getString("lname");
            		String why = rs.getString("why");
            		//System.out.println(email);
            		dname[contador] = "dname" + contador + "=" + firstname + " " + lastname + "&";
            		dusr[contador] = "dusr" + contador + "=" + email + "&";
            		dwhy[contador] = "dwhy" + contador + "=" + why + "&";
            		contador++;
            		
            	} catch (SQLException ex){ }
            }

            stmt.close();  
            con.close();  
        } catch(SQLException ex){  }
        
        
        String dretorno = "dpage=" + dpage + "&" + dname[0] + dname[1] + dname[2] + dname[3] + dname[4] + "&" + dusr[0] + dusr[1] + dusr[2] + dusr[3] + dusr[4] + "&" + dwhy[0] + dwhy[1] + dwhy[2] + dwhy[3] + dwhy[4];
        
        
        // usuarios habilitados
        
        String ename[] = new String[5];
        String eusr[] = new String[5];
        String ewhy[] = new String[5];
		
    		

            Connection con1;  
            Statement stmt1;
            
            try {  
                Class.forName("com.mysql.jdbc.Driver").newInstance();  
            }  
            catch(Exception e){  }
            
            try{  
                con1= DriverManager.getConnection(url, usuario, MYSQL_PASS);  
                stmt1=con1.createStatement();  
                
                
                ResultSet rs = stmt1.executeQuery("SELECT * FROM userrole,userdata WHERE userrole.email=userdata.email and userrole.enabled='true';"); 
                
                int contador = 0;
                
                int epagecounter = epage * 5;
                
                for (int i = 0; i < epagecounter; i++)
                {
                	rs.next();
                }
                
                while (rs.next() && contador < 5) {
                	try {
                		String email = rs.getString("email");
                		String firstname = rs.getString("fname");
                		String lastname = rs.getString("lname");
                		String why = rs.getString("why");
                		//System.out.println(email);
                		ename[contador] = "ename" + contador + "=" + firstname + " " + lastname + "&";
                		eusr[contador] = "eusr" + contador + "=" + email + "&";
                		ewhy[contador] = "ewhy" + contador + "=" + why + "&";
                		contador++;
                		
                	} catch (SQLException ex){ }
                }

                stmt1.close();  
                con1.close();  
            } catch(SQLException ex){  }
            
      String eretorno = "epage=" + epage + "&" + ename[0] + ename[1] + ename[2] + ename[3] + ename[4] + "&" + eusr[0] + eusr[1] + eusr[2] + eusr[3] + eusr[4] + "&" + ewhy[0] + ewhy[1] + ewhy[2] + ewhy[3] + ewhy[4];
        
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
	            con= DriverManager.getConnection(url, usuario, MYSQL_PASS);  
	            stmt=con.createStatement();  
	            
	            try {
	            for (int i = 0; i < 4; i++){
	            	if (dargs[i].equals("dusr0")) {
	            		String sql = "UPDATE userrole SET enabled='true' WHERE email='" + dusr0 + "'";
	            		stmt.executeUpdate(sql);
	            		sendEmail(dusr0);
	            	}
	            	
	            	if (dargs[i].equals("dusr1")) {
	            		String sql = "UPDATE userrole SET enabled='true' WHERE email='" + dusr1 + "'";
	            		stmt.executeUpdate(sql);
	            		sendEmail(dusr1);
	            	}
	            	
	            	if (dargs[i].equals("dusr2")) {
	            		String sql = "UPDATE userrole SET enabled='true' WHERE email='" + dusr2 + "'";
	            		stmt.executeUpdate(sql);
	            		sendEmail(dusr2);
	            	}
	            	
	            	if (dargs[i].equals("dusr3")) {
	            		String sql = "UPDATE userrole SET enabled='true' WHERE email='" + dusr3 + "'";
	            		stmt.executeUpdate(sql);
	            		sendEmail(dusr3);
	            	}
	            	
	            	if (dargs[i].equals("dusr4")) {
	            		String sql = "UPDATE userrole SET enabled='true' WHERE email='" + dusr4 + "'";
	            		stmt.executeUpdate(sql);
	            		sendEmail(dusr4);
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
	
	public void sendEmail(String email) {
		
        String host = "smtp.gmail.com";
        String from = "lalp.ufscar";

        Properties props = System.getProperties();
        props.put("mail.smtp.starttls.enable", "true"); // added this line
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.user", from);
        props.put("mail.smtp.password", EMAIL_PASS);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");

        String[] to = {email}; // added this line

        try { Session session = Session.getDefaultInstance(props, null);
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));

        InternetAddress[] toAddress = new InternetAddress[to.length];

        // To get the array of addresses
        for( int i=0; i < to.length; i++ ) { // changed from a while loop
            toAddress[i] = new InternetAddress(to[i]);
        }
        System.out.println(Message.RecipientType.TO);

        for( int i=0; i < toAddress.length; i++) { // changed from a while loop
            message.addRecipient(Message.RecipientType.TO, toAddress[i]);
        }
        message.setSubject("Use LALP Web Compiler now!");
        message.setText("Your are able to use LALP Web Compiler.");
        Transport transport = session.getTransport("smtp");
        transport.connect(host, from, EMAIL_PASS);
        transport.sendMessage(message, message.getAllRecipients());
        transport.close(); } catch (Exception e) { }
	}
}
