package lalp.webServices;
//Author: Karan Bhandari
//WebService Implementation of lalpServer Interface
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.Date;
import java.util.Date;
import java.util.Scanner;

import javax.jws.WebService;

import lalp.algorithms.ALPG;
import lalp.algorithms.Graphviz;
import lalp.algorithms.VHDL;
import lalp.core.Design;
import lalp.parser.LangParser;
import lalp.parser.lang.SimpleNode;

@WebService(endpointInterface = "lalp.webServices.lalpServer")
public class lalpServerImplementation {
	FileInputStream inStream;
	Design design = null;
	LangParser lp = null;
	String output;
	
	
	public String getTimeAsString() { return new Date().toString(); }
	public String debugopGeneration(String in)
	{
		saveTempFile(in);
		populateDesign();
		try {
			design.generateDebugOutputs();
		} catch (Exception E2) {
			E2.printStackTrace();
			System.exit(1);
		}
		//_hw.dot
		output="----------------Hardware-------------------------------------------";
		output.concat(packageGeneratedOutputIntoString(design.getName(),"_hw.dot"));
		output.concat("----------------Software-------------------------------------------");
		output.concat(packageGeneratedOutputIntoString(design.getName(),"_sw.dot"));
		deleteTempFile(); return output;
	}
	public String graphvizGeneration(String in)
	{
		saveTempFile(in);
		populateDesign();
		Graphviz dot = new Graphviz();
		dot.generateHardwareVisualization(design);
		dot.generateSoftwareVisualization(design);
		output=packageGeneratedOutputIntoString(design.getName(),"");
		deleteTempFile(); return output;
	}

	public String graphvizSubGeneration(String in)
	{
		saveTempFile(in);
		populateDesign();
		Graphviz dot = new Graphviz();
		dot.generateHardwareVisualization(design);
		dot.generateSoftwareVisualization(design);
		dot.generateSCCSubgraphs(design);
		output=packageGeneratedOutputIntoString(design.getName(),"");
		deleteTempFile(); return output;
	}
	public String vhdlGeneration(String in)
	{
		saveTempFile(in);
		populateDesign();
		VHDL vhd = new VHDL();
		vhd.generateVHDL(design);
		output=packageGeneratedOutputIntoString(design.getName(),".vhd");
		deleteTempFile(); return output;
	}
	public String vhdlMemGeneration(String in)
	{
		saveTempFile(in);
		populateDesign();
		VHDL vhd = new VHDL();
		vhd.generateVHDL(design);
		vhd.generateVHDLInitialization(design);
		output=packageGeneratedOutputIntoString("memory",".vhd");
		deleteTempFile(); return output;
	}
	public String vhdlTbGeneration(String in)
	{
		saveTempFile(in);
		populateDesign();
		VHDL vhd = new VHDL();
		vhd.generateVHDL(design);
		vhd.generateVHDLTestbench(lp);
		output=packageGeneratedOutputIntoString("t_"+design.getName(),".vhd");
		deleteTempFile(); return output;
	}
	public String alpgGeneration(String in)
	{
		saveTempFile(in);
		populateDesign();
		ALPG alpg = new ALPG();
		alpg.generateALPG(design);
		output=packageGeneratedOutputIntoString(design.getName(),".alpg");
		deleteTempFile(); return output;
	}
	
	
	//private methods
	private String packageGeneratedOutputIntoString(String fileName,String extension) {
	String output2 =" "; 
		StringBuffer sb=new StringBuffer();
		try {
			
			Scanner scan = new Scanner(new FileReader(fileName + extension));
			while (scan.hasNext()) 
			{	
				sb.append(scan.nextLine()+"\n");
				//output2.concat(scan.nextLine());
			}
			
			
		} catch (Exception ex) { 
			
			System.out.println(ex.getMessage());
		}
		output2=sb.toString();
		return output2;

	}
	
	
	
	private void populateDesign() {
		try {inStream = new FileInputStream("temp.ALP");} catch (FileNotFoundException e1) {e1.printStackTrace();}
		lp = new LangParser(inStream);
		System.out.println("Ok!");
		lp.createComponents();
		design = lp.getDesign();
		System.out.print("Connecting hardware components...");
		lp.getRoot().connectComponents();
		if (SimpleNode.allComponents.containsKey("init")) {
			lp.getParser().design.setInit(SimpleNode.allComponents.get("init"));
		}
		System.out.println("Ok!");
	}
	private void deleteTempFile() {
		File f=new File("temp.ALP");
		f.delete();
		
	}
	private void saveTempFile(String in) {
		try {
			
			BufferedWriter out = new BufferedWriter(new FileWriter("temp.ALP"));
			out.write(in); 
			out.close(); 
		} catch (Exception ex) { 
			
			System.out.println(ex.getMessage());
		}
	}
	
	
}
