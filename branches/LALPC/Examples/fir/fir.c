int main() {
  int a[4] = {1, 2, 3, 4};
  int b[4] = {1, 2, 3, 4};
  int c[4] = {1, 2, 3, 4};
  int d[4] = {1, 2, 3, 4};
  int e[4] = {1, 2, 3, 4};
  int sum[4];
  int i = 0;
  #pragma out sum
  //#pragma unroll 2
  //#pragma multport
  for(i = 0; i < 4; i++){
	sum[i] = (((a[i] * 3)+(b[i] * 5))+(c[i] * 7))+((d[i] * 9)+(e[i] * 11));
  }
}
