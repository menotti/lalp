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
 * Sobel filter
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 */
public class sobel {
	public static void main(String[] args) {
		
		
		byte[] in = //new byte[10000]; 
		
		{
				50, 65, 62, 83, 34, 45, 96, 67,   18, 29, 
				14,	14, 72, 13, 14, 15, 16, 17,   18, 39, 
				20,	23, 82, 23, 20, 25, 26, 27,   28, 29, 
				54, 12, 72, 83, 34, 45, 96, 97,   18, 29, 
				40,	41, 42, 73, 44, 45, 46, 47,   48, 89, 
				52, 60, 82, 83, 34, 45, 96, 37,   18, 29, 
				60,	69, 62, 66, 64, 65, 64, 67,   68, 69, 
				53, 68, 72, 83, 34, 55, 96, 37,   18, 29,
				
				84,	87, 82, 83, 84, 85, 86, 87,  28, 89, 
				95,	96, 92, 93, 94, 95, 96, 97,  38, 99
			}; 
		byte[] out = new byte[100];
		
		    short cols = 10;
		    short rows = 10;              /* Image dimensions   */

		    int H, O, V, i;
		    int i00, i01, i02;
		    int i10,      i12;
		    int i20, i21, i22;
		    int w = cols;
//			for (i=0; i<100;i++)
//				in[i]=(byte)i;
		    
		    /* -------------------------------------------------------------------- */
		    /*  Iterate over entire image as a single, continuous raster line.      */
		    /* -------------------------------------------------------------------- */
		    for (i = 0; i < cols*(rows-2) - 2; i++)
		    {
		        /* ---------------------------------------------------------------- */
		        /*  Read in the required 3x3 region from the input.                 */
		        /* ---------------------------------------------------------------- */
		        i00=in[i    ]; i01=in[i    +1]; i02=in[i    +2];
		        i10=in[i+  w];                  i12=in[i+  w+2];
		        i20=in[i+2*w]; i21=in[i+2*w+1]; i22=in[i+2*w+2];

		        System.out.println(in[i] + "\t" + in[i+1] + "\t" + in[i+2]);
		        System.out.println(in[i+w] + "\t[" +i+ "]\t" + in[i+w+2]);
		        System.out.println(in[i+2*w] + "\t" + in[i+2*w+1] + "\t" + in[i+2*w+2]);
		        /* ---------------------------------------------------------------- */
		        /*  Apply horizontal and vertical filter masks.  The final filter   */
		        /*  output is the sum of the absolute values of these filters.      */
		        /* ---------------------------------------------------------------- */

		        H = -   i00 - 2*i01 -   i02 +
		            +   i20 + 2*i21 +   i22;

		        V = -   i00         +   i02
		            - 2*i10         + 2*i12
		            -   i20         +   i22;
		        System.out.print("H="+H+" V="+V+" ");
		        if (H<0)
		           H = -H;
		        if (V<0)
		           V = -V;
		        O = H + V;

		        /* ---------------------------------------------------------------- */
		        /*  Clamp to 8-bit range.  The output is always positive due to     */
		        /*  the absolute value, so we only need to check for overflow.      */
		        /* ---------------------------------------------------------------- */
		        if (O > 255) O = 255;
		        System.out.println(O);
		        System.out.println();

		        /* ---------------------------------------------------------------- */
		        /*  Store it.                                                       */
		        /* ---------------------------------------------------------------- */
		        out[i + 1] = (byte)O;
		    }
		
		
	}
}




