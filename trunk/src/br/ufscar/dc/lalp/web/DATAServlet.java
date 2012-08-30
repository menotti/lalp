package br.ufscar.dc.lalp.web;

import java.io.*;

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

import java.sql.Connection;  
import java.sql.DriverManager;  
import java.sql.SQLException;  

import java.sql.*;  
import java.util.Properties;


/**
 * Servlet implementation class DATAServlet
 * 
 * @Author Tulio
 */

@SuppressWarnings("serial")
@WebServlet("/DATAServlet")
public class DATAServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	Configs configs = new Configs();
	
    private String EMAIL_PASS = configs.getEmailPass();
	private String COMP_FILES_PATH = configs.getCompFilesPath();
	
	
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
		String role = "use";
		String enabled = "false";
		
		System.out.println(fname + lname + email + org + why + urldest);
		
        String url = "jdbc:mysql://localhost:3306/lalp";  
        String usuario = "root";  
        String senha = "root";  
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
            stmt.executeUpdate("INSERT INTO userrole (email, role, enabled) VALUES('"+email+"','"+role+"','"+enabled+"')");
 
            stmt.close();  
            con.close();  
            }  
        
        catch(SQLException ex){  }  
        
        
        
        
        String host = "smtp.gmail.com";
        String from = "lalp.ufscar";

        Properties props = System.getProperties();
        props.put("mail.smtp.starttls.enable", "true"); // added this line
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.user", from);
        props.put("mail.smtp.password", EMAIL_PASS);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");

        String[] to = {"lalp.ufscar@gmail.com"}; // added this line

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
        message.setSubject("Aceite o cadastro de " + fname);
        message.setText(fname + " " + lname + " (" + email + ") " + "se cadastrou.\n\n\nOrganizacao: " + org + "\n\n\nMotivos: " + why);
        Transport transport = session.getTransport("smtp");
        transport.connect(host, from, EMAIL_PASS);
        transport.sendMessage(message, message.getAllRecipients());
        transport.close(); } catch (Exception e) { }
        
               
        //cria diretorios para armazenamento dos arquivos de compilacao
        boolean success = (new File(COMP_FILES_PATH + email)).mkdirs();
        if (success) {
            System.out.println("Sucesso");
        }
    }
	

}
