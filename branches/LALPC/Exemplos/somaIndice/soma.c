void main() {
    int i;
    int a[3] = {1,1,1};
    int res = 0;
    #pragma unroll 3
    for(i=0; i<3; i++){
       res = 1 + a[i];
    }
}
