#define N 2048

int A[N];
int B[N];
int C[N];

main() {
	int i0;

	for(i0 = 0; i0 < N; ++i0) {
		C[i0] = A[i0] + B[i0];	
	}
}
