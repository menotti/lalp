#define DATASIZE 1024
short indata[(DATASIZE/2)+1];
char outdata[DATASIZE];
static int indexTable[16] = {
    -1, -1, -1, -1, 2, 4, 6, 8,
    -1, -1, -1, -1, 2, 4, 6, 8,
};
static int stepsizeTable[89] = {
    7, 8, 9, 10, 11, 12, 13, 14, 16, 17,
    19, 21, 23, 25, 28, 31, 34, 37, 41, 45,
    50, 55, 60, 66, 73, 80, 88, 97, 107, 118,
    130, 143, 157, 173, 190, 209, 230, 253, 279, 307,
    337, 371, 408, 449, 494, 544, 598, 658, 724, 796,
    876, 963, 1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066,
    2272, 2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358,
    5894, 6484, 7132, 7845, 8630, 9493, 10442, 11487, 12635, 13899,
    15289, 16818, 18500, 20350, 22385, 24623, 27086, 29794, 32767
};
main() {
  int i;
  int len;
  int sign;
  int delta;
  int step;
  int valpred;
  int vpdiff;
  int index;
  int bufferstep;
  int inputbuffer;
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
}
