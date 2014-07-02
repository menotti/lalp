package br.ufscar.dc.lalp.web;

public class Configs {
	
	//senha do email lalp.ufscar@gmail.com
	private static final String EMAIL_PASS = "";
	
	//senha do mysql no servidor lalp.dc.ufscar.br
	private static final String MYSQL_USER = "";  
	private static final String MYSQL_PASS = EMAIL_PASS;
	
	//caminho dos arquivos de compilacao
	public static final String COMP_FILES_PATH = "/home/profs/menotti/tomcat/webapps/lalp/"; //server
	///public static final String COMP_FILES_PATH = "/Users/menotti/Documents/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/lalp/"; //menotti
	//public static final String COMP_FILES_PATH = "D:/Users/Jefferson/Documents/Eclipse/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/lalpProject/"; //Jefferson
	
	//caminho dos exemplos
	private static final String EXAMPLES_PATH = "/home/profs/menotti/tomcat/webapps/lalp/examples/"; //server
	//private static final String EXAMPLES_PATH = "/Users/menotti/Documents/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/lalp/examples/"; //menotti
	//private static final String EXAMPLES_PATH = "D:/Users/Jefferson/Documents/Eclipse/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/lalpProject/examples/"; //Jefferson
	
	//caminho do zip
	private static final String ZIP_PATH = "/home/profs/menotti/tomcat/webapps/lalp/"; //server
	//private static final String ZIP_PATH = "/Users/menotti/Documents/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/lalp/examples/"; //menotti
	//private static final String ZIP_PATH = "D:/Users/Jefferson/Documents/Eclipse/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/lalpProject/"; //Jefferson
	
	//caminho do server 
	private static final String SERVER_PATH = "http://lalp.dc.ufscar.br:9180/lalp/"; //server DC
	//private static final String SERVER_PATH= "http://projetos.ppgcc.dc.ufscar.br:9180/lalp/"; //alternative server
	//private static final String SERVER_PATH = "http://localhost:8080/lalp/"; //local

	
	//caminho do Graphviz
	public static final String DOT_COMMAND = "/usr/bin/dot"; //server
	//public static final String DOT_COMMAND = "/usr/local/bin/dot"; //menotti
	//public static final String DOT_COMMAND = "C:/Program Files (x86)/Graphviz2.36/bin/dot.exe"; //Jefferson

	private static final String CLIENT_SECRET = "";
	
	private static final String CLIENT_ID = "";

	private static final String CALLBACK_URI = SERVER_PATH + "idCheck.jsp";

	public static String getEmailPass() {
		return EMAIL_PASS;
	}

	public static String getMysqlPass() {
		return MYSQL_PASS;
	}

	public static String getClientSecret() {
		return CLIENT_SECRET;
	}

	public static String getEMAIL_PASS() {
		return EMAIL_PASS;
	}

	public static String getMysqlUser() {
		return MYSQL_USER;
	}
	
	public static String getMYSQL_PASS() {
		return MYSQL_PASS;
	}
		
	public static String getCompFilesPath() {
		return COMP_FILES_PATH;
	}
	
	public static String getExamplesPath() {
		return EXAMPLES_PATH;
	}
	
	public static String getZipPath() {
		return ZIP_PATH;
	}
	
	public static String getServerPath() {
		return SERVER_PATH;
	}
	
	public static String getDotCommand() {
		return DOT_COMMAND;
	}

	public static String getClientId() {
		return CLIENT_ID;
	}

	public static String getCallbackUri() {
		return CALLBACK_URI;
	}

}
