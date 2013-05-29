#define DATASIZE 1024

short indata[DATASIZE];
char outdata[(DATASIZE/2)+1];

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

int main() {
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
