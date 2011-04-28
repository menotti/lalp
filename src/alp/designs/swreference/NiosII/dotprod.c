#include "dotprod.h"

int dotprod() {
  int a[N], b[N];
  int i, sum = 0;
  for (i=0; i<N; i++)
    sum += a[i] * b[i];
  return sum;
}
