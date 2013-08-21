int main() {
  int i;
  int res[10];
  int b[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
  int d[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

  for (i = 0 ; i < 10 ; i++ ) {
  	res[i] = b[i] +  d[i];
  }
  return res[0];
}
