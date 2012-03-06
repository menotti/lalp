/*
 * Copyright (c) 2003 Sun Microsystems, Inc. All  Rights Reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * -Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 * 
 * -Redistribution in binary form must reproduct the above copyright
 *  notice, this list of conditions and the following disclaimer in
 *  the documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of Sun Microsystems, Inc. or the names of contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 * 
 * This software is provided "AS IS," without a warranty of any kind. ALL
 * EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND WARRANTIES, INCLUDING
 * ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
 * OR NON-INFRINGEMENT, ARE HEREBY EXCLUDED. SUN AND ITS LICENSORS SHALL NOT
 * BE LIABLE FOR ANY DAMAGES OR LIABILITIES SUFFERED BY LICENSEE AS A RESULT
 * OF OR RELATING TO USE, MODIFICATION OR DISTRIBUTION OF THE SOFTWARE OR ITS
 * DERIVATIVES. IN NO EVENT WILL SUN OR ITS LICENSORS BE LIABLE FOR ANY LOST
 * REVENUE, PROFIT OR DATA, OR FOR DIRECT, INDIRECT, SPECIAL, CONSEQUENTIAL,
 * INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER CAUSED AND REGARDLESS OF THE THEORY
 * OF LIABILITY, ARISING OUT OF THE USE OF OR INABILITY TO USE SOFTWARE, EVEN
 * IF SUN HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
 * 
 * You acknowledge that Software is not designed, licensed or intended for
 * use in the design, construction, operation or maintenance of any nuclear
 * facility.
 */

/* Copyright (c) 2010 Ricardo Menotti, All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its 
 * documentation for NON-COMERCIAL purposes and without fee is hereby granted 
 * provided that this copyright notice appears in all copies.
 *
 * RICARDO MENOTTI MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY
 * OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR 
 * NON-INFRINGEMENT. RICARDO MENOTTI SHALL NOT BE LIABLE FOR ANY DAMAGES 
 * SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS 
 * SOFTWARE OR ITS DERIVATIVES. 
 */

package lalp.gui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.FileDialog;
import java.awt.Font;
import java.awt.Frame;
import java.awt.Graphics;
import java.awt.Insets;
import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.net.URL;
import java.util.Hashtable;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.swing.AbstractAction;
import javax.swing.Action;
import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTextArea;
import javax.swing.JToolBar;
import javax.swing.JViewport;
import javax.swing.Scrollable;
import javax.swing.SwingConstants;
import javax.swing.UIManager;
import javax.swing.event.UndoableEditEvent;
import javax.swing.event.UndoableEditListener;
import javax.swing.text.BadLocationException;
import javax.swing.text.Document;
import javax.swing.text.JTextComponent;
import javax.swing.text.PlainDocument;
import javax.swing.text.TextAction;
import javax.swing.undo.CannotRedoException;
import javax.swing.undo.CannotUndoException;
import javax.swing.undo.UndoManager;

import lalp.algorithms.ALPG;
import lalp.algorithms.Dijkstra;
import lalp.algorithms.Dominators;
import lalp.algorithms.Graphviz;
import lalp.algorithms.Scheduling;
import lalp.algorithms.StrongConnectedComponents;
import lalp.algorithms.VHDL;
import lalp.core.Design;
import lalp.core.Parameters;
import lalp.parser.GraphParser;
import lalp.parser.LangParser;
import lalp.parser.lang.SimpleNode;


/**
 * The LALP Graphical User Unterface
 * @author <a href="http://menotti.pro.br/">Ricardo Menotti</a>
 * @author <a href="http://www.dc.ufscar.br/">DC/UFSCar</a>
 * @version January, 2010
 * @see ALPGUI
 */
@SuppressWarnings("serial")
class ALPGUI extends JPanel {

	private static ResourceBundle resources;
	private Design design = null;
	private Component graph;
	private JSplitPane splitPane;
	LangParser lp;

