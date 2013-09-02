int main() {
  int i;
  int z[10];
  int x[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
  int y[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

  for (i = 0 ; i < 10 ; i++ ) {
  	z[i] = x[i] + y[i];
  }
  return z[0];
}
