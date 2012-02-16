//@author = Brandão, João Vitor

package lalp.parser.lang;

import java.util.ArrayList;
import java.util.List;

public class TestbenchUnity {
	private String conditinalSignal; //when this signal change, a check is made on the results
	private String resultName; //list with the results names
	
	public String getConditinalSignal() {
		return conditinalSignal;
	}
	public void setConditionalSignal(String conditinalSignal) {
		this.conditinalSignal = conditinalSignal;
	}
	public String getResultName() {
		return resultName;
	}
	public void setResultName(String resultName) {
		this.resultName = resultName;
	}
}
