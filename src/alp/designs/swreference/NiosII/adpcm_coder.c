#include "adpcm_coder.h"

int adpcm_coder() {
  int i;
  int len;
  int sign;		
  int delta;		
  int step;		
  int valpred = 0;	
  int vpdiff;		
  int index = 0;			
  int bufferstep;		
  int outputbuffer = 0;	
  int diff;		
  int val;			
  step = stepsizeTable[index];
  bufferstep = 1;
  i=0;
  for (len = 0 ; len < DATASIZE ; len++ ) {
    val = indata[len]; 
    diff = val - valpred;
    sign = (diff < 0) ? 8 : 0;
    if ( sign ) 
        diff = (-diff);
    delta = 0;
    vpdiff = (step >> 3);
    if ( diff >= step ) {
      delta = 4;
      diff -= step;
      vpdiff += step;
    }
    step >>= 1;
    if ( diff >= step  ) {
      delta |= 2;
      diff -= step;
      vpdiff += step;
    }
    step >>= 1;
    if ( diff >= step ) {
      delta |= 1;
      vpdiff += step;
    }
    if ( sign )
      valpred -= vpdiff;
    else
      valpred += vpdiff;
    if ( valpred > 32767 )
      valpred = 32767;
    else if ( valpred < -32768 )
      valpred = -32768;
    delta |= sign;
    index += indexTable[delta];
    if ( index < 0 ) 
        index = 0;
    if ( index > 88 ) 
        index = 88;
    step = stepsizeTable[index];
    if ( bufferstep ) {
      outputbuffer = (delta << 4) & 0xf0;
    } else {
      outdata[i] = (delta & 0x0f) | outputbuffer; 
    }
    bufferstep = !bufferstep;
  }
  if ( !bufferstep )
    outdata[i] = outputbuffer;
  return outputbuffer;
}
