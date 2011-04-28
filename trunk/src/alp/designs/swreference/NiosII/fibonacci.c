#include "fibonacci.h"

int fibonacci() {
  int v[N] = {0, 1};
  int i;
  for (i=2; i<N; i++) {
    v[i] = v[i-1] + v[i-2];
  }
  return v[i];
}

