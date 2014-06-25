int main() {
	int v[10] = {1,2,800,23,1,2,3,4,1000,2};
	int maxval = 0;
	int val = 0;
	int i;

	for (i=0; i<10; i++){
		val = v[i];
		if (val > maxval){
	    		maxval = val;
	    	}
  	}
  	return maxval;
}
