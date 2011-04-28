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

package lalp.components;

import java.io.DataOutputStream;
import java.io.IOException;

import lalp.core.Generic;
import lalp.core.IComponent;
import lalp.core.Parameters;
import lalp.core.Port;
import lalp.core.PortType;



/**
 * A block ram.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version September, 2007
 */
public class block_ram extends IComponent {
	private long[] initialValue = null;
	private int addressWidth = 8;
	public block_ram() {
		this(Parameters.getDefaultAddressWidth(), Parameters.getDefaultDataWidth());
	}
	public block_ram(int addressWidth) {
		this(addressWidth, Parameters.getDefaultDataWidth());
	}
	public block_ram(int addressWidth, int dataWidth) {
		super(dataWidth);
		setDelay(2);
		setAddressWidth(addressWidth);
		Generic generic;
		super.addPort(new Port("clk", PortType.INPUT));
		super.addPort(new Port("we", PortType.INPUT));
		super.addPort(new Port("oe", PortType.INPUT));
		generic = new Generic("address_width", "integer", 8);
		super.addGeneric(generic);
		super.addPort(new Port("address", PortType.INPUT, addressWidth, generic), true);
		generic = new Generic("data_width", "integer", 16);
		super.addGeneric(generic);
		super.addPort(new Port("data_in", PortType.INPUT, dataWidth, generic));
		super.addPort(new Port("data_out", PortType.OUTPUT, dataWidth, generic), true);
	}
	public block_ram(String name) {
		this();
		super.name = name;
	}
	public block_ram(String name, int addressWidth) {
		this(addressWidth);
		super.name = name;
	}
	public block_ram(String name, int addressWidth, int dataWidth) {
		this(addressWidth, dataWidth);
		super.name = name;
	}
	public void generateInitialization(DataOutputStream dos) throws Exception, IOException {
		if (initialValue == null)
			return;
		int dataSize = getWidth();
		int memoryWords = (int)Math.pow(2, getAddressWidth());
		if (initialValue.length > memoryWords)
			throw new Exception("Memory initialization values exceeds capacity");
		dos.writeBytes("\nlibrary IEEE;\n");
		dos.writeBytes("use IEEE.std_logic_1164.all;\n");
		dos.writeBytes("use IEEE.std_logic_arith.all;\n");
		dos.writeBytes("use IEEE.std_logic_unsigned.all;\n\n");
		dos.writeBytes("entity " + getVHDLInstantiationName() + " is\n");
		dos.writeBytes("generic(\n");
		dos.writeBytes("	data_width : integer := 8;\n");
		dos.writeBytes("	address_width : integer := 8\n");
		dos.writeBytes(");\n");
		dos.writeBytes("port(\n");
		dos.writeBytes("	data_in : in std_logic_vector(data_width-1 downto 0) := (others => '0');\n");
		dos.writeBytes("	address : in std_logic_vector(address_width-1 downto 0);\n");
		dos.writeBytes("	we: in std_logic := '0';\n");
		dos.writeBytes("	oe: in std_logic := '1';\n");
		dos.writeBytes("	clk : in std_logic;\n");
		dos.writeBytes("	data_out : out std_logic_vector(data_width-1 downto 0));\n");
		dos.writeBytes("end " + getVHDLInstantiationName() + ";\n");
		dos.writeBytes("\n");
		dos.writeBytes("architecture rtl of " + getVHDLInstantiationName() + " is\n");
		dos.writeBytes("\n");
		dos.writeBytes("constant mem_depth : integer := 2**address_width;\n");
		dos.writeBytes("type ram_type is array (mem_depth-1 downto 0)\n");
		dos.writeBytes("of std_logic_vector (data_width-1 downto 0);\n");
		dos.writeBytes("\n");
		dos.writeBytes("signal read_a : std_logic_vector(address_width-1 downto 0);\n");
		dos.writeBytes("signal RAM : ram_type := ram_type'(\n");
		for (int i = memoryWords-1; i >= 0; i--) {
			long value;
			String bin;
			String zeros = "0000000000000000000000000000000000000000000000000000000000000000";
			if (i < initialValue.length)
				value = initialValue[i];
			else
				value = 0;
			bin = Long.toBinaryString(value);
			if (value >= 0) {
				bin = zeros.substring(bin.length())+bin;
			}
			if (bin.length() > dataSize)
				bin = bin.substring(64-dataSize);
//			if (value < 0)
//				bin = Long.toBinaryString((value)).substring(32-dataSize);
//			else
//				bin = "00" + Integer.toBinaryString((int)(value+Math.pow(2, 30))).substring(33-dataSize);
			dos.writeBytes("\t (\"" + bin + "\")");
			if (i==0)
				dos.writeBytes(");");
			else
				dos.writeBytes(",");
			dos.writeBytes("\t -- " + i + "\t" + value + "\n");	
		}
		dos.writeBytes("\nbegin\n");
		dos.writeBytes("  process (clk)\n");
		dos.writeBytes("  begin\n");
		dos.writeBytes("    if (clk'event and clk = '1') then\n");
		dos.writeBytes("      if (we = '1') then\n");
		dos.writeBytes("        RAM(conv_integer(address)) <= data_in;\n");
		dos.writeBytes("        data_out <= RAM(conv_integer(read_a));\n");
		dos.writeBytes("      elsif (oe = '1') then\n");
		dos.writeBytes("        data_out <= RAM(conv_integer(read_a));\n");
		dos.writeBytes("      end if;\n");
		dos.writeBytes("      read_a <= address;\n");
		dos.writeBytes("    end if;\n");
		dos.writeBytes("  end process;\n");
		dos.writeBytes("end rtl;\n");
		return;
	}
	 
	public String getVHDLDeclaration() {
		String d = new String();
		d += "component " + getVHDLInstantiationName() + "\n";  
		d += "generic (\n";
		d += "	data_width		: integer := 8;\n";
		d += "	address_width	: integer := 8\n";
		d += ");\n";
		d += "port (\n";
		d += "	clk			: in	std_logic;\n";
		d += "	we			: in	std_logic := '0';\n";
		d += "	oe			: in	std_logic := '1';\n";
		d += "	address		: in	std_logic_vector(address_width-1 downto 0);\n";
		d += "	data_in		: in	std_logic_vector(data_width-1 downto 0) := (others => '0');\n";
		d += "	data_out	: out	std_logic_vector(data_width-1 downto 0)\n";
		d += ");\n";
		d += "end component;\n";
		d += "\n";
		return d;
	}
	public String getVHDLInstantiationName() {
		if (initialValue == null)
			return getClass().getSimpleName();
		else
			return getClass().getSimpleName() + "_" + getName();
	}
	public boolean isVHDLInitializable() {
		return true;
	}
	public void setInitialValue(long[] initialValue) {
		this.initialValue = initialValue;
	}
	public void setInitialValue(int[] initialValue) {
		this.initialValue = new long[initialValue.length];
		for (int i=0; i<initialValue.length; i++)
			this.initialValue[i] = initialValue[i];
	}
	public long[] getInitialValue() {
		return this.initialValue;
	}
	public void setAddressWidth(int addressWidth) {
		this.addressWidth = addressWidth;
	}
	public int getAddressWidth() {
		return this.addressWidth;
	}
}
