#define SIZE 5 

void matmult(int N, int a[][SIZE], int b[][SIZE], int s[][SIZE]) {
  int i, j, k;
  for(i=0; i<N; i++)
    for(j=0; j<N; j++) {
      s[i][j] = 0;
      for(k=0; k<N; k++) 
        s[i][j] = s[i][j] + a[i][k]*b[k][j]; 
    }
  return;
}

int main() {
  int a[SIZE][SIZE] = {{ 1, 2, 3, 4, 6},
			{6, 1, 5, 3, 8},
			{2, 6, 4, 9, 9},
			{1, 3, 8, 3, 4},
			{5, 7, 8, 2, 5}};
  int b[SIZE][SIZE] = {{ 3, 5, 0, 8, 7},
			{2, 2, 4, 8, 3},
			{0, 2, 5, 1, 2},
			{1, 4, 0, 5, 1},
			{3, 4, 8, 2, 3}};
  int s[SIZE][SIZE]; 

  matmult(SIZE, a, b, s);	
	
	/* result 
	29   55   71   59   41
	47   86   93   92   82
	54  102  116  131   76
	24   55   84   63   47
	46   83  108  124   89
	*/
}

