int main() {
  int a[3] = {1,2,3};
  int b[3] = {1,2,3};
  int i;
  int sum = 0;
  int x = 0;
  #pragma unroll 3
  for (i=0; i<3; i++){
    x = i;
    sum += a[x] * b[x];
  }
  return sum;
}
