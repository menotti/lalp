/* ======================================================================== */
/*  TEXAS INSTRUMENTS, INC.                                                 */
/*                                                                          */
/*  DSPLIB  DSP Signal Processing Library                                   */
/*                                                                          */
/*  This library contains proprietary intellectual property of Texas        */
/*  Instruments, Inc.  The library and its source code are protected by     */
/*  various copyrights, and portions may also be protected by patents or    */
/*  other legal protections.                                                */
/*                                                                          */
/*  This software is licensed for use with Texas Instruments TMS320         */
/*  family DSPs.  This license was provided to you prior to installing      */
/*  the software.  You may review this license by consulting the file       */
/*  TI_license.PDF which accompanies the files in this library.             */
/* ------------------------------------------------------------------------ */
/*          Copyright (C) 2003 Texas Instruments, Incorporated.             */
/*                          All Rights Reserved.                            */
/* ======================================================================== */


/* ======================================================================== */
/*  TEXAS INSTRUMENTS, INC.                                                 */
/*                                                                          */
/*  NAME                                                                    */
/*      DSP_w_vec: Weighted vector sum                                      */
/*                                                                          */
/*                                                                          */
/*  REVISION DATE                                                           */
/*      29-Mar-2002                                                         */
/*                                                                          */
/*  USAGE                                                                   */
/*      This routine is C-callable and can be called as:                    */
/*                                                                          */
/*          void DSP_w_vec                                                  */
/*          (                                                               */
/*              const short *x,     // Vector being weighted  //            */
/*              const short *y,     // Non-weighted vector    //            */
/*              short m,            // weighting factor       //            */
/*              short *restrict r,  // Result vector          //            */
/*              int nr              // Number of samples.     //            */
/*          );                                                              */
/*                                                                          */
/*  DESCRIPTION                                                             */
/*      The benchmark performs a weighted vector sum.  The elements         */
/*      of the x[] vector are weighted according to the Q15 value 'm',      */
/*      and then added to the corresponding elements of the y[] vector.     */
/*      The results are written to the r[] vector.                          */
/*                                                                          */
/*  ASSUMPTIONS                                                             */
/*      m is not -32768.                                                    */
/*  SOURCE                                                                  */
/*      DSPLIB.                                                             */
/* ------------------------------------------------------------------------ */
/*            Copyright (c) 2003 Texas Instruments, Incorporated.           */
/*                           All Rights Reserved.                           */
/* ======================================================================== */

void DSP_w_vec_c
(
    const short * x,
    const short * y,
    short m,
    short *restrict r,
    int nr
)
{
    int i;

    for (i = 0; i < nr; i++)
        r[i] = ((m * x[i]) >> 15) + y[i];
}

/* ======================================================================== */
/*  End of file:  dsp_w_vec.c                                               */
/* ------------------------------------------------------------------------ */
/*            Copyright (c) 2003 Texas Instruments, Incorporated.           */
/*                           All Rights Reserved.                           */
/* ======================================================================== */
