int main() {
  int i;
  int z[3];
  int x[3] = {2, 1, 0};
  int y[3] = {6, 5, 4};

  for (i = 0 ; i < 3; i++ ) {
  	z[i] = x[i] + y[i];
  }
  return z[0];
}
