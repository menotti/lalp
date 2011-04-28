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

package alp.algorithms;

import java.io.DataOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.*;

import alp.components.*;
import alp.core.*;


/**
 * Generates graph representations using  
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version April, 2009
 */
public class ALPG {
	
	private Map<String, Component> ioComps = new Hashtable<String, Component>();
	private Map<String, Component> consts = new Hashtable<String, Component>();
	private Map<String, Component> iComps = new Hashtable<String, Component>();
	

	public void generateALPG(Design design) {
		generateALPG(design, "../designs/alpg");
	}
	public void generateALPG(Design design, String path) {
		System.out.print("Generating ALPG...");
		String fileName = design.getName(); 
		try {
			FileOutputStream outputFile = new FileOutputStream(path + System.getProperty("file.separator") + fileName + ".alpg");
			DataOutputStream dataOut = new DataOutputStream(outputFile);
			generateALPGFileHeader(design, dataOut);
			generateALPGComponents(design, dataOut);
			generateALPGConnections(design, dataOut);
			dataOut.close();
		}
		catch(IOException e) {
			System.err.println("Problem creating file!");
			e.printStackTrace();
			System.exit(1);
		}
		System.out.println("Ok!");
	}

	private void generateALPGFileHeader(Design design, DataOutputStream dos) throws IOException {
		dos.writeBytes("/* Copyright (c) 2009 Ricardo Menotti, All Rights Reserved.\n");
		dos.writeBytes(" *\n");
		dos.writeBytes(" * Permission to use, copy, modify, and distribute this software and its\n"); 
		dos.writeBytes(" * documentation for NON-COMERCIAL purposes and without fee is hereby granted \n");
		dos.writeBytes(" * provided that this copyright notice appears in all copies.\n");
		dos.writeBytes(" *\n");
		dos.writeBytes(" * RICARDO MENOTTI MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY\n");
		dos.writeBytes(" * OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE\n"); 
		dos.writeBytes(" * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR\n"); 
		dos.writeBytes(" * NON-INFRINGEMENT. RICARDO MENOTTI SHALL NOT BE LIABLE FOR ANY DAMAGES\n"); 
		dos.writeBytes(" * SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS\n"); 
		dos.writeBytes(" * SOFTWARE OR ITS DERIVATIVES.\n"); 
		dos.writeBytes(" *\n");
		dos.writeBytes(" * Generated at " + Calendar.getInstance().getTime() + "\n */\n\n");
		
		for (Component c : design.getComponents()) {
			if (c instanceof input || c instanceof output) {
				ioComps.put(c.getName(), c);
			}
			else if (c instanceof const_op) {
				if (consts.containsKey(c.getName())) {
					if (!((const_op)c).getValue().equals(((const_op)consts.get(c.getName())).getValue())) {
						System.exit(1);
					}
				}
				else {
					consts.put(c.getName(), c);
					dos.writeBytes("const "+c.getName()+" = "+((const_op)c).getValue()+";\n");
				}
			}
			else if (c instanceof IComponent) {
				iComps.put(c.getName(), c);
			}
		}
		dos.writeBytes("\n"+design.getName()+"(");
		int i=0;
		for (Map.Entry<String, Component> e : ioComps.entrySet()) {
			Component c = e.getValue();
			if (c instanceof input) {
				dos.writeBytes("in ");
			}
			else {
				dos.writeBytes("out ");
			}
			if (c.getWidth() == 1) {
				dos.writeBytes("fixed("+c.getWidth()+",0) ");
			}
			else {
				dos.writeBytes("fixed("+c.getWidth()+",1) ");
			}
			dos.writeBytes(e.getKey());
			if (ioComps.size() > ++i) {
				dos.writeBytes(", ");
			}
		}
		dos.writeBytes(") {\n");
	}

	private void generateALPGComponents(Design design, DataOutputStream dos) throws IOException {
		dos.writeBytes("\n\t{\n");
		for (Map.Entry<String, Component> e : iComps.entrySet()) {
			Component c = e.getValue();
			dos.writeBytes("\t\t"+e.getKey()+":\t"+c.getClass().getSimpleName()+"(");
			if (c instanceof block_ram) {
				block_ram b = (block_ram)c;
				dos.writeBytes(b.getAddressWidth()+", "+c.getWidth());
			}
			else if (c instanceof counter) {
				counter o = (counter)c;
				dos.writeBytes(o.getWidth()+", "+o.getSteps()+", "+o.getIncrement()+", "+o.getDown()+", "+o.getCondition());				
			}
			else if (c instanceof delay_op) {
				delay_op d = (delay_op)c;
				dos.writeBytes(d.getWidth()+", "+d.getDelay());
			}
			else if (c instanceof mux_m_op) {
				mux_m_op m = (mux_m_op)c;
				dos.writeBytes(m.getWidth()+", "+m.getNOps()+", "+m.getNSels());
			}
			else if (c instanceof shl_c_op_s) {
				shl_c_op_s s = (shl_c_op_s)c;
				dos.writeBytes(s.getAmount()+", "+s.getWidth());
			}
			else if (c instanceof shl_c_op) {
				shl_c_op s = (shl_c_op)c;
				dos.writeBytes(s.getAmount()+", "+s.getWidth());
			}
			else if (c instanceof shr_c_op_s) {
				shr_c_op_s s = (shr_c_op_s)c;
				dos.writeBytes(s.getAmount()+", "+s.getWidth());
			}
			else if (c instanceof shr_c_op) {
				shr_c_op s = (shr_c_op)c;
				dos.writeBytes(s.getAmount()+", "+s.getWidth());
			}
			else {
				dos.writeBytes(""+c.getWidth());
			}
			dos.writeBytes(");\n");
		}
		dos.writeBytes("\t}\n\n");
	}

	private void generateALPGConnections(Design design, DataOutputStream dos) throws IOException {
		for (Signal s : design.getSignals()) {
			Port sp = s.getSourcePort();
			Port dp = s.getDestPort();
			
			dos.writeBytes("\t"+dp.getComponent().getName());
			if (!(dp.getComponent() instanceof IOComponent))
				dos.writeBytes("."+dp.getName());
			
			dos.writeBytes(" <-("+s.getName()+") ");
			
			dos.writeBytes(sp.getComponent().getName());
			if (!(sp.getComponent() instanceof IOComponent))
				dos.writeBytes("."+sp.getName());
			dos.writeBytes(";\n");
		}
		dos.writeBytes("}\n");
	}	
}