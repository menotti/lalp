int main() {
	int v[10] = {1,2,800,23,1,2,3,4,1000,2};
	int maxval = 0;
	int i;

	//#pragma unroll 2
	for (i=0; i<10; i++){
		if (v[i] > maxval){
	    		maxval = v[i];
	    	}
  	}
  	return maxval;
}
