/* Copyright (c) 2009 Ricardo Menotti, All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its 
 * documentation for NON-COMERCIAL purposes and without fee is hereby granted 
 * provided that this copyright notice appears in all copies.
 *
 * RICARDO MENOTTI MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY
 * OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR 
 * NON-INFRINGEMENT. RICARDO MENOTTI SHALL NOT BE LIABLE FOR ANY DAMAGES 
 * SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS 
 * SOFTWARE OR ITS DERIVATIVES. 
 */

package lalp.algorithms;

import java.io.DataOutputStream;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import lalp.components.const_op;
import lalp.core.Component;
import lalp.core.Design;
import lalp.core.IComponent;
import lalp.core.IOComponent;
import lalp.core.Port;
import lalp.core.PortType;
import lalp.core.Signal;
import lalp.core.VHDLType;
import lalp.parser.LangParser;
import lalp.parser.lang.SimpleNode;
import lalp.core.Process;



/**
 * Used to generate VHDL files for designs, testbenchs and memory initialization
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>
 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version October, 2008
 */
public class VHDL {
	
//	private static final String DEFAULT_DIRECTORY = "../designs/hardware/";
//	private final static String DEFAULT_DIRECTORY = "/Users/ricardomenotti/Documents/workspace/designs/alpsched/";
	//private final static String DEFAULT_DIRECTORY = ".";
	//change to server path
	//private final static String DEFAULT_DIRECTORY = "/home/gabriel/DEV/Java/EclipseProjects/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/wtpwebapps/lalp/";
	private static String DEFAULT_DIRECTORY = ".";
	
	public VHDL() {
		
	}
	
	// sets server path for writing VHDL files
	public VHDL(String servletRealPath) {
		VHDL.DEFAULT_DIRECTORY = servletRealPath;
	}
	
	public void generateVHDL(Design design) {
		generateVHDL(design, DEFAULT_DIRECTORY);
	}
	public void generateVHDL(Design design, String path) {
		System.out.print("Generating VHDL...");
		String fileName = design.getName(); 
		try {
			FileOutputStream outputFile = new FileOutputStream(path + System.getProperty("file.separator") + fileName + ".vhd");
			DataOutputStream dataOut = new DataOutputStream(outputFile);
			generateVHDLFileHeader(design, dataOut);
			generateVHDLEntity(design, dataOut, false);
			generateVHDLArch(design, dataOut);
			dataOut.close();
		}
		catch(IOException e) {
			System.err.println("Problem creating file!");
			e.printStackTrace();
			System.exit(1);
		}
		System.out.println("Ok!");
		System.out.println(path + System.getProperty("file.separator") + fileName + ".vhd");
	}	
	
