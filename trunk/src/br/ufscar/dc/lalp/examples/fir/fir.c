int fir(int a, int b, int c, int d, int e) {
	return a*3 + b*5 + c*7 + d*9 + e*11;
}

int main() {
	int i;
	for (i=1; i<5; i++)
		fir(i, i, i, i, i);
}
