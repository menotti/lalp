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

/*
  This is the 8x8 DCT (Discrete Cosine Transform) algorithm.

  Source: ftp://ftp.ti.com/pub/tms320bbs/c62xfiles/dct.asm

  DSP IMPLEMENTATION
  Cycles = 48 + 160 * num_fdcts
  for num_fdcts >= 1
  208 cycles or 1.04 �s for one 8x8
  Block of Data


  MAIN differences:
  - pointer-free version
  - added two auxiliar arrays:
  dct_io_ptr -> |ROW| -> dct_io_tmp -> |COL| -> dct_o

  An improvement can be done in order to use always the array dct_io_tmp of size 64 
  and so mapped to internal memories (faster accesses).
  However, such improvement needs that the image are traversed with an outer loop
  which is not so good since the DCT does not fit entirely in a realistic XPP.

 */

//import Stubs.*;

public class fdct {

	/**
	 * Main program.
	 */
  	public static void main(String args[]) {

		// 5400 NTSC: 720x480 => 90 x 60 blocks of 8x8; if 1 then 8x8 DCT
		short num_fdcts = 10; // 5400;

		final int N = 8; // fixed

		final int M = N*N;

		int SIZE = num_fdcts*M;

		short[] dct_io_ptr = new short[SIZE];

		short[] dct_io_tmp = new short[SIZE]; 

		short[] dct_o = new short[SIZE];

//		IO.getStream("input4.ram",dct_io_ptr);
//		Stubs.IO.genRandomRamValues("mem0.dat", SIZE, Short.MAX_VALUE);
//		Stubs.IO.getStreamHADESFormat("mem0.dat", dct_io_tmp);

		for (int i=0; i<dct_io_ptr.length; i++) {
			dct_io_ptr[i] = (short)((i*(-i%3) + i*((i+1)%3))-232);
//			if ((i % 8) == 0) 
//				System.out.println();
//			System.out.print((i*(-i%3) + i*((i+1)%3))-232 + ",	");
		}
		
		fdct.doFDCT(dct_io_ptr, dct_io_tmp, dct_o, num_fdcts);
		
//		System.out.println("dct_io_ptr");
//		fdct.print(dct_io_ptr);
//		System.out.println("dct_io_tmp");
//		fdct.print(dct_io_tmp);
//		System.out.println("dct_o");
//		fdct.print(dct_o);

//		fdct.Loop2FDCT(dct_io_tmp, dct_o, num_fdcts);

//		Stubs.IO.putStreamHADESFormat("mem1_correct.dat", dct_o);

//		IO.putStream("output4.ram",dct_o);
//		IO.putStreamBin("middle4BINcorrect.ram",dct_io_tmp);
	}

