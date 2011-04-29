#include <stdio.h>

#define cols 10
#define rows 10
#define N cols*rows

int main() {
  char in[N] = {
    50, 65, 62, 83, 34, 45, 96, 67, 18, 29, 
    14, 14, 72, 13, 14, 15, 16, 17, 18, 39, 
    20, 23, 82, 23, 20, 25, 26, 27, 28, 29, 
    54, 12, 72, 83, 34, 45, 96, 97, 18, 29, 
    40, 41, 42, 73, 44, 45, 46, 47, 48, 89, 
    52, 60, 82, 83, 34, 45, 96, 37, 18, 29, 
    60, 69, 62, 66, 64, 65, 64, 67, 68, 69, 
    53, 68, 72, 83, 34, 55, 96, 37, 18, 29, 
    84, 87, 82, 83, 84, 85, 86, 87, 28, 89, 
    95, 96, 92, 93, 94, 95, 96, 97, 38, 99
  };
  char out[N]; 
  int H, O, V, i;
  int i00, i01, i02;
  int i10,      i12;
  int i20, i21, i22;
  
  for (i = 0; i < cols*(rows-2)-2; i++) {

    i00=in[i       ]; i01=in[i       +1]; i02=in[i       +2];
    i10=in[i+  cols];                     i12=in[i+  cols+2];
    i20=in[i+2*cols]; i21=in[i+2*cols+1]; i22=in[i+2*cols+2];

    H = -   i00 - 2*i01 -   i02 +
        +   i20 + 2*i21 +   i22;
    V = -   i00         +   i02
        - 2*i10         + 2*i12
        -   i20         +   i22;
    if (H<0)
       H = -H;
    if (V<0)
       V = -V;
    O = H + V;
    if (O > 255) 
      O = 255;
    out[i + 1] = (char)O;
    printf("%d\n", O);
  }
  return 0;
}
