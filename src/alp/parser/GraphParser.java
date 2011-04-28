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

package alp.parser;

import java.io.FileInputStream;

import alp.core.Design;
import alp.parser.graph.ALPGParser;
import alp.parser.graph.ParseException;


/**
 * Parser for .ALPG files
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version January, 2009
 */
public class GraphParser {

	Design design;
	
	public GraphParser(FileInputStream inStream) {
		ALPGParser parser = new ALPGParser(inStream);
		try {
			parser.Start();
		} catch (ParseException e) {
			System.out.println(e.getMessage());
			System.out.println(e.getStackTrace());
			System.exit(1);
		}
		design = parser.getDesign();
	}

	public Design getDesign() {
		return this.design;
	}
}
