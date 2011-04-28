#define SIZE 8

void simple_scc() {
  int sum = 0;
  int i, a, b, c = 0;
  int indata[] = {12, 41, 96, 87, 56, 25, 69, 31};
  for (i = 0; i < SIZE; i++) {
    a = indata[i];
    b = a - c;
    c = b + a;
    sum += c;
  }  
}

int main() {
  simple_scc();
  return 0;
}
