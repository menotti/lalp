#include <stdio.h>

#define N 32

void fibonacci() {
  int a=1;
  int b=0;
  int i, c;
  for (i=0; i<N; i++) {
    c=a+b;
    printf("%i ", b);
    b=a;
    a=c;
  }
  return;
}

int main(void) {
  fibonacci();
  return 0;
}


