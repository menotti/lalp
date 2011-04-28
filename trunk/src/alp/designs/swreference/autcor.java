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

package alp.designs.swreference;


/**
 * Autocorrelation
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 */
public class autcor {
	public static void main(String[] args) {
		final int N = 32;
		final int M = 16;
		short[] sd = new short[N];
		short[] ac = new short[M];
		//
		System.out.print("ac:");
		for (int i = 0; i < M; i++) {
			ac[i] = (short)(i + 7);
			System.out.print(" " + ac[i]);
		}
		System.out.println();
		System.out.print("sd:");
	    for (int k = 0; k < N; k++) { //N-M not N: out of bound
			sd[k] = (short)(k * 2 - 7);
			System.out.print(" " + sd[k]);
	    }
		System.out.println();
		//
		for (int i = 0; i < M; i++) {
			int sum = 0;
		    for (int k = 0; k < N-M; k++) {
		      sum += sd[k+M] * sd[k+M-i];
		      System.out.println("sd["+(k+M)+"] * sd["+(k+M-i)+"]");
		    }
		    ac[i] = (short)(sum >> 15);
		    System.out.println("ac["+i+"]="+(short)(sum >> 15));
		}
		//
		System.out.print("ac:");
		for (int i = 0; i < M; i++)
			System.out.print(" " + ac[i]);
		System.out.println();
		System.out.print("sd:");
	    for (int k = 0; k < N; k++)
			System.out.print(" " + sd[k]);
		System.out.println();
		//
	}
}



//// Nt is the number of autocorrelation terms
//// Nx is the number of data-points
//static void autoc(short sd[], short ac[], short Nx, short Nt) {
//
// for (short i = 0; i < Nt; i++) {
//  int sum = 0;
//
//  for (short k = Nt; k < Nx; k++) {
//   sum += sd[k] * sd[k-i];
//  }
//
//  ac[i] = (short) (sum >> 15);
// }
//}
