/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package revampedguilalp.fileRelated;



import java.io.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import revampedguilalp.getValuesFromOS.Linux;

/**
 *
 * @author karan
 */
public class FileOperations {

   public ArrayList Read(String file) throws FileNotFoundException, IOException
    {
            ArrayList fileContent=new ArrayList();
            //File f1=new File(dir,file);
            InputStream f = new FileInputStream(file);
            int size=f.available();
            for (int i=0; i <size; i++)
               fileContent.add((char) f.read());
        return fileContent;
    
    }
   public String checkAndSetVariables(String lalpUrl)
   {
        if(System.getProperty("os.name").toUpperCase().contains("WIN"))
        {
            return null;
        }
        else
        {
           // System.out.println(System.getenv());
            
            return (Linux.exeCmd("sh setlalphome.sh "+lalpUrl).get(0).toString());
        }

   }
   public ArrayList executeLalpCommands(String lalpUrl,String option,String file)
   {
        if(System.getProperty("os.name").toUpperCase().contains("WIN"))
        {
                return null;
        }
        else
        {
                 return (Linux.exeCmd("sh "+lalpUrl+"/lalp -"+option+" "+file));
        }
   }

}
