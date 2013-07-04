void addsub(int x, int y, int *a, int*s) {
  *a = x + y;
  *s = x - y;
  return;
}

int main() {
  int a, s;
  addsub(1, 3, &a, &s);
  addsub(2, 2, &a, &s);
  addsub(3, 1, &a, &s);
  return;
}
