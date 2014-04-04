

int main() {
  int indata[1024] = {7, 17, 27, 37, 47, 57, 67, 77, 87, 97, 107, 117, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 3, 13, 23, 33, 43, 53, 63, 73, 83, 93, 103, 113, 123, 6, 16, 26, 36, 46, 56, 66, 76, 86, 96, 106, 116, 126, 9, 19, 29, 39, 49, 59, 69, 79, 89, 99, 109, 119, 2, 12, 22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 8, 18, 28, 38, 48, 58, 68, 78, 88, 98, 108, 118, 1, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 4, 14, 24, 34, 44, 54, 64, 74, 84, 94, 104, 114, 124, 7, 17, 27, 37, 47, 57, 67, 77, 87, 97, 107, 117, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 3, 13, 23, 33, 43, 53, 63, 73, 83, 93, 103, 113, 123, 6, 16, 26, 36, 46, 56, 66, 76, 86, 96, 106, 116, 126, 9, 19, 29, 39, 49, 59, 69, 79, 89, 99, 109, 119, 2, 12, 22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 8, 18, 28, 38, 48, 58, 68, 78, 88, 98, 108, 118, 1, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 4, 14, 24, 34, 44, 54, 64, 74, 84, 94, 104, 114, 124, 7, 17, 27, 37, 47, 57, 67, 77, 87, 97, 107, 117, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 3, 13, 23, 33, 43, 53, 63, 73, 83, 93, 103, 113, 123, 6, 16, 26, 36, 46, 56, 66, 76, 86, 96, 106, 116, 126, 9, 19, 29, 39, 49, 59, 69, 79, 89, 99, 109, 119, 2, 12, 22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 8, 18, 28, 38, 48, 58, 68, 78, 88, 98, 108, 118, 1, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 4, 14, 24, 34, 44, 54, 64, 74, 84, 94, 104, 114, 124, 7, 17, 27, 37, 47, 57, 67, 77, 87, 97, 107, 117, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 3, 13, 23, 33, 43, 53, 63, 73, 83, 93, 103, 113, 123, 6, 16, 26, 36, 46, 56, 66, 76, 86, 96, 106, 116, 126, 9, 19, 29, 39, 49, 59, 69, 79, 89, 99, 109, 119, 2, 12, 22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 8, 18, 28, 38, 48, 58, 68, 78, 88, 98, 108, 118, 1, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 4, 14, 24, 34, 44, 54, 64, 74, 84, 94, 104, 114, 124, 7, 17, 27, 37, 47, 57, 67, 77, 87, 97, 107, 117, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 3, 13, 23, 33, 43, 53, 63, 73, 83, 93, 103, 113, 123, 6, 16, 26, 36, 46, 56, 66, 76, 86, 96, 106, 116, 126, 9, 19, 29, 39, 49, 59, 69, 79, 89, 99, 109, 119, 2, 12, 22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 8, 18, 28, 38, 48, 58, 68, 78, 88, 98, 108, 118, 1, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 4, 14, 24, 34, 44, 54, 64, 74, 84, 94, 104, 114, 124, 7, 17, 27, 37, 47, 57, 67, 77, 87, 97, 107, 117, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 3, 13, 23, 33, 43, 53, 63, 73, 83, 93, 103, 113, 123, 6, 16, 26, 36, 46, 56, 66, 76, 86, 96, 106, 116, 126, 9, 19, 29, 39, 49, 59, 69, 79, 89, 99, 109, 119, 2, 12, 22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 8, 18, 28, 38, 48, 58, 68, 78, 88, 98, 108, 118, 1, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 4, 14, 24, 34, 44, 54, 64, 74, 84, 94, 104, 114, 124, 7, 17, 27, 37, 47, 57, 67, 77, 87, 97, 107, 117, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 3, 13, 23, 33, 43, 53, 63, 73, 83, 93, 103, 113, 123, 6, 16, 26, 36, 46, 56, 66, 76, 86, 96, 106, 116, 126, 9, 19, 29, 39, 49, 59, 69, 79, 89, 99, 109, 119, 2, 12, 22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 8, 18, 28, 38, 48, 58, 68, 78, 88, 98, 108, 118, 1, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 4, 14, 24, 34, 44, 54, 64, 74, 84, 94, 104, 114, 124, 7, 17, 27, 37, 47, 57, 67, 77, 87, 97, 107, 117, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 3, 13, 23, 33, 43, 53, 63, 73, 83, 93, 103, 113, 123, 6, 16, 26, 36, 46, 56, 66, 76, 86, 96, 106, 116, 126, 9, 19, 29, 39, 49, 59, 69, 79, 89, 99, 109, 119, 2, 12, 22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 8, 18, 28, 38, 48, 58, 68, 78, 88, 98, 108, 118, 1, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 4, 14, 24, 34, 44, 54, 64, 74, 84, 94, 104, 114, 124, 7, 17, 27, 37, 47, 57, 67, 77}; //1024 values
  int outdata[512];

  int indexTable[16] = {
    -1, -1, -1, -1, 2, 4, 6, 8,
    -1, -1, -1, -1, 2, 4, 6, 8,
  };

  int stepsizeTable[89] = {
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

  int i;
  int len;
  int sign;             
  int delta = 0;    
  int step = 0;             
  int valpred = 0;     
  int vpdiff;           
  int index = 0;
  #pragma bit bufferstep                       
  int bufferstep = 1;               
  int outputbuffer = 0; 
  int diff;             
  int val;                      
    

  for (len = 0 ; len < 1024 ; len++ ) {
    val = indata[len];
    diff = val - valpred;
    if (diff < 0){
	sign = 8;
    }else{ 
        sign = 0; 
    }
    delta = delta | sign;    
    step = stepsizeTable[index];
    if ( sign != 0 ){
        diff = (-diff);
    }
    vpdiff = (step >> 3);
    if ( diff >= step ) {
      delta = 4;
      diff = diff - step;
      vpdiff = vpdiff + step;
    }
    step = step >> 1;
    if ( diff >= step  ) {
      delta = delta | 2;
      diff = diff - step;
      vpdiff = vpdiff + step;
    }    
    step = step >> 1;
    if ( diff >= step ) {
      delta = delta | 1;
      vpdiff = vpdiff + step;
    }
    if ( sign != 0  ){
      valpred =  valpred - vpdiff;
    }else {
      valpred = valpred + vpdiff;
    }
    if ( valpred > 32767 ){
      valpred = 32767;
    }
    if ( valpred < -32768 ){
      valpred = -32768;
    }
    index = index + indexTable[delta];

    if ( index < 0 ) {
        index = 0;
    }
    if ( index > 88 ) {
        index = 88;
    }
    if (!bufferstep) {
      	outdata[i] = (delta & 0x0f) | outputbuffer;
      	i = i + 1;
    } else {
      	outputbuffer = (delta << 4) & 0xf0;
    }
    bufferstep = !bufferstep;
    
  }
  return outdata;
}
