package revampedguilalp.getValuesFromOS;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class Linux {
	public static ArrayList exeCmd(String cmd) {
		 Process p = null;
        String s = null;
        ArrayList arr=new ArrayList<String>();
        try {
            
	    
           
           p = Runtime.getRuntime().exec(cmd);
            
            BufferedReader stdInput = new BufferedReader(new 
                 InputStreamReader(p.getInputStream()));

            BufferedReader stdError = new BufferedReader(new 
                 InputStreamReader(p.getErrorStream()));
            while((s = stdInput.readLine())!=null)
            		arr.add(s);
           while((s = stdError.readLine()) != null)
        	   arr.add(s);
            
            return arr;
        }
        catch (IOException e) {
           return arr;
            
            
        }
	}
}
