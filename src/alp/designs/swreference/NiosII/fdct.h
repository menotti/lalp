#define N 8 // fixed
#define M N*N 
#define num_fdcts 10 // 5400 NTSC: 720x480 => 90 x 60 blocks of 8x8; if 1 then 8x8 DCT
#define SIZE num_fdcts*M

short    dct_io_ptr[SIZE]; 
short    dct_io_tmp[SIZE];   
short    dct_o[SIZE]; 

int fdct(void);
