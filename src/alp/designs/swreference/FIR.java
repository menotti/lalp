package alp.designs.swreference;

public class FIR {
	//Ntaps is the number of taps
	// Nx is the number of data-points
	static void fir(short x[], short h[], short y[], short Ntaps, short Nx) {
	 for (short j = 0; j < Nx; j++) {
	  int sum = 0;

	  for (short i = 0; i < Ntaps; i++) {
	   sum += x[i + j] * h[i];
	  }
	  y[j] = (short) (sum >> 15);
	 }
	}
}
