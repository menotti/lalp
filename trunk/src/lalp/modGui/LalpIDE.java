package lalp.modGui;
//author: Karan Bhandari
//GUI implementation of Ricardo's LALP 
import javax.swing.*;  
import java.awt.*;  
import java.awt.event.*;  
import java.util.Scanner;  
import java.io.*;  
import java.net.InetAddress;
import java.net.UnknownHostException;

import lalp.algorithms.*;
import lalp.core.Design;
import lalp.core.Parameters;
import lalp.parser.LangParser;
import lalp.parser.lang.SimpleNode;
import lalp.webServices.lalpServerImplementation;

import javax.xml.ws.Endpoint;

public class LalpIDE extends JFrame implements ActionListener {
		private TextArea textArea = new TextArea("", 10,0, TextArea.SCROLLBARS_VERTICAL_ONLY);
		private static TextArea outputTextArea = new TextArea("", 10,0, TextArea.SCROLLBARS_VERTICAL_ONLY);
		
		//File Menu
		       private MenuBar menuBar = new MenuBar();  
			private Menu file = new Menu();
			private MenuItem open = new MenuItem();   
			private MenuItem save = new MenuItem();  
			private MenuItem close = new MenuItem();
			
			//generate menu
			private Menu generate = new Menu();
			private MenuItem debugop = new MenuItem();
			private MenuItem graphviz = new MenuItem();
			private MenuItem graphvizSub = new MenuItem();
			private MenuItem vhdl = new MenuItem();
			private MenuItem vhdlMem = new MenuItem();
			private MenuItem vhdlTb= new MenuItem();
			private MenuItem alpg= new MenuItem();
			
