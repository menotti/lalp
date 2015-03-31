
// Simple accumulation
int main() {
#pragma DATA_WIDTH 64
int a[10] = {1,2,3,4,5,6,7,8,9,10};
int sum = 0;
int i;
//#pragma multport
//#pragma unroll 2
for (i = 0; i < 10; i++) {
	sum += a[i] + i;
	//printf("sum %d = %d\n", i, sum);
}
//printf("sum = %d\n", sum);

return sum;
}
