package lalp.core;

import java.util.Vector;

import lalp.parser.lang.SimpleNode;


public class Process {
	public static enum CheckingType {WHEN, FOREACH, WAIT};
	private CheckingType checkingType;
	private String conditionalSignal;
	private int value;
	private Vector<SimpleNode> results = new Vector<SimpleNode>();
	
	
	//Constructor for WHEN checking
	public Process(CheckingType checkingType, String conditionalSignal)
	{
		this.checkingType = checkingType;
		this.conditionalSignal = conditionalSignal;
	}
	//Constructor for FOREACH checking
	public Process(CheckingType checkingType)
	{
		this.checkingType = checkingType;
	}
	//Constructor for WAIT checking
	public Process(CheckingType checkingType, String conditionalSignal, int value)
	{
		this.checkingType = checkingType;
		this.conditionalSignal = conditionalSignal;
		this.value = value;
	}
	
	public CheckingType getCheckingType() {
		return checkingType;
	}
	public void setCheckingType(CheckingType checkingType) {
		this.checkingType = checkingType;
	}
	public String getConditionalSignal() {
		return conditionalSignal;
	}
	public void setConditionalSignal(String conditionalSignal) {
		this.conditionalSignal = conditionalSignal;
	}
	public int getValue() {
		return value;
	}
	public void setValue(int value) {
		this.value = value;
	}
	public Vector<SimpleNode> getResults() {
		return results;
	}
	public void addResult(SimpleNode result) {
		results.add(result);
	}

}
