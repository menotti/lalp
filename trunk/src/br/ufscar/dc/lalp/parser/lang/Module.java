package br.ufscar.dc.lalp.parser.lang;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Vector;

public class Module {

	
	public Vector<String> inputs = new Vector<String>();
	public Vector<String> outputs = new Vector<String>();
	
	
	Module(String name) {
		System.out.println("\nImporting module "+ name +"...");
		
		if(importFile(name))
		{
		
		//System.out.println(this.toString());
		System.out.println("Ok!");
		}
		else{
			System.err.println("Error!");
			System.exit(1);
		}
	}
	
	@Override
	public String toString() {
		return "Module [inputs=" + inputs + ", outputs=" + outputs + "]";
	}
	
	public boolean importFile(String name)
	{
/*
		FileReader reader;
		BufferedReader buffer;
		String linha = null;
		String path = new String(name);
		
		System.out.print("Reading from file " + path + "...");
		try {
			reader = new FileReader(path);
			buffer = new BufferedReader(reader);
			
			while(true)
			{
				linha = buffer.readLine();
				if(linha==null)
					break;
				
				if(linha.contains(name))
				{
				  System.out.println(linha);
				  int index = 0;
				  while(index < linha.length() && index != -1)
				  {
					  //FIXME: Corrigir exception!!
				  index = linha.indexOf("in ", index +1);
				  
				  System.out.println(index + " = " + linha.substring(index));
				  }
				}
			}
			
				
			buffer.close();
			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		
		this.inputs.add(name);
		this.outputs.add(name);
*/
		return true;
			
			
	}
	

	
	
}