    /**
	 * Generate the VHDL file header including copyright information and IEEE libraries
	 * @param dos The <code>DataOutputStream</code> for the VHDL file
	 * @throws IOException
	 */
	private void generateVHDLFileHeader(Design design, DataOutputStream dos) throws IOException {
		dos.writeBytes("--\n");
		dos.writeBytes("-- Copyright (c) 2010 Ricardo Menotti, All Rights Reserved.\n");
		dos.writeBytes("--\n");
		dos.writeBytes("-- Permission to use, copy, modify, and distribute this software and its\n"); 
		dos.writeBytes("-- documentation for NON-COMERCIAL purposes and without fee is hereby granted \n");
		dos.writeBytes("-- provided that this copyright notice appears in all copies.\n");
		dos.writeBytes("--\n");
		dos.writeBytes("-- RICARDO MENOTTI MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY\n");
		dos.writeBytes("-- OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE\n"); 
		dos.writeBytes("-- IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR\n"); 
		dos.writeBytes("-- NON-INFRINGEMENT. RICARDO MENOTTI SHALL NOT BE LIABLE FOR ANY DAMAGES\n"); 
		dos.writeBytes("-- SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS\n"); 
		dos.writeBytes("-- SOFTWARE OR ITS DERIVATIVES.\n"); 
		dos.writeBytes("--\n");
		dos.writeBytes("-- Generated at " + Calendar.getInstance().getTime() + "\n--\n\n");
		dos.writeBytes("-- IEEE Libraries --\n");
		dos.writeBytes("library IEEE;\n");
		dos.writeBytes("use IEEE.std_logic_1164.all;\n");
		dos.writeBytes("use IEEE.std_logic_arith.all;\n");
		dos.writeBytes("use IEEE.std_logic_unsigned.all;\n");
	}
	/**
		 * Generate the VHDL entity 
		 * @param dos The <code>DataOutputStream</code> for the VHDL file
		 * @throws IOException
		 */
		private void generateVHDLEntity(Design design, DataOutputStream dos, boolean testbench) throws IOException {
			boolean dp;
			Map<String, Component> cl = new TreeMap<String, Component>();
			String type;
			dos.writeBytes("entity ");
			if (testbench)
				dos.writeBytes("t_");
			dos.writeBytes(design.getName() + " is\n");
	//		dos.writeBytes("\tgeneric (\n");
	//		if (!testbench) {
	//			dos.writeBytes("\t\tstages\t\t: integer := " + design.getStages() + ";\n");
	//			dos.writeBytes("\t\taddr_width\t: integer := " + design.getAddressWidth() + ";\n");
	//			dos.writeBytes("\t\titerations\t: integer := " + design.getIterations() + ";\n");
	//		}
	//		dos.writeBytes("\t\tbits\t\t: integer := " + design.getDataWidth() + "\n");
	//		dos.writeBytes("\t);\n");
			if (!testbench) {
				// the list of IO ports
				dos.writeBytes("\tport (\n");
				// global components (clk etc)
				for (Map.Entry<String,Component> s : design.getGlobalComponents().entrySet())
					cl.put(s.getKey(), s.getValue());
				// regular components
				for (Component c : design.getComponents())
					if (c.isIOComponent())
						cl.put(c.getName(), c);
                                
				dp = false;
				for (Map.Entry<String, Component> c : cl.entrySet()) {
					IOComponent ioc = (IOComponent)c.getValue();
					Port p = ioc.getPort();
					if (testbench && (p.getType()==PortType.OUTPUT))
						continue;
					if (p.getDataType() == VHDLType.STD_LOGIC) {
						type = "std_logic";
					}
					else {
						String size;
//						if (design.getDataWidth() == p.getWidth())
//							size = "bits-1";
//						else
							size = new Integer(p.getWidth()-1).toString();
						type = "std_logic_vector(" + size + " downto 0)";
					}
					if (dp) {
						dos.writeBytes(";\n");
					}
					else {
						dp = true;
					}
					dos.writeBytes("\t\t\\" + p.getName() + "\\\t: " + ioc.getType().getVHDLName() + "\t" + type);
				}
				dos.writeBytes("\n\t);\n");
			}
			dos.writeBytes("end ");
			if (testbench)
				dos.writeBytes("t_");	
			dos.writeBytes(design.getName() + ";\n\n");
		}
	/**
	 * Generate the VHDL architecture
	 * @param dos The <code>DataOutputStream</code> for the VHDL file
	 * @throws IOException
	 */
	private void generateVHDLArch(Design design, DataOutputStream dos) throws IOException {
		generateVHDLArchHeader(design, dos);
		generateVHDLArchBody(design, dos);
	}
    /**
	 * Generate architecture header including component declaration and signals 
	 * @param dos The <code>DataOutputStream</code> for the VHDL file
	 * @throws IOException
	 */
	private void generateVHDLArchHeader(Design design, DataOutputStream dos) throws IOException {
		String size, type;
		dos.writeBytes("architecture behavior of " + design.getName() + " is\n\n");
		// dump VHDL component declaration
		Map<String, IComponent> comps = new TreeMap<String, IComponent>();
		// create a map with used components
		for (Component c : design.getComponents()) {
			if (c.isIComponent())
					comps.put(((IComponent)c).getVHDLInstantiationName(), (IComponent)c);
		}
		for (IComponent ic : comps.values()) {
			dos.writeBytes(ic.getVHDLDeclaration());
		}
		// list of signals
		for (Signal s : design.getSignals()) {
			// not an alias
			if (s.getSignal() == null) {
				if (s.getDataType() == VHDLType.STD_LOGIC) {
					type = "std_logic";
				}
				else {
//					if (design.getDataWidth() == s.getWidth())
//						size = "bits-1";
//					else
						size = new Integer(s.getWidth()-1).toString();
					type = "std_logic_vector(" + size + " downto 0)";
				}
			dos.writeBytes("signal " + s.getName() + "\t: " + type + ";\n");
			}
		}
	}
	/**
	 * Generate architecture body including component map and signal attribution
	 * @param dos The <code>DataOutputStream</code> for the VHDL file
	 * @throws IOException
	 */
	private void generateVHDLArchBody(Design design, DataOutputStream dos) throws IOException {
		dos.writeBytes("\nbegin\n\n");
		for (Component c : design.getComponents()) {
			if (c.isIComponent()) {
				dos.writeBytes(((IComponent)c).getVHDLInstantiation());
			}
		}
		// IO ports attributions  
		for (Component c : design.getComponents()) {
			if (!c.isIComponent()) {
				IOComponent ioc = (IOComponent)c;
				Port p = ioc.getPort();
				Signal s = p.getSignal();
				Signal alias = s.getSignal();
				while (alias != null) {
					s = alias;
					alias = s.getSignal();
				}
				// there is a connected signal
				if (s != null) {
					if (p.getType() == PortType.INPUT) {
						if (p.getDataType() == s.getDataType())
							if (p.getWidth() == s.getWidth())
								dos.writeBytes("\t\\" + p.getName() + "\\ <= " + s.getName() + ";\n");
							else {
								if (p.getWidth() < s.getWidth()) {
									dos.writeBytes("\t\\" + p.getName() + "\\(" + (p.getWidth()-1) + " downto 0) <= " + s.getName() + "(" + (p.getWidth()-1) + " downto 0);\n");
								}
								else {
									dos.writeBytes("\t\\" + p.getName() + "\\(" + (s.getWidth()-1) + " downto 0) <= " + s.getName() + "(" + (s.getWidth()-1) + " downto 0);\n");
								}
							}
						else {
							if (s.getDataType() == VHDLType.STD_LOGIC)
								dos.writeBytes("\t\\" + p.getName() + "\\(0) <= " + s.getName() + ";\n");
							else
								dos.writeBytes("\t\\" + p.getName() + "\\ <= " + s.getName() + "(0);\n");
						}
					}
					else {
						dos.writeBytes("\t" + s.getName() + " <= ");
						if (c.isIOComponent())
							dos.writeBytes("\\" + p.getName() + "\\;\n");
						// constant values
						else
							dos.writeBytes("conv_std_logic_vector(" + ((const_op)c).getValue() + ", " + s.getWidth() + ");\n");
					}
				}
			}
		}
		dos.writeBytes("\nend behavior;\n\n");
	}
	
