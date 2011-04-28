#define N 2048

int main() {
	int max=0, i;
	int v[N];
	for (i=0; i<N; i++)
		if (v[i] > max)
			max = v[i];
	return max;
}

