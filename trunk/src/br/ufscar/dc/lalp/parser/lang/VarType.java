package br.ufscar.dc.lalp.parser.lang;

public class VarType {

	public int bitwidth;   //numero total de bits
	public int frac_width; //numero de bits da parte fracinaria
	public int int_width;  //numero de bits da parte interica
	
    public enum Type{BIT, UNSIGNED, SIGNED, UFIXED, SFIXED, FLOAT};
    
    private Type type;
	
	VarType() {
		super();
		type = Type.UNSIGNED;
		this.bitwidth = 32;
		this.frac_width = 0;
		this.int_width =0;
	}	
	
	public int getFrac_width() {
		return frac_width;
	}

	public void setFrac_width(int frac_width) {
		this.frac_width = frac_width;
	}
	public int getInt_width() {
		return int_width;
	}

	public void setInt_width(int int_width) {
		this.int_width = int_width;
	}

	public int getBitwidth() {
		return bitwidth;
	}

	public void setBitwidth(int bitwidth) {
		this.bitwidth = bitwidth;
	}

	public Type getType() {
		return type;
	}

	public void setType(Type type) {
		this.type = type;
	}
	
	@Override
	public String toString() {
		return "[bitwidth=" + bitwidth + ", frac_width="
				+ frac_width + ", int_width=" + int_width + ", type=" + type
				+ "]";
	}
	
	public String toString(boolean typeOnly) {
		
		if(typeOnly)
		return "[type=" + type+ "]";
		else return toString();
	}


	
}
