package br.ufscar.dc.lalp.web;

public class Configs {
	
	//senha do email lalp.ufscar@gmail.com
	private static final String EMAIL_PASS = "************";
	
	//senha do mysql no servidor lalp.dc.ufscar.br
	private static final String MYSQL_USER = "lalp";  
	private static final String MYSQL_PASS = "************";
	
	//caminho dos arquivos de compilacao
	public static final String COMP_FILES_PATH = "/home/profs/menotti/tomcat/webapps/lalp/"; //server
	//public static final String COMP_FILES_PATH = "/usr/share/tomcat7/webapps/lalp/"; //server
	//public static final String COMP_FILES_PATH = "/Users/menotti/Documents/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/lalp/"; //menotti
	//private static String COMP_FILES_PATH = "C:/Users/Tulio/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/wtpwebapps/lalp/"; //tulio
	
	//caminho dos exemplos
	private static final String EXAMPLES_PATH = "/home/profs/menotti/tomcat/webapps/lalp/examples/"; //server
	//private static final String EXAMPLES_PATH = "/usr/share/tomcat7/webapps/lalp/examples/"; //server
	//private static final String EXAMPLES_PATH = "/Users/menotti/Documents/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/lalp/examples/"; //menotti
	//private static final String EXAMPLES_PATH = "C:/Users/Tulio/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/wtpwebapps/lalp/examples/"; //tulio
	
	//caminho do zip
	private static final String ZIP_PATH = "/home/profs/menotti/tomcat/webapps/lalp/"; //server
	//private static final String ZIP_PATH = "/usr/share/tomcat7/webapps/lalp/"; //server
	//private static final String ZIP_PATH = "/Users/menotti/Documents/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/lalp/examples/"; //menotti
	//private static final String ZIP_PATH = "C:/Users/Tulio/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/wtpwebapps/lalp/"; //tulio
	
	//caminho do server
	//private static final String SERVER_PATH= "http://projetos.ppgcc.dc.ufscar.br:9180/lalp/"; //server
	//private static final String SERVER_PATH= "http://lalp.dc.ufscar.br:8080/lalp/"; //server
	private static final String SERVER_PATH = "http://localhost/lalp/"; //local
	
	//caminho do Graphviz
	public static final String DOT_COMMAND = "/usr/bin/dot"; //server
	//public static final String DOT_COMMAND = "/usr/local/bin/dot"; //menotti
	//public static final String DOT_COMMAND = "C:/Program Files/Graphviz/bin/dot.exe"; //tulio

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

}