	public static void doFDCT(short[] dct_io_ptr, short[] dct_io_tmp, short[] dct_o, short num_fdcts) {

		final int N = 8; // fixed

		//void fdct_8x8(short dct_data, unsigned num_fdcts)  

		/* -------------------------------------------------------- /    
       /  Set up the cosine coefficients c0..c7.                  /    
       / -------------------------------------------------------- */    
		int c1 = 0x2C62, c3 = 0x25A0;                    
		int c5 = 0x1924, c7 = 0x08D4;                    
		int c0 = 0xB505, c2 = 0x29CF;                    
		int c6 = 0x1151;                                 

		/* -------------------------------------------------------- /    
       /  Intermediate calculations.                              /    
       / -------------------------------------------------------- */    
		int f0, f1, f2, f3,f4, f5, f6, f7;       // Spatial domain samples.
		int g0, g1, h0, h1,p0, p1;               // Even-half intermediate.
		int r0, r1;               // Even-half intermediate.
		int P0, P1, R0, R1;       // Even-half intermediate.
		int g2, g3, h2, h3;       // Odd-half intermediate.
		int q0a,s0a,q0, q1,s0, s1;               // Odd-half intermediate.          
		int Q0, Q1, S0, S1;       // Odd-half intermediate.
		int F0, F1, F2, F3, F4, F5, F6, F7;       // Freq. domain results.
		int F0r,F1r,F2r,F3r,F4r,F5r,F6r,F7r;      // Rounded, truncated results.


		/* -------------------------------------------------------- /    
       /  Outer vertical loop -- Process each 8x8 block.          /    
       / -------------------------------------------------------- */    
		//dct_io_ptr = dct_data;    
		int i_1 = 0;
		for (int i = 0; i < num_fdcts; i++) {                                                                 
			/* ---------------------------------------------------- /    
			 /  Perform Vert 1-D FDCT on columns within each block. /    
			 / ---------------------------------------------------- */    
			for (int j = 0; j < N; j++) {                                                             
				/* ------------------------------------------------ /    
	   /  Load the spatial-domain samples.                /    
	   / ------------------------------------------------ */    
				f0 = dct_io_ptr[ 0+i_1]; //step 4                                     
				f1 = dct_io_ptr[ 8+i_1];                                      
				f2 = dct_io_ptr[16+i_1];                                      
				f3 = dct_io_ptr[24+i_1];                                      
				f4 = dct_io_ptr[32+i_1];                                      
				f5 = dct_io_ptr[40+i_1];                                      
				f6 = dct_io_ptr[48+i_1];                                      
				f7 = dct_io_ptr[56+i_1]; //step 11                                      

				debug(f0);
				debug(f1);
				debug(f2);
				debug(f3);
				debug(f4);
				debug(f5);
				debug(f6);
				debug(f7);

				/* ------------------------------------------------ /    
	   /  Stage 1:  Separate into even and odd halves.    /    
	   / ------------------------------------------------ */    
				g0 = f0 + f7;               h2 = f0 - f7; //step 12                 
				g1 = f1 + f6;               h3 = f1 - f6;                 
				h1 = f2 + f5;               g3 = f2 - f5;                 
				h0 = f3 + f4;               g2 = f3 - f4;             
				
				debug(g0);
				debug(g1);
				debug(h1);
				debug(h0);
				debug(h2);
				debug(h3);
				debug(g3);
				debug(g2);

				/* ------------------------------------------------ /    
	   /  Stage 2                                         /    
	   / ------------------------------------------------ */    
				p0 = g0 + h0;               r0 = g0 - h0;          //step 13 -- ok at� aqui...
				p1 = g1 + h1;               r1 = g1 - h1;                 
				q1 = g2;                    s1 = h2;                      
				s0a= h3 + g3;               q0a= h3 - g3;  
				
				debug(p0);
				debug(p1);
				debug(q1);
				debug(s0a);
				debug(r0);
				debug(r1);
				debug(s1);
				debug(q0a);
								
				s0 = (s0a * c0 + 0x7FFF) >> 16;					
				q0 = (q0a * c0 + 0x7FFF) >> 16;        
		
				debug(s0);
				debug(q0);

			/* ------------------------------------------------ /    
	   /  Stage 3                                         /    
	   / ------------------------------------------------ */    
				P0 = p0 + p1;             P1 = p0 - p1;                 //step 14
				R1 = c6 * r1 + c2 * r0;     R0 = c6 * r0 - c2 * r1;       

				Q1 = q1 + q0;               Q0 = q1 - q0;               
				S1 = s1 + s0;               S0 = s1 - s0;                 

				debug(P0);
				debug(R1);
				debug(Q1);
				debug(S1);
				debug(P1);
				debug(R0);
				debug(Q0);
				debug(S0);

	   /* ------------------------------------------------ /    
	   /  Stage 4                                         /    
	   / ------------------------------------------------ */    //step 15
				F0 = P0;                    F4 = P1;                      
				F2 = R1;                    F6 = R0;                      
	
				F1 = c7 * Q1 + c1 * S1;     F7 = c7 * S1 - c1 * Q1;   
				F5 = c3 * Q0 + c5 * S0;     F3 = c3 * S0 - c5 * Q0;       

			/* ------------------------------------------------ /    
	   /  Store the frequency domain results.             /    
	   / ------------------------------------------------ */    
				dct_io_tmp[ 0+i_1] = (short) F0;                             //j_step 16         
				dct_io_tmp[ 8+i_1] = (short) (F1 >> 13);
				dct_io_tmp[16+i_1] = (short) (F2 >> 13);
				dct_io_tmp[24+i_1] = (short) (F3 >> 13);
				dct_io_tmp[32+i_1] = (short) F4;
				dct_io_tmp[40+i_1] = (short) (F5 >> 13);
				dct_io_tmp[48+i_1] = (short) (F6 >> 13);
				dct_io_tmp[56+i_1] = (short) (F7 >> 13);
				
				debug(F0);
				debug((F1 >> 13));
				debug((F2 >> 13));
				debug((F3 >> 13));
				debug(F4);
				debug((F5 >> 13));
				debug((F6 >> 13));
				debug((F7 >> 13));
				System.out.println();
			//dct_io_ptr++;
				i_1++;
			}                                                             
			/* ---------------------------------------------------- /    
	 /  Update pointer to next 8x8 FDCT block.              /    
	 / ---------------------------------------------------- */    
			//dct_io_ptr += 56;
			i_1 += 56;
		}                                                               

		/* -------------------------------------------------------- /    
       /  Perform Horizontal 1-D FDCT on each 8x8 block.          /    
       / -------------------------------------------------------- */    
		//dct_io_ptr = dct_data;    
		i_1 = 0;
		for (int i = 0; i < N*num_fdcts; i++) {                                                                                         
			// ---------------------------------------------------- /    
			//  Load the spatial-domain samples.                    /    
			// ---------------------------------------------------- /  
			f0 = dct_io_tmp[0+i_1];                     // step2                      
			f1 = dct_io_tmp[1+i_1];                                           
			f2 = dct_io_tmp[2+i_1];                                           
			f3 = dct_io_tmp[3+i_1];                                           
			f4 = dct_io_tmp[4+i_1];                                           
			f5 = dct_io_tmp[5+i_1];                                           
			f6 = dct_io_tmp[6+i_1];                                           
			f7 = dct_io_tmp[7+i_1];                             // step9              

			debug(f0);
			debug(f1);
			debug(f2);
			debug(f3);
			debug(f4);
			debug(f5);
			debug(f6);
			debug(f7);
			
			// ---------------------------------------------------- /    
			//  Stage 1:  Separate into even and odd halves.        /    
			// ---------------------------------------------------- /    
			g0 = f0 + f7;               h2 = f0 - f7;                   //step10  
			g1 = f1 + f6;               h3 = f1 - f6;                     
			h1 = f2 + f5;               g3 = f2 - f5;                     
			h0 = f3 + f4;               g2 = f3 - f4;                     

			debug(g0);
			debug(g1);
			debug(g2);
			debug(g3);
			debug(h0);
			debug(h1);
			debug(h2);
			debug(h3);

			// ---------------------------------------------------- /    
			//  Stage 2                                             /    
			// ---------------------------------------------------- /    
			p0 = g0 + h0;               r0 = g0 - h0;                     //step11
			p1 = g1 + h1;               r1 = g1 - h1;                     
			q1 = g2;                    s1 = h2;                          

			s0a= h3 + g3;               q0a= h3 - g3;             
			
			debug(p0);
			debug(p1);
			debug(q1);
			debug(r0);
			debug(r1);
			debug(s1);
			debug(s0a);
			debug(q0a);
			
			q0 = (q0a * c0 + 0x7FFF) >> 16;                               
			s0 = (s0a * c0 + 0x7FFF) >> 16;                               
	
			debug(s0);
			debug(q0);

			// ---------------------------------------------------- /    
			//  Stage 3                                             /    
			// ---------------------------------------------------- /    
			P0 = p0 + p1;               P1 = p0 - p1;                     // step12
			R1 = c6 * r1 + c2 * r0;     R0 = c6 * r0 - c2 * r1;           
	
			Q1 = q1 + q0;               Q0 = q1 - q0;                     
			S1 = s1 + s0;               S0 = s1 - s0;                     
	
			debug(P0);
			debug(R1);
			debug(P1);
			debug(R0);
			debug(Q1);
			debug(S1);
			debug(Q0);
			debug(S0);
			
			// ---------------------------------------------------- /    
			//  Stage 4                                             /    
			// ---------------------------------------------------- /    // step13
			F0 = P0;                    F4 = P1;                          
			F2 = R1;                    F6 = R0;                          
	
			F1 = c7 * Q1 + c1 * S1;     F7 = c7 * S1 - c1 * Q1;           
			F5 = c3 * Q0 + c5 * S0;     F3 = c3 * S0 - c5 * Q0;         
			
			debug(F0);
			debug(F1);
			debug(F2);
			debug(F3);
			debug(F4);
			debug(F5);
			debug(F6);
			debug(F7);
	
			// ---------------------------------------------------- /    
			//  Round and truncate values.                          /    
			//                                                      /    
			//  Note: F0 and F4 have different rounding since no    /    
			//  MPYs have been applied to either term.  Also, F0's  /    
			//  rounding is slightly different to offset the        /    
			//  truncation effects from the horizontal pass (which  /    
			//  does not round).                                    /    
			// ---------------------------------------------------- /    
			F0r = (F0 + 0x0006) >>  3;                                    // step14
			F1r = (F1 + 0x7FFF) >> 16;                                    
			F2r = (F2 + 0x7FFF) >> 16;                                    
			F3r = (F3 + 0x7FFF) >> 16;                                    
			F4r = (F4 + 0x0004) >>  3;                                    
			F5r = (F5 + 0x7FFF) >> 16;                                    
			F6r = (F6 + 0x7FFF) >> 16;                                    
			F7r = (F7 + 0x7FFF) >> 16;                                    
	
			debug(F0r);
			debug(F1r);
			debug(F2r);
			debug(F3r);
			debug(F4r);
			debug(F5r);
			debug(F6r);
			debug(F7r);
	
			// ---------------------------------------------------- /    
			//  Store the results                                   /    
			// ---------------------------------------------------- /    
			dct_o[0+i_1] = (short) F0r;                                  //step15        
			dct_o[1+i_1] = (short) F1r;                                          
			dct_o[2+i_1] = (short) F2r;                                          
			dct_o[3+i_1] = (short) F3r;                                          
			dct_o[4+i_1] = (short) F4r;                                          
			dct_o[5+i_1] = (short) F5r;                                          
			dct_o[6+i_1] = (short) F6r;                                          
			dct_o[7+i_1] = (short) F7r;                                          

//			System.out.println("dct_o[" + (i_1+0) + "]=" + F0r);
//			System.out.println("dct_o[" + (i_1+1) + "]=" + F1r);
//			System.out.println("dct_o[" + (i_1+2) + "]=" + F2r);
//			System.out.println("dct_o[" + (i_1+3) + "]=" + F3r);
//			System.out.println("dct_o[" + (i_1+4) + "]=" + F4r);
//			System.out.println("dct_o[" + (i_1+5) + "]=" + F5r);
//			System.out.println("dct_o[" + (i_1+6) + "]=" + F6r);
//			System.out.println("dct_o[" + (i_1+7) + "]=" + F7r);
	
			// ---------------------------------------------------- /    
			//  Update pointer to next FDCT row.                    /    
			// ---------------------------------------------------- /    
			//dct_io_ptr += 8;
			i_1 += 8;
			System.out.println();
		}                                                                 
	}

//	static void loop1FDCT(short[] dct_io_ptr, short[] dct_io_tmp,
//			short num_fdcts) {
//
//		final int N = 8; // fixed
//
//		/* -------------------------------------------------------- /    
//       /  Set up the cosine coefficients c0..c7.                  /    
//       / -------------------------------------------------------- */    
//		int c1 = 0x2C62, c3 = 0x25A0;                    
//		int c5 = 0x1924, c7 = 0x08D4;                    
//		int c0 = 0xB505, c2 = 0x29CF;                    
//		int c6 = 0x1151;                                 
//
//		/* -------------------------------------------------------- /    
//       /  Intermediate calculations.                              /    
//       / -------------------------------------------------------- */    
//		int f0, f1, f2, f3,f4, f5, f6, f7;       // Spatial domain samples.       
//		int   g0, g1, h0, h1,p0, p1;               // Even-half intermediate.     
//		int r0, r1;               // Even-half intermediate.     
//		int   P0, P1, R0, R1;       // Even-half intermediate.         
//		int g2, g3, h2, h3;       // Odd-half intermediate.           
//		int q0a,s0a,q0, q1,s0, s1;               // Odd-half intermediate.          
//		int Q0, Q1, S0, S1;       // Odd-half intermediate.       
//		int   F0, F1, F2, F3, F4, F5, F6, F7;       // Freq. domain results. 
//
//		/* -------------------------------------------------------- /    
//       /  Outer vertical loop -- Process each 8x8 block.          /    
//       / -------------------------------------------------------- */    
//		//dct_io_ptr = dct_data;    
//		int i_1 = 0;
//		for (int i = 0; i < num_fdcts; i++) {                                                                 
//			/* ---------------------------------------------------- /    
//	 /  Perform Vert 1-D FDCT on columns within each block. /    
//	 / ---------------------------------------------------- */    
//			for (int j = 0; j < N; j++) {        
//				/* ------------------------------------------------ /
//       /  Load the spatial-domain samples.                /    
//       / ------------------------------------------------ */    
//				f0 = dct_io_ptr[   i_1];
//				f1 = dct_io_ptr[ 8+i_1];
//				f2 = dct_io_ptr[16+i_1];
//				f3 = dct_io_ptr[24+i_1];
//				f4 = dct_io_ptr[32+i_1];
//				f5 = dct_io_ptr[40+i_1];
//				f6 = dct_io_ptr[48+i_1];
//				f7 = dct_io_ptr[56+i_1];
//
//
//				//Timing.MAXTIME code = new Timing.MAXTIME();
//				//code.start();
//				// ------------------------------------------------ /
//				//  Stage 1:  Separate into even and odd halves.    /
//				// ------------------------------------------------ /
//				g0 = f0 + f7;               h2 = f0 - f7;                 
//				g1 = f1 + f6;               h3 = f1 - f6;                 
//				h1 = f2 + f5;               g3 = f2 - f5;                 
//				h0 = f3 + f4;               g2 = f3 - f4;                 
//				//code.end();
//				// ------------------------------------------------ /
//				//  Stage 2                                         /
//				// ------------------------------------------------ /
//				p0 = g0 + h0;               r0 = g0 - h0;
//				p1 = g1 + h1;               r1 = g1 - h1;
//				q1 = g2;                    s1 = h2;
//
//				s0a= h3 + g3;               q0a= h3 - g3;
//				s0 = (s0a * c0 + 0x7FFF) >> 16;
//			q0 = (q0a * c0 + 0x7FFF) >> 16;
//
//			// ------------------------------------------------ /
//			//  Stage 3                                         /
//			// ------------------------------------------------ /
//			P0 = p0 + p1;             P1 = p0 - p1;
//			R1 = c6 * r1 + c2 * r0;     R0 = c6 * r0 - c2 * r1;
//
//			Q1 = q1 + q0;               Q0 = q1 - q0;
//			S1 = s1 + s0;               S0 = s1 - s0;
//
//			// ------------------------------------------------ /
//			//  Stage 4                                         /
//			// ------------------------------------------------ /
//			F0 = P0;                    F4 = P1;
//			F2 = R1;                    F6 = R0;
//
//			F1 = c7 * Q1 + c1 * S1;     F7 = c7 * S1 - c1 * Q1;
//			F5 = c3 * Q0 + c5 * S0;     F3 = c3 * S0 - c5 * Q0;
//
//			// ------------------------------------------------ /
//			//  Store the frequency domain results.             /
//			// ------------------------------------------------ /
//
//
//
//
//			dct_io_tmp[ 0+i_1] = (short) F0;
//
//			dct_io_tmp[ 8+i_1] = (short) (F1 >> 13);
//			dct_io_tmp[16+i_1] = (short) (F2 >> 13);
//			dct_io_tmp[24+i_1] = (short) (F3 >> 13);
//			dct_io_tmp[32+i_1] = (short) F4;
//			dct_io_tmp[40+i_1] = (short) (F5 >> 13);
//			dct_io_tmp[48+i_1] = (short) (F6 >> 13);                                
//			dct_io_tmp[56+i_1] = (short) (F7 >> 13);                                
//
//			i_1++;
//			}
//			i_1 += 56;
//		}
//	}
//
//	public static void Loop2FDCT(short[] dct_io_tmp, short[] dct_o, 
//			short num_fdcts) {
//
//		final int N = 8; // fixed
//
//		//void fdct_8x8(short dct_data, unsigned num_fdcts)  
//
//		/* -------------------------------------------------------- /    
//       /  Set up the cosine coefficients c0..c7.                  /    
//       / -------------------------------------------------------- */    
//		int c1 = 0x2C62, c3 = 0x25A0;                    
//		int c5 = 0x1924, c7 = 0x08D4;                    
//		int c0 = 0xB505, c2 = 0x29CF;                    
//		int c6 = 0x1151;                                 
//
//		/* -------------------------------------------------------- /    
//       /  Intermediate calculations.                              /    
//       / -------------------------------------------------------- */    
//		int f0, f1, f2, f3,f4, f5, f6, f7;       // Spatial domain samples.       
//		int   g0, g1, h0, h1,p0, p1;               // Even-half intermediate.     
//		int r0, r1;               // Even-half intermediate.     
//		int   P0, P1, R0, R1;       // Even-half intermediate.         
//		int g2, g3, h2, h3;       // Odd-half intermediate.           
//		int q0a,s0a,q0, q1,s0, s1;               // Odd-half intermediate.          
//		int Q0, Q1, S0, S1;       // Odd-half intermediate.       
//		int   F0, F1, F2, F3, F4, F5, F6, F7;       // Freq. domain results. 
//		int   F0r,F1r,F2r,F3r,F4r,F5r,F6r,F7r;      // Rounded, truncated results.   
//
//		/* -------------------------------------------------------- /    
//       /  Perform Horizontal 1-D FDCT on each 8x8 block.          /    
//       / -------------------------------------------------------- */    
//		//dct_io_ptr = dct_data;    
//		int i_1 = 0;
//		for (int i = 0; i < N*num_fdcts; i++) {
//
//			// ---------------------------------------------------- /    
//			//  Load the spatial-domain samples.                    /    
//			// ---------------------------------------------------- /  
//			f0 = dct_io_tmp[i_1];
//			f1 = dct_io_tmp[1+i_1];
//
//			f2 = dct_io_tmp[2+i_1];                                           
//			f3 = dct_io_tmp[3+i_1];
//			f4 = dct_io_tmp[4+i_1];
//			f5 = dct_io_tmp[5+i_1];
//			f6 = dct_io_tmp[6+i_1];
//			f7 = dct_io_tmp[7+i_1];
//
//			// ---------------------------------------------------- /
//			//  Stage 1:  Separate into even and odd halves.        /
//			// ---------------------------------------------------- /
//			g0 = f0 + f7;               h2 = f0 - f7;
//			g1 = f1 + f6;               h3 = f1 - f6;
//			h1 = f2 + f5;               g3 = f2 - f5;
//			h0 = f3 + f4;               g2 = f3 - f4;
//
//			// ---------------------------------------------------- /
//			//  Stage 2                                             /
//			// ---------------------------------------------------- /
//			p0 = g0 + h0;               r0 = g0 - h0;
//			p1 = g1 + h1;               r1 = g1 - h1;                     
//			q1 = g2;                    s1 = h2;                          
//
//			s0a= h3 + g3;               q0a= h3 - g3;                     
//			q0 = (q0a * c0 + 0x7FFF) >> 16;
//			s0 = (s0a * c0 + 0x7FFF) >> 16;                               
//	
//			// ---------------------------------------------------- /    
//			//  Stage 3                                             /    
//			// ---------------------------------------------------- /    
//			P0 = p0 + p1;               P1 = p0 - p1;                     
//			R1 = c6 * r1 + c2 * r0;     R0 = c6 * r0 - c2 * r1;
//	
//			Q1 = q1 + q0;               Q0 = q1 - q0;                     
//			S1 = s1 + s0;               S0 = s1 - s0;                     
//	
//			// ---------------------------------------------------- /    
//			//  Stage 4                                             /    
//			// ---------------------------------------------------- /    
//			F0 = P0;                    F4 = P1;                          
//			F2 = R1;                    F6 = R0;                          
//	
//			F1 = c7 * Q1 + c1 * S1;     F7 = c7 * S1 - c1 * Q1;           
//			F5 = c3 * Q0 + c5 * S0;     F3 = c3 * S0 - c5 * Q0;           
//
//			// ---------------------------------------------------- /    
//			//  Round and truncate values.                          /    
//			//                                                      /    
//			//  Note: F0 and F4 have different rounding since no    /    
//			//  MPYs have been applied to either term.  Also, F0's  /
//			//  rounding is slightly different to offset the        /    
//			//  truncation effects from the horizontal pass (which  /    
//			//  does not round).                                    /    
//			// ---------------------------------------------------- /    
//			F0r = (F0 + 0x0006) >>  3;                                    
//			F1r = (F1 + 0x7FFF) >> 16;                                    
//			F2r = (F2 + 0x7FFF) >> 16;
//			F3r = (F3 + 0x7FFF) >> 16;
//			F4r = (F4 + 0x0004) >>  3;                                    
//			F5r = (F5 + 0x7FFF) >> 16;                                    
//			F6r = (F6 + 0x7FFF) >> 16;                                    
//			F7r = (F7 + 0x7FFF) >> 16;                                    
//	
//			// ---------------------------------------------------- /    
//			//  Store the results                                   /    
//			// ---------------------------------------------------- /    
//			dct_o[i_1] = (short) F0r;
//			dct_o[1+i_1] = (short) F1r;
//			dct_o[2+i_1] = (short) F2r;
//			dct_o[3+i_1] = (short) F3r;
//			dct_o[4+i_1] = (short) F4r;                                          
//			dct_o[5+i_1] = (short) F5r;                                          
//			dct_o[6+i_1] = (short) F6r;                                          
//			dct_o[7+i_1] = (short) F7r;
//	
//			// ---------------------------------------------------- /
//			//  Update pointer to next FDCT row.                    /    
//			// ---------------------------------------------------- /    
//			//dct_io_ptr += 8;
//			/*dct_o[i_1] = (short) f0;
//		      dct_o[1+i_1] = (short) f1;
//		      dct_o[2+i_1] = (short) f2;
//		      dct_o[3+i_1] = (short) f3;
//		      dct_o[4+i_1] = (short) f4;
//		      dct_o[5+i_1] = (short) f5;
//		      dct_o[6+i_1] = (short) f6;
//		      dct_o[7+i_1] = (short) f7;
//				 */
//		
//			i_1 += 8;
//		}
//
//	}
//
//	static void loop1Body(int f0, int f1, int f2, int f3, int f4, int f5, int f6, int f7, int F0r,int F1r,int F2r,int F3r,int F4r,int F5r,int F6r,int F7r) {
//
//		/* -------------------------------------------------------- /    
//       /  Set up the cosine coefficients c0..c7.                  /    
//       / -------------------------------------------------------- */    
//		int c1 = 0x2C62, c3 = 0x25A0;                    
//		int c5 = 0x1924, c7 = 0x08D4;                    
//		int c0 = 0xB505, c2 = 0x29CF;                    
//		int c6 = 0x1151;                                 
//
//		/* -------------------------------------------------------- /    
//       /  Intermediate calculations.                              /    
//       / -------------------------------------------------------- */         
//		int   g0, g1, h0, h1,p0, p1;               // Even-half intermediate.     
//		int r0, r1;               // Even-half intermediate.     
//		int   P0, P1, R0, R1;       // Even-half intermediate.         
//		int g2, g3, h2, h3;       // Odd-half intermediate.           
//		int q0a,s0a,q0, q1,s0, s1;               // Odd-half intermediate.          
//		int Q0, Q1, S0, S1;       // Odd-half intermediate.       
//		int   F0, F1, F2, F3, F4, F5, F6, F7;       // Freq. domain results.   
//
//		//Timing.MAXTIME code = new Timing.MAXTIME();
//		//code.start();
//		/* ------------------------------------------------ /    
//       /  Stage 1:  Separate into even and odd halves.    /    
//       / ------------------------------------------------ */    
//		g0 = f0 + f7;               h2 = f0 - f7;                 
//		g1 = f1 + f6;               h3 = f1 - f6;                 
//		h1 = f2 + f5;               g3 = f2 - f5;                 
//		h0 = f3 + f4;               g2 = f3 - f4;                 
//		//code.end();
//		/* ------------------------------------------------ /    
//       /  Stage 2                                         /    
//       / ------------------------------------------------ */    
//		p0 = g0 + h0;               r0 = g0 - h0;                 
//		p1 = g1 + h1;               r1 = g1 - h1;                 
//		q1 = g2;                    s1 = h2;                      
//
//		s0a= h3 + g3;               q0a= h3 - g3;                   
//		s0 = (s0a * c0 + 0x7FFF) >> 16;                           
//		q0 = (q0a * c0 + 0x7FFF) >> 16;                           
//
//		/* ------------------------------------------------ /    
//       /  Stage 3                                         /    
//       / ------------------------------------------------ */    
//		P0 = p0 + p1;             P1 = p0 - p1;                 
//		R1 = c6 * r1 + c2 * r0;     R0 = c6 * r0 - c2 * r1;       
//
//		Q1 = q1 + q0;               Q0 = q1 - q0;                 
//		S1 = s1 + s0;               S0 = s1 - s0;                 
//
//		/* ------------------------------------------------ /    
//       /  Stage 4                                         /    
//       / ------------------------------------------------ */    
//		F0 = P0;                    F4 = P1;                      
//		F2 = R1;                    F6 = R0;                      
//
//		F1 = c7 * Q1 + c1 * S1;     F7 = c7 * S1 - c1 * Q1;       
//		F5 = c3 * Q0 + c5 * S0;     F3 = c3 * S0 - c5 * Q0;       
//
//		/* ------------------------------------------------ /    
//       /  Store the frequency domain results.             /    
//       / ------------------------------------------------ */    
//		F0r = (short) F0;                                      
//		F1r = (short) (F1 >> 13);                                
//		F2r = (short) (F2 >> 13);                                
//		F3r = (short) (F3 >> 13);                                
//		F4r = (short) F4;                                      
//		F5r = (short) (F5 >> 13);                                
//		F6r = (short) (F6 >> 13);                                
//		F7r = (short) (F7 >> 13);   
//	}
//
//	static void loop2Body(int f0, int f1, int f2, int f3, int f4, int f5, int f6, int f7, int F0r,int F1r,int F2r,int F3r,int F4r,int F5r,int F6r,int F7r) {
//
//		/* -------------------------------------------------------- /    
//       /  Set up the cosine coefficients c0..c7.                  /    
//       / -------------------------------------------------------- */    
//		int c1 = 0x2C62, c3 = 0x25A0;                    
//		int c5 = 0x1924, c7 = 0x08D4;                    
//		int c0 = 0xB505, c2 = 0x29CF;                    
//		int c6 = 0x1151;                                 
//
//		/* -------------------------------------------------------- /    
//       /  Intermediate calculations.                              /    
//       / -------------------------------------------------------- */         
//		int   g0, g1, h0, h1,p0, p1;               // Even-half intermediate.     
//		int r0, r1;               // Even-half intermediate.     
//		int   P0, P1, R0, R1;       // Even-half intermediate.         
//		int g2, g3, h2, h3;       // Odd-half intermediate.           
//		int q0a,s0a,q0, q1,s0, s1;               // Odd-half intermediate.          
//		int Q0, Q1, S0, S1;       // Odd-half intermediate.       
//		int   F0, F1, F2, F3, F4, F5, F6, F7;       // Freq. domain results. 
//
//		// ---------------------------------------------------- /    
//		//  Stage 1:  Separate into even and odd halves.        /    
//		// ---------------------------------------------------- /    
//		g0 = f0 + f7;               h2 = f0 - f7;                     
//		g1 = f1 + f6;               h3 = f1 - f6;                     
//		h1 = f2 + f5;               g3 = f2 - f5;                     
//		h0 = f3 + f4;               g2 = f3 - f4;                     
//
//		// ---------------------------------------------------- /    
//		//  Stage 2                                             /    
//		// ---------------------------------------------------- /    
//		p0 = g0 + h0;               r0 = g0 - h0;                     
//		p1 = g1 + h1;               r1 = g1 - h1;                     
//		q1 = g2;                    s1 = h2;                          
//
//		s0a= h3 + g3;               q0a= h3 - g3;                     
//		q0 = (q0a * c0 + 0x7FFF) >> 16;                               
//		s0 = (s0a * c0 + 0x7FFF) >> 16;                               
//
//		// ---------------------------------------------------- /    
//		//  Stage 3                                             /    
//		// ---------------------------------------------------- /    
//		P0 = p0 + p1;               P1 = p0 - p1;                     
//		R1 = c6 * r1 + c2 * r0;     R0 = c6 * r0 - c2 * r1;           
//
//		Q1 = q1 + q0;               Q0 = q1 - q0;                     
//		S1 = s1 + s0;               S0 = s1 - s0;                     
//
//		// ---------------------------------------------------- /    
//		//  Stage 4                                             /    
//		// ---------------------------------------------------- /    
//		F0 = P0;                    F4 = P1;                          
//		F2 = R1;                    F6 = R0;                          
//
//		F1 = c7 * Q1 + c1 * S1;     F7 = c7 * S1 - c1 * Q1;           
//		F5 = c3 * Q0 + c5 * S0;     F3 = c3 * S0 - c5 * Q0;           
//
//		// ---------------------------------------------------- /    
//		//  Round and truncate values.                          /    
//		//                                                      /    
//		//  Note: F0 and F4 have different rounding since no    /    
//		//  MPYs have been applied to either term.  Also, F0's  /    
//		//  rounding is slightly different to offset the        /    
//		//  truncation effects from the horizontal pass (which  /    
//		//  does not round).                                    /    
//		// ---------------------------------------------------- /    
//		F0r = (F0 + 0x0006) >>  3;                                    
//		F1r = (F1 + 0x7FFF) >> 16;                                    
//		F2r = (F2 + 0x7FFF) >> 16;                                    
//		F3r = (F3 + 0x7FFF) >> 16;                                    
//		F4r = (F4 + 0x0004) >>  3;                                    
//		F5r = (F5 + 0x7FFF) >> 16;                                    
//		F6r = (F6 + 0x7FFF) >> 16;                                    
//		F7r = (F7 + 0x7FFF) >> 16;   
//
//		F0r = (short) F0r;
//		F1r = (short) F1r;
//		F2r = (short) F2r;
//		F3r = (short) F3r;
//		F4r = (short) F4r;
//		F5r = (short) F5r;
//		F6r = (short) F6r;
//		F7r = (short) F7r;                             
//	}
	static void debug(Object o) {
		System.out.print(o + "\t");
	}
}
