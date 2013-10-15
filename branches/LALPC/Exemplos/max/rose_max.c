
int main()
{
  int v[3UL] = {(70), (1), (800)};
  int maxval = 0;
  int i;
  for (i = 0; i < 3; i++) 
    if (v[i] > maxval) 
      maxval = v[i];
  return maxval;
}
