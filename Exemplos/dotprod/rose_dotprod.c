
int main()
{
  int a[3UL] = {(1), (1), (1)};
  int b[3UL] = {(1), (1), (1)};
  int i;
  int sum = 0;
  for (i = 0; i < 3; i++) {
    sum += (a[i] * b[i]);
  }
  return sum;
}
