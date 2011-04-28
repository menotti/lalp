package alp.tests.dijkstra;

import javax.swing.BorderFactory;
import javax.swing.JPanel;
import javax.swing.border.Border;

public class BorderedPanel extends JPanel {
	private static final long serialVersionUID = 514901490549805915L;
	
	String caption;
	
	public BorderedPanel(String caption) {
		super();
		this.setCaption(caption);
	}
	
	public String getCaption() {
		return this.caption;
	}
	
	public void setCaption(String caption) {
		this.caption = caption;
		putBorder();
	}
	
	public void putBorder() {
		Border etched = BorderFactory.createEtchedBorder();
		Border border = BorderFactory.createTitledBorder(etched, caption);
		this.setBorder(border);
	}
}
