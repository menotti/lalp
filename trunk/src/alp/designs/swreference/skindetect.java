package alp.designs.swreference;

public class skindetect {

	public static final void skinDetect(int[] rgb, int xSize, int ySize, int[] skin) {

		int Size = xSize*ySize;
		for (int i = 0; i < Size; i++) {
			int rgb1 = rgb[i];
			int pixel;


			int blue = (rgb1 & 0xFF);
			int green = (rgb1 & 0xFF00) >> 8;
			int red = (rgb1 & 0xFF0000) >> 16;

			// not skin
			pixel=0;
	
			// abs(red-green)
			int abs_rg = red-green;
			if(abs_rg < 0) abs_rg = -abs_rg;
	
			// max3(red,green,blue)
			int max3 = red;
			if(green > max3) max3 = green;
			if(blue > max3) max3 = blue;
	
	
			// min3(red,green,blue)
			int min3 = red;
			if(green < min3) min3 = green;
			if(blue < min3) min3 = blue;
	
			if((red>95) && (green>40) && (blue>20) && ((max3 - min3) > 15) && (abs_rg>15) && (red>green) && (red>blue))  {
				pixel =  0xFFFFFF; // is skin
			}
	
			skin[i] = pixel;
		}
	}
}