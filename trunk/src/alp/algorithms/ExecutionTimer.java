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

import alp.ALP;

/**
 * Calculates execution time of algorithms
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://pessoal.utfpr.edu.br/menotti/">UTFPR</a>
 * @version October, 2008
 */
public class ExecutionTimer {
	  private long start;
	  private long end;

	  public ExecutionTimer() {
	    reset();
	  }

	  public void start() {
	    start = System.currentTimeMillis();
	  }

	  public void end() {
	    end = System.currentTimeMillis();
	  }

	  public long execution() {
		  return (System.currentTimeMillis()-start);
	  }
	  public long duration(){
	    return (end-start);
	  }

	  public void reset() {
	    start = 0;  
	    end   = 0;
	  }
}