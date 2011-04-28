#define N 32 

int ar[N];

main() {
    int i,j;
    int temp;
    for (i=0;i<N;i++) {
        for (j=0;j<N-1;j++) {
            if (ar[j] > ar[j+1]) {
                temp = ar[j+1];
                ar[j+1] = ar[j];
                ar[j] = temp;
            }
        }
    }
}