	public void generateVHDLInitialization(Design design) {
		generateVHDLInitialization(design, DEFAULT_DIRECTORY);
	}
	
	public void generateVHDLInitialization(Design design, String path) {
		System.out.print("Generating VHDL initialization...");
		try {
			FileOutputStream outputFile = new FileOutputStream(path + System.getProperty("file.separator") + "memory.vhd");
			DataOutputStream dataOut = new DataOutputStream(outputFile);
			generateVHDLFileHeader(design, dataOut);
			for (Component c : design.getComponents()) {
				if (c.isVHDLInitializable())
					c.generateInitialization(dataOut);
			}
			dataOut.close();
		}
		catch(Exception e) {
			System.err.println("Problem creating file!");
			e.printStackTrace();
			System.exit(1);
		}
		System.out.println("Ok!");
	}	
	/**
	 * Generate the VHDL testbench file
	 */
        public void generateVHDLTestbench(LangParser lp)
        {
            generateVHDLTestbench(lp, DEFAULT_DIRECTORY);
        }
        
        public void generateVHDLTestbench(LangParser lp, String path) {
                Design design = lp.getDesign();
                System.out.print("Generating VHDL testbench...");
		String fileName = design.getName(); 
		try {
			//lp.getParser().allResults;
			FileOutputStream outputFile = new FileOutputStream(path + System.getProperty("file.separator") + "t_" + fileName + ".vhd");
			DataOutputStream dataOut = new DataOutputStream(outputFile);
			generateVHDLFileHeader(design, dataOut);
			generateVHDLEntity(design, dataOut, true);
			generateVHDLComponent(lp, dataOut);
			dataOut.close();
		}
		catch(IOException e) {
			System.err.println("Problem creating file!");
			e.printStackTrace();
			System.exit(1);
		}
		System.out.println("Ok!");
	}
	private void generateVHDLComponent(LangParser lp, DataOutputStream dos) throws IOException {
		Design design = lp.getDesign();
		boolean dp, f = false;
		Map<String, Component> cl = new TreeMap<String, Component>();
		String size, type, init;
		dos.writeBytes("architecture behavior of t_" + design.getName() + " is\n\n");
		dos.writeBytes("component " + design.getName() + "\n");  
//		dos.writeBytes("\tgeneric (\n");
//		dos.writeBytes("\t\tbits\t\t: integer := " + design.getDataWidth() + ";\n");
//		dos.writeBytes("\t\tstages\t\t: integer := " + design.getStages() + ";\n");
//		dos.writeBytes("\t\taddr_width\t: integer := " + design.getAddressWidth() + ";\n");
//		dos.writeBytes("\t\titerations\t: integer := " + design.getIterations() + "\n");
//		dos.writeBytes("\t);\n");
		// the list of IO ports
		dos.writeBytes("\tport (\n");
		// global components (clk etc)
		for (Map.Entry<String,Component> s : design.getGlobalComponents().entrySet())
			cl.put(s.getKey(), s.getValue());
		// regular components
		for (Component c : design.getComponents())
			if (c.isIOComponent())
				cl.put(c.getName(), c);
		dp = false;
		for (Map.Entry<String, Component> c : cl.entrySet()) {
			IOComponent ioc = (IOComponent)c.getValue();
			Port p = ioc.getPort();
			if (p.getDataType() == VHDLType.STD_LOGIC) {
				type = "std_logic";
			}
			else {
//				if (design.getDataWidth() == p.getWidth())
//					size = "bits-1";
//				else
					size = new Integer(p.getWidth()-1).toString();
				type = "std_logic_vector(" + size + " downto 0)";
			}
			if (dp) {
				dos.writeBytes(";\n");
			}
			else {
				dp = true;
			}
			dos.writeBytes("\t\t\\" + p.getName() + "\\\t: " + ioc.getType().getVHDLName() + "\t" + type);
		}
		dos.writeBytes("\n\t);\n");
		dos.writeBytes("end component;\n\n");  
		for (Map.Entry<String, Component> c : cl.entrySet()) {
			IOComponent ioc = (IOComponent)c.getValue();
			Port p = ioc.getPort();
			//if ((p.getType()==PortType.OUTPUT)) {
				if (p.getDataType() == VHDLType.STD_LOGIC) {
					type = "std_logic";
					init = "'0'";
				}
				else {
//					if (design.getDataWidth() == p.getWidth())
//						size = "bits-1";
//					else
						size = new Integer(p.getWidth()-1).toString();
					type = "std_logic_vector(" + size + " downto 0)";
					init = "(others => '0')";
				}
				dos.writeBytes("signal \\" + p.getName() + "\\\t: " + type + "\t:= " + init + ";\n");
			//}
		}		
		dos.writeBytes("\nbegin\n\n");
		dos.writeBytes("uut: " + design.getName() + "\nport map (\n");
		for (Map.Entry<String, Component> c : cl.entrySet()) {
			IOComponent ioc = (IOComponent)c.getValue();
			Port p = ioc.getPort();
			if (f) {
				dos.writeBytes(",\n");
			}
			else {
				f = true;
			}
			dos.writeBytes("\t\\" + p.getName() + "\\ => \\" + p.getName() + "\\");
		}
			dos.writeBytes("\n);\n");
		if(design.isSync()){
			dos.writeBytes("\nclock: process\n"); 
			dos.writeBytes("begin\n");
			dos.writeBytes("\twait for 5 ns;\n");
			dos.writeBytes("\t\\clk\\  <= not \\clk\\;\n");
			dos.writeBytes("end process clock;\n");
			dos.writeBytes("\nstimulus: process\n"); 
			dos.writeBytes("begin\n");
			dos.writeBytes("\t\\reset\\  <= '1';\n");
			dos.writeBytes("\twait for 50 ns;\n");
			dos.writeBytes("\t\\reset\\  <= '0';\n");
			dos.writeBytes("\twait for 50 ns;\n");
			dos.writeBytes("\t\\init\\  <= '1';\n");
			dos.writeBytes("\twait;\n");
			dos.writeBytes("end process stimulus;\n");
		}
		
		for(Map.Entry<String, SimpleNode> entry: lp.getParser().allTestbenchEntries.entrySet())
			{
				dos.writeBytes("\n" +entry.getKey()+ "_atribution: process\n");
				dos.writeBytes("begin\n");
				if(lp.getDesign().isSync())
					dos.writeBytes("\n\twait until \\init\\ = '1';\n");
				else
					dos.writeBytes("\n\twait for 10 ns;\n");
				for(int i = 0; i <  entry.getValue().getArraySize(); i++)
				{
					dos.writeBytes("\t\\" +entry.getKey()+ "\\ <= conv_std_logic_vector(" + entry.getValue().getInits().get(i) + "," + entry.getValue().getWidth() +");");
					dos.writeBytes("\n\twait for 10 ns;\n");
				}
				dos.writeBytes("\n\twait for 10 ns;\n");
				dos.writeBytes("\t\\" +entry.getKey()+ "\\ <= conv_std_logic_vector('X', "+entry.getValue().getWidth()+");");
				dos.writeBytes("\nwait;");
				dos.writeBytes("\nend process "+entry.getKey()+ "_atribution;\n");
			}
						
		
			
		
		GenerateVHDLAsserts(lp, dos);
		
	}
	
