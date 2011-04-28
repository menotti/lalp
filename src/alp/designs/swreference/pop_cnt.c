#define N 1024 

int A[N], B[N];

main() { 
    int i, j, sum, input;
    for (i=0; i<N; i++) {
        input = A[i];
        sum = 0;
        for (j = 0; j < 32; j++) {
            sum += (input) & 1; 
            input = input/2; 
        } 
        B[i] = sum;
    } 
} 