	static {
		try {
			resources = ResourceBundle.getBundle("lalp.gui.resources.ALPGUI", Locale.getDefault());
		} catch (MissingResourceException mre) {
			System.err.println("lalp/gui/resources/ALPGUI.properties not found");
			System.exit(1);
		}
	}

	ALPGUI() {
		super(true);

		try {
			// Force SwingSet to come up in the Cross Platform L&F
			// UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());

			// If you want the System L&F instead, comment out the above line and
			// uncomment the following:
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());

		} catch (Exception exc) {
			System.err.println("Error loading Look & Feel: " + exc);
		}

		setBorder(BorderFactory.createEtchedBorder());
		setLayout(new BorderLayout());

		// create the embedded JTextComponent
		editor = createEditor();
		// Add this as a listener for undoable edits.
		editor.getDocument().addUndoableEditListener(undoHandler);

		// install the command table
		commands = new Hashtable();
		Action[] actions = getActions();
		for (int i = 0; i < actions.length; i++) {
			Action a = actions[i];
			//commands.put(a.getText(Action.NAME), a);
			commands.put(a.getValue(Action.NAME), a);
		}

		JScrollPane scroller = new JScrollPane();
		JViewport port = scroller.getViewport();
		port.add(editor);
		try {
			String vpFlag = resources.getString("ViewportBackingStore");
			Boolean bs = new Boolean(vpFlag);
			port.setBackingStoreEnabled(bs.booleanValue());
		} catch (MissingResourceException mre) {
			// just use the viewport default
		}

		menuItems = new Hashtable();
		menubar = createMenubar();

		// don't add menubar directly to panel; add to frame in main()
		// to take advantage of screen menu bar if available
//		 add("North", menubar);
		graph = new JLabel("Compile whit Graphviz checked");
	 	graph.setMinimumSize(new Dimension(200, 200)); 
		
		JPanel panel = new JPanel();
		panel.setLayout(new BorderLayout());
		panel.add("Center", scroller);
	 	panel.setMinimumSize(new Dimension(200, 200)); 
		
        splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, panel, graph); 
        splitPane.setContinuousLayout(true); 
        splitPane.setOneTouchExpandable(true);
		
		add("North", createToolbar());
		add("Center", splitPane);
		add("South", createStatusbar());
	}
	
	public static void Info(String s) {
		System.out.println(s);
		System.exit(0);
	}

	public static void Error(String s) {
		System.err.println(s);
		System.exit(1);
	}

	public static void main(String[] args) {
		
		try {
			String vers = System.getProperty("java.version");
			if (vers.compareTo("1.1.2") < 0) {
				System.out.println("!!!WARNING: Swing must be run with a " +
				"1.1.2 or higher version VM!!!");
			}

			try {
				java.lang.System.setProperty("apple.laf.useScreenMenuBar", "true");
			} catch (Exception e) {
				// try the older menu bar property
				java.lang.System.setProperty("com.apple.macos.useScreenMenuBar", "true");
			}

			JFrame frame = new JFrame();
			frame.setTitle(resources.getString("Title"));
			frame.setBackground(Color.lightGray);
			frame.getContentPane().setLayout(new BorderLayout());

			ALPGUI myALPGUI = new ALPGUI();
			frame.getContentPane().add("Center", myALPGUI);
			frame.addWindowListener(new AppCloser());
			
			// take advantage of screen menu bar if available
			frame.setJMenuBar(myALPGUI.menubar);

			frame.pack();
			frame.setSize(500, 600);
			frame.show();
		} catch (Throwable t) {
			System.out.println("uncaught exception: " + t);
			t.printStackTrace();
		}
	}

	/**
	 * Fetch the list of actions supported by this
	 * editor.  It is implemented to return the list
	 * of actions supported by the embedded JTextComponent
	 * augmented with the actions defined locally.
	 */
	public Action[] getActions() {
		return TextAction.augmentList(editor.getActions(), defaultActions);
	}

	/**
	 * Create an editor to represent the given document.  
	 */
	protected JTextComponent createEditor() {
		JTextComponent c = new JTextArea();
		c.setDragEnabled(true);
		c.setFont(new Font("monospaced", Font.PLAIN, 12));
		return c;
	}

	/** 
	 * Fetch the editor contained in this panel
	 */
	protected JTextComponent getEditor() {
		return editor;
	}

	/**
	 * To shutdown when run as an application.  This is a
	 * fairly lame implementation.   A more self-respecting
	 * implementation would at least check to see if a save
	 * was needed.
	 */
	protected static final class AppCloser extends WindowAdapter {
		public void windowClosing(WindowEvent e) {
			System.exit(0);
		}
	}

	/**
	 * Find the hosting frame, for the file-chooser dialog.
	 */
	protected Frame getFrame() {
		for (Container p = getParent(); p != null; p = p.getParent()) {
			if (p instanceof Frame) {
				return (Frame) p;
			}
		}
		return null;
	}

	/**
	 * This is the hook through which all menu items are
	 * created.  It registers the result with the menuitem
	 * hashtable so that it can be fetched with getMenuItem().
	 * @see #getMenuItem
	 */
	protected JMenuItem createMenuItem(String cmd) {
		JMenuItem mi = new JMenuItem(getResourceString(cmd + labelSuffix));
		URL url = getResource(cmd + imageSuffix);
		if (url != null) {
			mi.setHorizontalTextPosition(JButton.RIGHT);
			mi.setIcon(new ImageIcon(url));
		}
		String astr = getResourceString(cmd + actionSuffix);
		if (astr == null) {
			astr = cmd;
		}
		mi.setActionCommand(astr);
		Action a = getAction(astr);
		if (a != null) {
			mi.addActionListener(a);
			a.addPropertyChangeListener(createActionChangeListener(mi));
			mi.setEnabled(a.isEnabled());
		} else {
			mi.setEnabled(false);
		}
		menuItems.put(cmd, mi);
		return mi;
	}

	/**
	 * Fetch the menu item that was created for the given
	 * command.
	 * @param cmd  Name of the action.
	 * @returns item created for the given command or null
	 *  if one wasn't created.
	 */
	protected JMenuItem getMenuItem(String cmd) {
		return (JMenuItem) menuItems.get(cmd);
	}

	protected Action getAction(String cmd) {
		return (Action) commands.get(cmd);
	}

	protected String getResourceString(String nm) {
		String str;
		try {
			str = resources.getString(nm);
		} catch (MissingResourceException mre) {
			str = null;
		}
		return str;
	}

	protected URL getResource(String key) {
		String name = getResourceString(key);
		if (name != null) {
			URL url = this.getClass().getResource(name);
			return url;
		}
		return null;
	}

	protected Container getToolbar() {
		return toolbar;
	}

	protected JMenuBar getMenubar() {
		return menubar;
	}

	/**
	 * Create a status bar
	 */
	protected Component createStatusbar() {
		// need to do something reasonable here
		status = new StatusBar();
		return status;
	}

	/**
	 * Resets the undo manager.
	 */
	protected void resetUndoManager() {
		undo.discardAllEdits();
		undoAction.update();
		redoAction.update();
	}

	/**
	 * Create the toolbar.  By default this reads the 
	 * resource file for the definition of the toolbar.
	 */
	private Component createToolbar() {
		toolbar = new JToolBar();
		String[] toolKeys = tokenize(getResourceString("toolbar"));
		for (int i = 0; i < toolKeys.length; i++) {
			if (toolKeys[i].equals("-")) {
				toolbar.add(Box.createHorizontalStrut(5));
			} else {
				toolbar.add(createTool(toolKeys[i]));
			}
		}
		toolbar.add(Box.createHorizontalGlue());
		return toolbar;
	}

	/**
	 * Hook through which every toolbar item is created.
	 */
	protected Component createTool(String key) {
		return createToolbarButton(key);
	}

	/**
	 * Create a button to go inside of the toolbar.  By default this
	 * will load an image resource.  The image filename is relative to
	 * the classpath (including the '.' directory if its a part of the
	 * classpath), and may either be in a JAR file or a separate file.
	 * 
	 * @param key The key in the resource file to serve as the basis
	 *  of lookups.
	 */
	protected JButton createToolbarButton(String key) {
		URL url = getResource(key + imageSuffix);
		JButton b = new JButton(new ImageIcon(url)) {
			public float getAlignmentY() { return 0.5f; }
		};
		b.setRequestFocusEnabled(false);
		b.setMargin(new Insets(1,1,1,1));

		String astr = getResourceString(key + actionSuffix);
		if (astr == null) {
			astr = key;
		}
		Action a = getAction(astr);
		if (a != null) {
			b.setActionCommand(astr);
			b.addActionListener(a);
		} else {
			b.setEnabled(false);
		}

		String tip = getResourceString(key + tipSuffix);
		if (tip != null) {
			b.setToolTipText(tip);
		}

		return b;
	}

	/**
	 * Take the given string and chop it up into a series
	 * of strings on whitespace boundries.  This is useful
	 * for trying to get an array of strings out of the
	 * resource file.
	 */
	protected String[] tokenize(String input) {
		Vector v = new Vector();
		StringTokenizer t = new StringTokenizer(input);
		String cmd[];

		while (t.hasMoreTokens())
			v.addElement(t.nextToken());
		cmd = new String[v.size()];
		for (int i = 0; i < cmd.length; i++)
			cmd[i] = (String) v.elementAt(i);

		return cmd;
	}

	/**
	 * Create the menubar for the app.  By default this pulls the
	 * definition of the menu from the associated resource file. 
	 */
	protected JMenuBar createMenubar() {
		JMenuItem mi;
		JMenuBar mb = new JMenuBar();

		String[] menuKeys = tokenize(getResourceString("menubar"));
		for (int i = 0; i < menuKeys.length; i++) {
			JMenu m = createMenu(menuKeys[i]);
			if (m != null) {
				mb.add(m);
			}
		}
		return mb;
	}

	/**
	 * Create a menu for the app.  By default this pulls the
	 * definition of the menu from the associated resource file.
	 */
	protected JMenu createMenu(String key) {
		String[] itemKeys = tokenize(getResourceString(key));
		JMenu menu = new JMenu(getResourceString(key + "Label"));
		for (int i = 0; i < itemKeys.length; i++) {
			if (itemKeys[i].equals("-")) {
				menu.addSeparator();
			} else {
				JMenuItem mi = createMenuItem(itemKeys[i]);
				menu.add(mi);
			}
		}
		return menu;
	}

	// Yarked from JMenu, ideally this would be public.
	protected PropertyChangeListener createActionChangeListener(JMenuItem b) {
		return new ActionChangedListener(b);
	}

	// Yarked from JMenu, ideally this would be public.
	private class ActionChangedListener implements PropertyChangeListener {
		JMenuItem menuItem;

		ActionChangedListener(JMenuItem mi) {
			super();
			this.menuItem = mi;
		}
		public void propertyChange(PropertyChangeEvent e) {
			String propertyName = e.getPropertyName();
			if (e.getPropertyName().equals(Action.NAME)) {
				String text = (String) e.getNewValue();
				menuItem.setText(text);
			} else if (propertyName.equals("enabled")) {
				Boolean enabledState = (Boolean) e.getNewValue();
				menuItem.setEnabled(enabledState.booleanValue());
			}
		}
	}

	private JTextComponent editor;
	private Hashtable commands;
	private Hashtable menuItems;
	protected JMenuBar menubar;
	private JToolBar toolbar;
	private JComponent status;
	private JFrame elementTreeFrame;
	private File f;
	private String file, directory;
	

	protected FileDialog fileDialog;

	/**
	 * Listener for the edits on the current document.
	 */
	protected UndoableEditListener undoHandler = new UndoHandler();

	/** UndoManager that we add edits to. */
	protected UndoManager undo = new UndoManager();

	/**
	 * Suffix applied to the key used in resource file
	 * lookups for an image.
	 */
	public static final String imageSuffix = "Image";

	/**
	 * Suffix applied to the key used in resource file
	 * lookups for a label.
	 */
	public static final String labelSuffix = "Label";

	/**
	 * Suffix applied to the key used in resource file
	 * lookups for an action.
	 */
	public static final String actionSuffix = "Action";

	/**
	 * Suffix applied to the key used in resource file
	 * lookups for tooltip text.
	 */
	public static final String tipSuffix = "Tooltip";

	public static final String openAction = "open";
	public static final String newAction  = "new";
	public static final String saveAction = "save";
	public static final String exitAction = "exit";
	public static final String compileAction = "compile";

	class UndoHandler implements UndoableEditListener {

		/**
		 * Messaged when the Document has created an edit, the edit is
		 * added to <code>undo</code>, an instance of UndoManager.
		 */
		public void undoableEditHappened(UndoableEditEvent e) {
			undo.addEdit(e.getEdit());
			undoAction.update();
			redoAction.update();
		}
	}

	/**
	 * FIXME - I'm not very useful yet
	 */
	class StatusBar extends JComponent implements ActionListener {

		public StatusBar() {
			super();
			setLayout(new BoxLayout(this, BoxLayout.X_AXIS));
			JCheckBox myCheckBox = new JCheckBox("VHDL");
			myCheckBox.addActionListener(this);					
			add(myCheckBox);
			myCheckBox = new JCheckBox("ALPG");
			myCheckBox.addActionListener(this);					
			add(myCheckBox);
			myCheckBox = new JCheckBox("Graphviz");
			myCheckBox.addActionListener(this);					
			add(myCheckBox);
		}

		public void paint(Graphics g) {
			super.paint(g);
		}

		public void actionPerformed(ActionEvent e) {
			if (e.getActionCommand().equals("VHDL")) {
				Parameters.vhdl = ((JCheckBox)e.getSource()).isSelected();
				Parameters.vhdlMemory = ((JCheckBox)e.getSource()).isSelected();
				Parameters.vhdlTestbench = ((JCheckBox)e.getSource()).isSelected();
			}
			if (e.getActionCommand().equals("ALPG")) {
				Parameters.alpg = ((JCheckBox)e.getSource()).isSelected();
			}
			if (e.getActionCommand().equals("Graphviz")) {
				Parameters.graphviz = ((JCheckBox)e.getSource()).isSelected();
			}
	        Toolkit.getDefaultToolkit().beep();
		}
	}


	private UndoAction undoAction = new UndoAction();
	private RedoAction redoAction = new RedoAction();

	private Action[] defaultActions = {
			new NewAction(),
			new OpenAction(),
			new CompileAction(),
			new SaveAction(),
			new ExitAction(),
			undoAction,
			redoAction
	};

	class UndoAction extends AbstractAction {
		public UndoAction() {
			super("Undo");
			setEnabled(false);
		}

		public void actionPerformed(ActionEvent e) {
			try {
				undo.undo();
			} catch (CannotUndoException ex) {
				System.out.println("Unable to undo: " + ex);
				ex.printStackTrace();
			}
			update();
			redoAction.update();
		}

		protected void update() {
			if(undo.canUndo()) {
				setEnabled(true);
				putValue(Action.NAME, undo.getUndoPresentationName());
			}
			else {
				setEnabled(false);
				putValue(Action.NAME, "Undo");
			}
		}
	}

	class RedoAction extends AbstractAction {
		public RedoAction() {
			super("Redo");
			setEnabled(false);
		}

		public void actionPerformed(ActionEvent e) {
			try {
				undo.redo();
			} catch (CannotRedoException ex) {
				System.out.println("Unable to redo: " + ex);
				ex.printStackTrace();
			}
			update();
			undoAction.update();
		}

		protected void update() {
			if(undo.canRedo()) {
				setEnabled(true);
				putValue(Action.NAME, undo.getRedoPresentationName());
			}
			else {
				setEnabled(false);
				putValue(Action.NAME, "Redo");
			}
		}
	}

	class OpenAction extends NewAction {

		OpenAction() {
			super(openAction);
		}

		public void actionPerformed(ActionEvent e) {
			Frame frame = getFrame();
			if (fileDialog == null) {
				fileDialog = new FileDialog(frame);
			}
			fileDialog.setMode(FileDialog.LOAD);
			fileDialog.show();

			file = fileDialog.getFile();
			if (file == null) {
				return;
			}
			directory = fileDialog.getDirectory();
			f = new File(directory, file);
			System.out.println(file);
			System.out.println(directory);
			if (f.exists()) {
				Document oldDoc = getEditor().getDocument();
				if(oldDoc != null)
					oldDoc.removeUndoableEditListener(undoHandler);
				getEditor().setDocument(new PlainDocument());
				frame.setTitle(file);
				Thread loader = new FileLoader(f, editor.getDocument());
				loader.start();
			}
		}
	}
	


	class NewAction extends AbstractAction {

		NewAction() {
			super(newAction);
		}

		NewAction(String nm) {
			super(nm);
		}

		public void actionPerformed(ActionEvent e) {
			Document oldDoc = getEditor().getDocument();
			if(oldDoc != null)
				oldDoc.removeUndoableEditListener(undoHandler);
			getEditor().setDocument(new PlainDocument());
			getEditor().getDocument().addUndoableEditListener(undoHandler);
			resetUndoManager();
			revalidate();
		}
	}
	
	class SaveAction extends AbstractAction {
		
		SaveAction() {
			super(saveAction);
		}
		
		SaveAction(String nm) {
			super(nm);
		}
		
		public void actionPerformed(ActionEvent e) {
			
			try {
				PrintWriter out = new PrintWriter (new FileWriter(f));
				out.print (editor.getText());
				out.close();
			} catch (IOException ex) {
				JOptionPane.showMessageDialog(null, "Could not save the file " + ex.getMessage());
			}
			
			revalidate();
		}
	}

	class CompileAction extends AbstractAction {
		
		CompileAction() {
			super(compileAction);
		}
		
		CompileAction(String nm) {
			super(nm);
		}
		
		public void actionPerformed(ActionEvent e) {
			try {
				StringTokenizer st = new StringTokenizer(file, ".");
				st.nextToken();
				if (!st.hasMoreTokens()) {
					Error("Only files with the following extensions are accepted: LALP/ALPG");
				}
				String extension = st.nextToken().toUpperCase();
				if (extension.equals("LALP")) {
					System.out.print("Reading from file " + file + "...");
					FileInputStream inStream = new FileInputStream(directory + file);
					lp = new LangParser(inStream);
					System.out.println("Ok!");
					//DEBUG
//					lp.dump();
					lp.createComponents();
					design = lp.getDesign();
					System.out.print("Connecting hardware components...");
					lp.getRoot().connectComponents();
					if (SimpleNode.allComponents.containsKey("init")) {
						lp.getParser().design.setInit(SimpleNode.allComponents.get("init"));
					}
					lp.getRoot().reset();
					System.out.println("Ok!");
				}
				else if (extension.equals("ALPG")) {
					System.out.print("Reading from file " + file + "...");
					FileInputStream inStream = new FileInputStream(directory + file);
					GraphParser gp = new GraphParser(inStream);
					design = gp.getDesign();
					System.out.println("Ok!");
				}
				else {
					Error("Only .ALP or .ALPG files are accepted!");
				}
			} catch (FileNotFoundException ex) {
				Error("File " + file + " not found.");
			} catch (Exception ex) {
				ex.printStackTrace();
				System.exit(1);
			}
			
			if (Parameters.runScc) {
				StrongConnectedComponents scc = new StrongConnectedComponents(); 
				scc.detectStrongConnectedComponents(design);
			}
			
			if (Parameters.runDijkstra) {
				Dijkstra dijkstra = new Dijkstra();
				dijkstra.detectBigestCycle(design);
			}
			
			if (Parameters.runDominators) {
				Dominators dom = new Dominators();
				dom.detectBackwardEdges(design);
				dom.generateReport(design);
			}
			
			if (Parameters.runAsapAlap) {
				Scheduling aa = new Scheduling(design);
				aa.ALAP(design);
			}
			
			if (Parameters.graphviz) {
				Graphviz dot = new Graphviz();
				if (Parameters.runScc)
					dot.setSccLevels(true);
				if (Parameters.runAsapAlap)
					dot.setSchedulingTimes(true);
//				dot.setRank(true);
//				dot.setDominator(true);
				dot.generateSoftwareVisualization(design, directory);
//				dot.generateHardwareVisualization(design);
				if (Parameters.graphvizSubgraphs)
					dot.generateSCCSubgraphs(design);
				Runtime runtime = Runtime.getRuntime();
	            try {
	            	String cmd = "/usr/local/bin/dot -Tpng -o " + System.getProperty("java.io.tmpdir")+"graph.png " + dot.getFileName();
					runtime.exec(cmd, null, new File(directory));
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try {
					Thread.sleep(500);
				} catch (InterruptedException e1) {
					e1.printStackTrace();
				}
				ImageIcon img = new ImageIcon(System.getProperty("java.io.tmpdir")+"graph.png");
				img.getImage().flush();
				graph = new JScrollPane(new JLabel(img));
				splitPane.setRightComponent(graph);
				splitPane.revalidate();
			}
			
			if (Parameters.debugOutputs) {
				try {
					design.generateDebugOutputs();
				} catch (Exception ex) {
					ex.printStackTrace();
					System.exit(1);
				}
			}
			
			if (Parameters.vhdl) {
				VHDL vhd = new VHDL();
				String path =  directory + System.getProperty("file.separator") + "vdh";
				(new File(path)).mkdir();
				vhd.generateVHDL(design, path);
				if (Parameters.vhdlMemory)
					vhd.generateVHDLInitialization(design, path);
				if (Parameters.vhdlTestbench)
					vhd.generateVHDLTestbench(lp, path);
			}
			
			if (Parameters.alpg) {
				String path =  directory + System.getProperty("file.separator") + "alpg";
				(new File(path)).mkdir();
				ALPG alpg = new ALPG();
				alpg.generateALPG(design, path);
			}
			
			revalidate();
		}
	}

	/**
	 * Really lame implementation of an exit command
	 */
	class ExitAction extends AbstractAction {

		ExitAction() {
			super(exitAction);
		}

		public void actionPerformed(ActionEvent e) {
			System.exit(0);
		}

		/**
		 * Action that brings up a JFrame with a JTree showing the structure
		 * of the document.
		 */

	}

	/**
	 * Thread to load a file into the text storage model
	 */
	class FileLoader extends Thread {

		FileLoader(File f, Document doc) {
			setPriority(4);
			this.f = f;
			this.doc = doc;
		}

		public void run() {
			try {
				// try to start reading
				Reader in = new FileReader(f);
				char[] buff = new char[4096];
				int nch;
				while ((nch = in.read(buff, 0, buff.length)) != -1) {
					doc.insertString(doc.getLength(), new String(buff, 0, nch), null);
				}
				doc.addUndoableEditListener(undoHandler);
				resetUndoManager();
			}
			catch (IOException e) {
				System.err.println(e.toString());
			}
			catch (BadLocationException e) {
				System.err.println(e.getMessage());
			}
		}

		Document doc;
		File f;
	}
}
