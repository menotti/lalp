int main() {
  int i;
  int res[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  int b[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  int d[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  int c = 10;
  int e = 5;

  for (i = 0 ; i < 10 ; i++ ) {
  	res[i] = b[i] +  e;
        e = c + d[i];
        res[i] = e + c + b[i];
  }
  return res[0];
}
