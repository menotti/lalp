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

public class adpcm_decoder {
	public static void main(String[] args) {
		new adpcm_decoder();
	}
	adpcm_decoder() {
		final int DATASIZE = 1024;
		short indata[] = new short[DATASIZE/2];
		char[] outdata = new char[DATASIZE];
		final int indexTable[] = {
				-1, -1, -1, -1, 2, 4, 6, 8,
				-1, -1, -1, -1, 2, 4, 6, 8,
		};
		final int stepSizeTable[] = {
				7,		8,		9,		10,		11,		12,		13,		14,		16,		17,
				19,		21,		23,		25,		28,		31,		34,		37,		41,		45,
				50,		55,		60,		66,		73,		80,		88,		97,		107,	118,
				130,	143,	157,	173,	190,	209,	230,	253,	279,	307,
				337,	371,	408,	449,	494,	544,	598,	658,	724,	796,
				876,	963,	1060,	1166,	1282,	1411,	1552,	1707,	1878,	2066,
				2272,	2499,	2749,	3024,	3327,	3660,	4026,	4428,	4871,	5358,
				5894,	6484,	7132,	7845,	8630,	9493,	10442,	11487,	12635,	13899,
				15289,	16818,	18500,	20350,	22385,	24623,	27086,	29794,	32767
		};
		for (int i = 0; i < (DATASIZE/2); i++) {
			indata[i] = (short)((i * 10 + 7) % 127);
//			if (i % 128 == 0) 
//				System.out.println();
//			System.out.print(indata[i] + ",\t");
		}
		int i;
		int len;
		int sign;
		int delta;
		int step;
		int valpred=0;
		int vpdiff;
		int index=0;
		int inputbuffer=0;
		boolean bufferstep;
		bufferstep = true;
		i=0;
		for (len = 0 ; len < DATASIZE ; len++ ) {
			debug(i); //i
			debug(indata[i]); //indata
			if ( bufferstep ) {
				delta = inputbuffer & 0xf;
			} 
			else {
				inputbuffer = indata[i++];
				delta = (inputbuffer >> 4) & 0xf;
			}
			debug(inputbuffer); //inputbuffer
			debug(delta); //delta
			debug(bufferstep); //bufferstep
			debug(indexTable[delta]); //indexTable
			step = stepSizeTable[index];
			bufferstep = !bufferstep;
			debug(stepSizeTable[index]); //stepSizeTable
			index += indexTable[delta];
			debug(step); //step
			if ( index < 0 ) 
				index = 0;
			if ( index > 88 ) 
				index = 88;
			sign = delta & 8;
			debug(sign); //sign
			debug(index); //index
			delta = delta & 7;
			debug(delta); //delta2
			vpdiff = step >> 3;
			debug(vpdiff); //vpdiff
			if ( (delta & 4) != 0 ) 
				vpdiff += step;
			else 
				if ( (delta & 2) != 0 ) 
					vpdiff += step>>1;
				else 
					if ( (delta & 1) != 0 ) 
						vpdiff += step>>2;
			debug(vpdiff); //vpdiff2
			debug(valpred); //valpred
			if ( sign != 0)
				valpred -= vpdiff;
			else
				valpred += vpdiff;
			debug(valpred); //valpred2
			if ( valpred > 32767 )
				valpred = 32767;
			else 
				if ( valpred < -32768 )
					valpred = -32768;
			debug(valpred); //valpred3
			debug(len); //len
			outdata[len] = (char)valpred;
			debug((short)outdata[len]); //outdata
			System.out.println("");
		}
	}
	
	void debug(Object o) {
		System.out.print(o+"\t");
	}
}
