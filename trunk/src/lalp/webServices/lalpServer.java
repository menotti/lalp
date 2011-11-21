package lalp.webServices;

import javax.jws.WebService;
import javax.jws.WebMethod;
import javax.jws.soap.SOAPBinding;
import javax.jws.soap.SOAPBinding.Style;
/**
* author:Karan Bhandari
* WebService end point interface for Ricardo's LALP
*/
@WebService
@SOAPBinding(style = Style.RPC) // more on this later
public interface lalpServer {
@WebMethod String getTimeAsString();
@WebMethod String debugopGeneration(String in);
@WebMethod String graphvizGeneration(String in);
@WebMethod String graphvizSubGeneration(String in);
@WebMethod String vhdlGeneration(String in);
@WebMethod String vhdlMemGeneration(String in);
@WebMethod String vhdlTbGeneration(String in);
@WebMethod String alpgGeneration(String in);
}