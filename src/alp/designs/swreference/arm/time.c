#include <stdio.h>
#include <sys/times.h>
#include <time.h>

#define N 2048

inline void hello() {
	int i, j;
	for (i=0; i<N; i++)
		for (j=0; j<N; j++);
}

int main() {
	struct tms start_cpu, end_cpu;
	clock_t start, end;
	double elapsed; 

	start = times(&start_cpu); 

	hello();

	end = times(&end_cpu);

	elapsed = (double)(end - start);

	printf("tms->tms_utime=%f\n", (double)start_cpu.tms_utime);
	printf("tms->tms_stime=%f\n", (double)start_cpu.tms_stime);
	printf("tms->tms_cutime=%f\n", (double)start_cpu.tms_cutime);
	printf("tms->tms_cstime=%f\n\n", (double)start_cpu.tms_cstime);

	printf("tms->tms_utime=%f\n", (double)end_cpu.tms_utime);
	printf("tms->tms_stime=%f\n", (double)end_cpu.tms_stime);
	printf("tms->tms_cutime=%f\n", (double)end_cpu.tms_cutime);
	printf("tms->tms_cstime=%f\n\n", (double)end_cpu.tms_cstime);

	printf("N=%i\n", N);
	printf("CLOCKS_PER_SEC=%li\n", CLOCKS_PER_SEC);
	printf("start=%f\n", (double)start);
	printf("end=%f\n", (double)end);
	printf("elapsed=%f\n", elapsed);
	return 0;
}

