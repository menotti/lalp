
int main()
{
  int v[8UL] = {(1), (2), (3), (4), (5), (6), (7), (8)};
  int maxval = 0;
  int i;
  for (i = 0; i < 8; i++) 
    if (v[i] > maxval) 
      maxval = v[i];
  return maxval;
}