	/**
	 * Generate the processes that will check if the results are correct
	 * @author João Vitor Brandão
	 * @param lp
	 * @param dos
	 * @throws IOException
	 */
	private void GenerateVHDLAsserts(LangParser lp, DataOutputStream dos) throws IOException
	{
		for(Process process : lp.getParser().allProcesses)
		{
			String conditionalSignal = process.getConditionalSignal();
			if(process.getCheckingType() == Process.CheckingType.WHEN)
			{				
				for(SimpleNode result : process.getResults())
				{
					dos.writeBytes("\nprocess\n"); 
					dos.writeBytes("\nbegin\n");
					dos.writeBytes("\n\twait for 10 ns;\n");
					for(int i =  0 ; i < result.getArraySize(); i++)
					{
						if(i ==0)
						{
							dos.writeBytes("\n\twait on \\" +conditionalSignal +"\\;\n");
							dos.writeBytes("\tassert \\" +result.getIdentifier() + "\\ = " + "conv_std_logic_vector(" + result.getInits().get(i) + "," + result.getWidth() +")");
							dos.writeBytes("\n\t\treport \"value different from the expected\" severity error;\n");
						}
						//In case of two or more equal results in sequence, just one assert will be generated to avoid errors
						else if(result.getInits().get(i) != result.getInits().get(i-1))
						{
							dos.writeBytes("\n\twait on \\" +conditionalSignal +"\\;\n");
							dos.writeBytes("\tassert \\" +result.getIdentifier() + "\\ = " + "conv_std_logic_vector(" + result.getInits().get(i) + "," + result.getWidth() +")");
							dos.writeBytes("\n\t\treport \"value different from the expected\" severity error;\n");
						}
					}
					dos.writeBytes("\n\tassert false report \"end of test of \\"+result.getIdentifier()+"\\\" severity note;");
					dos.writeBytes("\n\nwait;\n");
					dos.writeBytes("end process;\n");
				}
									
			}
			else if(process.getCheckingType() == Process.CheckingType.FOREACH)
			{
				
				for(SimpleNode result : process.getResults())
				{
					dos.writeBytes("\nprocess\n");
					dos.writeBytes("\nbegin\n");
					dos.writeBytes("\n\twait for 10 ns;\n");
					dos.writeBytes("\n\twait on \\" + result.getIdentifier() + "\\;\n");
					for(int i =  0 ; i < result.getArraySize(); i++)
					{
						if(i != 0)
						{
							if(i == 1)
							{
								if(process.getValue() == 0)
									dos.writeBytes("\n\twait for 12 ns;\n");
								else
								{
									int aux = process.getValue() + 2;
									dos.writeBytes("\n\twait for "+ aux +" ns;\n");
								}
							}
							else if(process.getValue() == 0)
								dos.writeBytes("\n\twait for 10 ns;\n");
							else
								dos.writeBytes("\n\twait for "+ process.getValue() +" ns;\n");
						}
						dos.writeBytes("\tassert \\" + result.getIdentifier() + "\\ = " + "conv_std_logic_vector(" + result.getInits().get(i) + "," + result.getWidth() +")");
						dos.writeBytes("\n\t\treport \"value different from the expected\" severity error;\n");
					}
					dos.writeBytes("\n\tassert false report \"end of test of \\"+result.getIdentifier()+"\\\" severity note;");
					dos.writeBytes("\n\nwait;\n");
					dos.writeBytes("end process;\n");
				}				
			}
			else
			{
				for(SimpleNode result : process.getResults())
				{
					dos.writeBytes("\nprocess\n");
					dos.writeBytes("\nbegin\n");
					dos.writeBytes("\n\twait until \\" +conditionalSignal+ "\\ = '" +process.getValue()+ "';\n");
					for(int i =  0 ; i < result.getArraySize(); i++)
					{
						dos.writeBytes("\tassert \\" + result.getIdentifier() + "\\ = " + "conv_std_logic_vector(" + result.getInits().get(i) + "," + result.getWidth() +")");
						dos.writeBytes("\n\t\treport \"value different from the expected\" severity error;\n");
						if(i == 0)
							dos.writeBytes("\n\twait for 12 ns;\n");
						else
							dos.writeBytes("\n\twait for 10 ns;\n");
					}
					dos.writeBytes("\n\tassert false report \"end of test of \\"+result.getIdentifier()+"\\\" severity note;");
					dos.writeBytes("\n\nwait;\n");
					dos.writeBytes("end process;\n");										
				}
			}
			
		}
		dos.writeBytes("\nend behavior;\n");
	}
	

}
