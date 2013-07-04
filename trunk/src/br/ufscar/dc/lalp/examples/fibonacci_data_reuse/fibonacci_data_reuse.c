#define N 32

void fibonacci(int n, int *v) {

	int i, a=0, b=1;
	
	for (i=0; i<n; i++) {
		v[i] = a + b;
		a = b;
		b = v[i];
	}
	return;
}

int main() {
  int v[N];
  fibonacci(N, v);
  return 0;
}
