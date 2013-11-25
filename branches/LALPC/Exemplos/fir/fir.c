void main() {
   int a1,b1,c1,d1,e1,i,res =0;
   #pragma unroll 4  
   for(i = 0; i<4; i++){
       a1 = i * 3;
       b1 = i * 5;
       c1 = i * 7;
       d1 = i * 9;
       e1 = i * 11;
       res = ((a1+b1)+c1)+(d1+e1);
   }
}
