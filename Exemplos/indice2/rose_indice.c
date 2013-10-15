
int main()
{
  int i;
  int a[3UL] = {(1), (2), (3)};
  int b[3UL];
  for (i = 0; i < 3; i++) {
    b[i] = (a[i] + i);
  }
  return b;
}
