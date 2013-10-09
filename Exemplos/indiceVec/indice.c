int main() {
	int i;
	int a[4] = {1,3,5,7};
	int b[4] = {0,1,0,1};
	int res  = 0;
	for(i=1; i<4; i=i+2){
		res += a[i]+b[i-1];
	}
  	return res;
}
