package br.ufscar.dc.lalp.web;

public class Configs {
	
	//senha do email lalp.ufscar@gmail.com
	private static String EMAIL_PASS = "******";
	
	//caminho dos arquivos de compilação
	//private static String COMP_FILES_PATH = "C:/Users/Túlio/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/wtpwebapps/lalp/"; //tulio
	public static final String COMP_FILES_PATH = "/usr/share/apache-tomcat-7.0.14/webapps/lalp/"; //server
	
	//caminho dos exemplos
	//private static final String EXAMPLES_PATH = "C:/Users/Túlio/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/wtpwebapps/lalp/examples/"; //tulio
	private static final String EXAMPLES_PATH = "/usr/share/apache-tomcat-7.0.14/webapps/lalp/examples/"; //server
	
	//caminho do zip
	//private static final String ZIP_PATH = "C:/Users/Túlio/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/wtpwebapps/lalp/"; //tulio
	public static final String ZIP_PATH = "/usr/share/apache-tomcat-7.0.14/webapps/lalp/"; //server
	
	//caminho do server
	//private static final String SERVER_PATH = "http://localhost:8080/lalp/"; //local
	private static final String SERVER_PATH= "http://lalp.dc.ufscar.br:8080/lalp/"; //server
	
	public static final String DOT_COMMAND = "/usr/bin/dot"; //server
	//public static final String DOT_COMMAND = "/usr/local/bin/dot"; //menotti
	//public static final String DOT_COMMAND = "C:/Program Files/Graphviz/bin/dot.exe"; //tulio
	
	
	public String getEmailPass() {
		return EMAIL_PASS;
	}
	
	public String getCompFilesPath() {
		return COMP_FILES_PATH;
	}
	
	public String getExamplesPath() {
		return EXAMPLES_PATH;
	}
	
	public String getZipPath() {
		return ZIP_PATH;
	}
	
	public String getServerPath() {
		return SERVER_PATH;
	}
	
	public String getDotCommand() {
		return DOT_COMMAND;
	}



}
