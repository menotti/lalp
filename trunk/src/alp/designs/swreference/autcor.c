/*===============================================================================
*
*       TEXAS INSTRUMENTS, INC.         
*
*       AUTOCORRELATION
*
*       Revision Date:  04/16/97
*/

/* DSP performance:
   (N/2) *M + 16 + M/4
   For N=160 and M=10;
   816 cycles or 4.08 µsec
*/


#define N 160   //--- Length of Input array vector (sd[]) -
#define M 10 //(MULTIPLE of 2)

short ac[M]; // --- Resulting array of autocorrelation

short sd[N]; // --- Input array of autocorrelation


main() {
  int tmp;
  //void autcor(short ac[],short sd[], int N, int M) {
  int i,k,sum;

  for (i = 0; i < M; i++){
    sum = 0;

    for (k = 0; k < N; k++) {
      sum += sd[k+M] * sd[k+M-i];
    }

    ac[i] = (sum >> 15);
  }
}


