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

package br.ufscar.dc.lalp.core;

/**
 * Some <code>Design</code> parameters and compiler options.
 * 
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>


 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version September, 2007
 */
public final class Parameters {
	
	private static final int DEFAULT_DATA_WIDTH = 8;
	private static final int DEFAULT_ADDRESS_WIDTH = 8;
	
	private static int defaultDataWidth = DEFAULT_DATA_WIDTH;
	private static int defaultAddressWidth = DEFAULT_ADDRESS_WIDTH;
	
	public static boolean graphviz = false;
	public static boolean graphvizSubgraphs = false;
	public static boolean vhdl = false;
	public static boolean vhdlTestbench = false;
	public static boolean vhdlMemory = false;
	public static boolean runScc = false;
	public static boolean runDijkstra = false;
	public static boolean runDominators = false;
	public static boolean runTopological = false;
	public static boolean runAsapAlap = false;
	public static boolean runBalance = false;
	public static boolean debugOutputs = false;
	public static boolean alpg = false;
	public static boolean verbose = false;
	
	public static int getDefaultAddressWidth() {
		return defaultAddressWidth;
	}
	public static int getDefaultDataWidth() {
		return defaultDataWidth;
	}
	public static void setDefaultAddressWidth(int width) {
		Parameters.defaultAddressWidth = width;
	}
	public static void setDefaultDataWidth(int width) {
		Parameters.defaultDataWidth = width;
	}
	
	public static void info(String info) {
		System.out.println("Info: " + info);
	}
	
	public static void warning(String warn) {
		System.out.println("Warning: " + warn);
	}

	public static void error(String error) {
		System.err.println("Error: " + error);
		//System.exit(1);
	}
}
