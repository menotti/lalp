#include "adpcm_decoder.h"

int adpcm_decoder() {
  int i;
  int len;
  int sign;
  int delta;
  int step;
  int valpred = 0;
  int vpdiff;
  int index = 0;
  int bufferstep;
  int inputbuffer = 0;
  step = stepsizeTable[index];
  bufferstep = 0;
  i=0;
  for (len = 0 ; len < DATASIZE ; len++ ) {
    if ( bufferstep ) {
      delta = inputbuffer & 0xf;
    } 
    else {
      inputbuffer = indata[i];
      i++;
      delta = (inputbuffer >> 4) & 0xf;
    }
    bufferstep = !bufferstep;
    index += indexTable[delta];
    if ( index < 0 ) 
    	index = 0;
    if ( index > 88 ) 
    	index = 88;
    sign = delta & 8;
    delta = delta & 7;
    vpdiff = step >> 3;
    if ( delta & 4 ) 
    	vpdiff += step;
    else 
    	if ( delta & 2 ) 
    		vpdiff += step>>1;
    	else 
    		if ( delta & 1 ) 
    			vpdiff += step>>2;
    if ( sign )
      valpred -= vpdiff;
    else
      valpred += vpdiff;
    if ( valpred > 32767 )
      valpred = 32767;
    else if ( valpred < -32768 )
      valpred = -32768;
    step = stepsizeTable[index];
    outdata[len] = valpred;
  }
  return valpred;
}
