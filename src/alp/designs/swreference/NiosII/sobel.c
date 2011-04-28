#include "sobel.h"

int sobel() {
	char in[N]; 
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
	        if (O > 255) O = 255;
	        out[i + 1] = (char)O;
	}
	return O;
}
