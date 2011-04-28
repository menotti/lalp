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

public class adpcm_coder {
	public static void main(String[] args) {
		new adpcm_coder();
	}
	adpcm_coder() {
		// memory initialization section begins
		final int DATASIZE = 1024;
		short indata[] = new short[DATASIZE];
		char[] outdata = new char[DATASIZE/2];
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
		for (int i = 0; i < DATASIZE; i++) {
			indata[i] = (short)((i * 10 + 7) % 127);
//			if (i % 128 == 0) 
//				System.out.println();
//			System.out.print(indata[i] + ",\t");
		}
		// memory initialization section ends
		int i, di; //di=debug i
		int len;
		int val;		
		int sign;		
		int delta;		
		int diff;		
		int step;		
		int valpred=0;	
		int vpdiff;		
		int index = 0;		
		int outputbuffer=0;
		boolean bufferstep;
		bufferstep = true;
		i=0;
		for (len = 0 ; len < DATASIZE ; len++ ) {
			debug(len); //len
			val = indata[len];
			debug(val); //val
			diff = val - valpred;
			debug(diff); //diff
			sign = (diff < 0) ? 8 : 0;
			debug(sign); //sign
			step = stepSizeTable[index];
			if ( sign != 0 ) 
				diff = (-diff);
			debug(stepSizeTable[index]); //stepSizeTable
			debug(diff); //diff2
			debug(step); //step
			delta = 0;
			vpdiff = (step >> 3);
			debug(vpdiff); //vpdiff
			if ( diff >= step ) {
				delta = 4;
				diff -= step;
				vpdiff += step;
			}
			debug(delta); //delta
			debug(diff); //diff3
			debug(vpdiff); //vpdiff2
			step >>= 1;
			debug(step); //step2
			if ( diff >= step ) {
				delta |= 2;
				diff -= step;
				vpdiff += step;
			}
			debug(delta); //delta2
			debug(diff); //diff4
			debug(vpdiff); //vpdiff3
			step >>= 1;
			debug(step); //step3
			if ( diff >= step ) {
				delta |= 1;
				vpdiff += step;
			}
			debug(delta); //delta3
			debug(vpdiff); //vpdiff4
			if ( sign != 0 )
				valpred -= vpdiff;
			else
				valpred += vpdiff;
			debug(valpred); //valpred2
			if ( valpred > 32767 )
				valpred = 32767;
			debug(valpred); //valpred3
			if ( valpred < -32768 )
				valpred = -32768;
			debug(valpred); //valpred
			delta |= sign;
			debug(delta); //delta4
			index += indexTable[delta];
			debug(index); //index2
			if ( index < 0 ) 
				index = 0;
			debug(index); //index3
			if ( index > 88 ) 
				index = 88;
			debug(index); //index
			debug(i); //i
			di=i;
			if ( bufferstep ) {
				outputbuffer = (delta << 4) & 0xf0;
			}
			else {
				outdata[i++] = (char)((delta & 0x0f) | outputbuffer);
			} 
			debug(outputbuffer); //outputbuffer
			debug((int)outdata[di]); //outdata[i]
			bufferstep = !bufferstep;
			debug(bufferstep); //bufferstep
			System.out.println("");
		}
		if ( !bufferstep )
			outdata[i++] = (char)outputbuffer;
	}
	
	void debug(Object o) {
		System.out.print(o+"\t");
	}
}