			//others
			FileInputStream inStream;
			Design design = null;
			LangParser lp = null;
			public static boolean inactive=false;
		public LalpIDE() {
				this.setSize(500, 300);  
				this.setTitle("LALP");  
				//setDefaultCloseOperation(EXIT_ON_CLOSE);  
				this.textArea.setFont(new Font("Century Gothic", Font.BOLD, 12));  
				
				Box box=Box.createVerticalBox();
				box.add(textArea);
				box.add(new Label("Output"));
				box.add(outputTextArea);
				this.getContentPane().setLayout(new BorderLayout());  
				//this.getContentPane().add(textArea);
				this.getContentPane().add(box);
				
				this.setMenuBar(this.menuBar);
				this.menuBar.add(this.file);  
				this.menuBar.add(this.generate);
				defineFileMenu();
				defineGenerateMenu();
				
			    InetAddress addr = null;
				try {
					addr = InetAddress.getLocalHost();
				} catch (UnknownHostException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

			    // Get IP Address
			    byte[] ipAddr = addr.getAddress();
				//start web services
				Endpoint.publish("http://127.0.0.1:9877/webServices", new lalpServerImplementation());
				
				
				this.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
				this.addWindowListener(new WindowAdapter() {
					@Override
					public void windowClosed(WindowEvent e) {
						//inform parent command line about "ON_EXIT"
						inactive=true;
						
					}
				});
			}
		private void defineFileMenu() {
			this.file.setLabel("File");
			this.open.setLabel("Open");  
			this.open.addActionListener(this);  
			this.open.setShortcut(new MenuShortcut(KeyEvent.VK_O, false));  
			this.file.add(this.open);  
			 
			this.save.setLabel("Save");
			this.save.addActionListener(this);
			this.save.setShortcut(new MenuShortcut(KeyEvent.VK_S, false));
			this.file.add(this.save);
			
			 
			this.close.setLabel("Close");
			 
			this.close.addActionListener(this);
			this.file.add(this.close);
		}
		private void defineGenerateMenu()
		{
			this.generate.setLabel("Generate");
			this.debugop.setLabel("debug output pins");
			this.graphviz.setLabel("Graphviz");
			this.graphvizSub.setLabel("Graphviz subgraphs");
			this.vhdl.setLabel("VHDL");
			this.vhdlMem.setLabel("VHDL memory initialization");
			this.vhdlTb.setLabel("VHDL testbench");
			this.alpg.setLabel("ALPG");
			
			this.debugop.addActionListener(this);
			this.graphviz.addActionListener(this);
			this.graphvizSub.addActionListener(this);
			this.vhdl.addActionListener(this);
			this.vhdlMem.addActionListener(this);
			this.vhdlTb.addActionListener(this);
			this.alpg.addActionListener(this);
			
			this.generate.add(this.debugop);
			this.generate.add(this.graphviz);
			this.generate.add(this.graphvizSub);
			this.generate.add(this.vhdl);
			this.generate.add(this.vhdlMem);
			this.generate.add(this.vhdlTb);
			this.generate.add(this.alpg);
		}
		public LalpIDE(String filePath)
		{
			LalpIDE ide=new LalpIDE();
			ide.fillTextAreaWithFileContents(filePath);
			
		}
			public void actionPerformed (ActionEvent e) {
	
					if (e.getSource() == this.close)
						this.dispose(); 
					
					
					else if (e.getSource() == this.open) {
						JFileChooser open = new JFileChooser(); 
						int option = open.showOpenDialog(this); 
						
						if (option == JFileChooser.APPROVE_OPTION) {
							
							fillTextAreaWithFileContents(open.getSelectedFile().getPath());
						}
					}
					
					
					else if (e.getSource() == this.save) {
						JFileChooser save = new JFileChooser(); 
						int option = save.showSaveDialog(this); 
						
						
						if (option == JFileChooser.APPROVE_OPTION) {
							try {
								
								BufferedWriter out = new BufferedWriter(new FileWriter(save.getSelectedFile().getPath()));
								out.write(this.textArea.getText()); 
								out.close(); 
							} catch (Exception ex) { 
								
								System.out.println(ex.getMessage());
							}
						}
					}
					else if (e.getSource() == this.debugop) { 
						saveTempFile();
						populateDesign();
						try {
							design.generateDebugOutputs();
						} catch (Exception E2) {
							E2.printStackTrace();
							System.exit(1);
						}
						deleteTempFile();
					 }
					else if (e.getSource() == this.graphviz) { 
						saveTempFile();
						populateDesign();
						Graphviz dot = new Graphviz();
						dot.generateHardwareVisualization(design);
						dot.generateSoftwareVisualization(design);
						deleteTempFile();
					 }
					else if (e.getSource() == this.graphvizSub) { 
						saveTempFile();
						populateDesign();
						Graphviz dot = new Graphviz();
						dot.generateHardwareVisualization(design);
						dot.generateSoftwareVisualization(design);
						dot.generateSCCSubgraphs(design);
						deleteTempFile();
					 }
					else if (e.getSource() == this.vhdl) {
						saveTempFile();
						populateDesign();
						VHDL vhd = new VHDL();
						vhd.generateVHDL(design);
						
						deleteTempFile();
					 }
					else if (e.getSource() == this.vhdlMem) {
						saveTempFile();
						populateDesign();
						VHDL vhd = new VHDL();
						vhd.generateVHDL(design);
						vhd.generateVHDLInitialization(design);

						deleteTempFile();
					 }
					else if (e.getSource() == this.vhdlTb) {
						saveTempFile();
						populateDesign();
						VHDL vhd = new VHDL();
						vhd.generateVHDL(design);
						vhd.generateVHDLTestbench(lp);
						deleteTempFile();
					 }
					else if (e.getSource() == this.alpg) {
						saveTempFile();
						populateDesign();
						ALPG alpg = new ALPG();
						alpg.generateALPG(design);
						deleteTempFile();
					 }
				}
			private void populateDesign() {
				try {inStream = new FileInputStream("temp.ALP");} catch (FileNotFoundException e1) {e1.printStackTrace();}
				lp = new LangParser(inStream);
				System.out.println("Ok!");
				lp.createComponents();
				design = lp.getDesign();
				System.out.print("Connecting hardware components...");
				lp.getRoot().connectComponents();
				if (SimpleNode.allComponents.containsKey("init")) {
					lp.getParser().design.setInit(SimpleNode.allComponents.get("init"));
				}
				System.out.println("Ok!");
			}
			private void deleteTempFile() {
				File f=new File("temp.ALP");
				f.delete();
				
			}
			private void saveTempFile() {
				try {
					
					BufferedWriter out = new BufferedWriter(new FileWriter("temp.ALP"));
					out.write(this.textArea.getText()); 
					out.close(); 
				} catch (Exception ex) { 
					
					System.out.println(ex.getMessage());
				}
			}
			private void fillTextAreaWithFileContents(String obtainedPath) {
				this.textArea.setText(""); 
				try {
					
					Scanner scan = new Scanner(new FileReader(obtainedPath));
					while (scan.hasNext()) 
						this.textArea.append(scan.nextLine() + "\n"); 
				} catch (Exception ex) { 
					
					System.out.println(ex.getMessage());
				}
			}
			//overriding system.out.println-It must display in output window as well as textbox
			 static 
		       { 
		        // as we are using System.out as the output stream in main 
		        final PrintStream currentOut = System.out; 

		          // anonymous as we would need this sub class here only 
		         PrintStream newOut = new PrintStream(currentOut) 
		          { 
		              // Overriding 'println' method 
		              public void println(String string) 
		              { 
		                 
		                 outputTextArea.append(string+"\n");
		                 super.println(string);
		              } 
		         };

		        // Now we are ready with the modified PrintStream and hence setting that 

		        System.setOut(newOut);

		 }
			

 
}