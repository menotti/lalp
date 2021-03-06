/* Generated By:JJTree: Do not edit this line. SimpleNode.java Version 4.1 */
/* JavaCCOptions:MULTI=false,NODE_USES_PARSER=false,VISITOR=false,TRACK_TOKENS=false,NODE_PREFIX=AST,NODE_EXTENDS=,NODE_FACTORY=,SUPPORT_CLASS_VISIBILITY_PUBLIC=true */

package br.ufscar.dc.lalp.parser.lang;

import java.util.*;

import br.ufscar.dc.lalp.components.*;
import br.ufscar.dc.lalp.core.*;

@SuppressWarnings("unchecked")
public class SimpleNode implements Node {

	protected Node parent;
	protected Node[] children;
	public int id;
	protected Object value; // Const/Variable/Literal
	protected ALPParser parser;
	// custom attributes
	protected String identifier = null; // Start/Name/Const/Typedef/Pin/Variable/Counter
	protected String port = null; // Name
	protected Integer arraySize = null; // Variable
	protected Integer width = null; // Typedef/Pin/Variable
	protected Integer stepDelay = null; // Counter/Delay
	protected Integer endStepDelay = null;
	@SuppressWarnings("rawtypes")
	protected Class componentClass = null; // Pin/Expression(s)/LHS
	protected PortType portType = null; // Pin
	protected Token token = null; // Variable
	protected Vector<Long> inits = null; // Variable (Memory initialization)
	// Counter attributes
	protected Object counterLoad = null; // const or component name
	protected String counterIncrementOperation = null; // ++ -- += -=
	protected Integer counterIncrement = null;
	protected String counterTerminationCondition = null; // < <= > >= == !=
	protected Object counterTermination = null;
	protected boolean counterDown = false;
	// Float and Fixed
	protected boolean floatNumber = false; // The node or any of its children
											// has a floating-point
											// number/operation
	protected boolean fixedNumber = false;
	protected Integer fixedIntSize = 16; // Number of bits for Integer part
	protected Integer fixedDecSize = 16; // Number of bits for Decimal part
	// used?
	protected Component component = null;
	protected Connections connections = null;

	public static Vector<SimpleNode> allOperations = new Vector<SimpleNode>();
	public static Hashtable<String, Vector<SimpleNode>> allAccess = new Hashtable<String, Vector<SimpleNode>>();
	public static Hashtable<String, Component> allComponents = new Hashtable<String, Component>();

	public void reset() {
		allOperations = new Vector<SimpleNode>();
		allAccess = new Hashtable<String, Vector<SimpleNode>>();
		allComponents = new Hashtable<String, Component>();
	}

	public SimpleNode(int i) {
		id = i;
	}

	public SimpleNode(ALPParser p, int i) {
		this(i);
		parser = p;
	}

	public void jjtOpen() {
	}

	public void jjtClose() {
	}

	public void jjtSetParent(Node n) {
		parent = n;
	}

	public Node jjtGetParent() {
		return parent;
	}

	public void jjtAddChild(Node n, int i) {
		if (children == null) {
			children = new Node[i + 1];
		} else if (i >= children.length) {
			Node c[] = new Node[i + 1];
			System.arraycopy(children, 0, c, 0, children.length);
			children = c;
		}
		children[i] = n;
	}

	public Node jjtGetChild(int i) {
		return children[i];
	}

	public int jjtGetNumChildren() {
		return (children == null) ? 0 : children.length;
	}

	public void jjtSetValue(Object value) {
		this.value = value;
	}

	public Object jjtGetValue() {
		return value;
	}

	/*
	 * You can override these two methods in subclasses of SimpleNode to
	 * customize the way the node appears when the tree is dumped. If your
	 * output uses more than one line you should override toString(String),
	 * otherwise overriding toString() is probably all you need to do.
	 */

	public String toString() {
		StringBuffer sb = new StringBuffer(
				ALPParserTreeConstants.jjtNodeName[id]);
		if (getComponentClass() != null) {
			sb.append(":" + getComponentClass());
		}
		if (getIdentifier() != null) {
			sb.append(":" + getIdentifier());
		}
		if (getPort() != null) {
			sb.append("." + getPort());
		}
		if (getWidth() != null) {
			sb.append("<" + getWidth() + ">");
		}
		if (getArraySize() != null) {
			sb.append("[" + getArraySize() + "]");
		}
		if (jjtGetValue() != null) {
			sb.append("=" + jjtGetValue());
		}
		if (getInits() != null) {
			sb.append("=" + getInits());
		}
		if (getPortType() != null) {
			sb.append(":" + getPortType());
		}
		if (this.id == ALPParserTreeConstants.JJTCOUNTER) {
			sb.append("=" + getLoad() + "; ");
			sb.append(getIdentifier() + getTermCond() + getTerm() + "; ");
			sb.append(getIdentifier() + getIncOper()
					+ (getInc() != null ? getInc() : ""));
		}
		if (getStepDelay() != null) {
			sb.append("@" + getStepDelay());
		}

		sb.append((isFloat() ? "(float)" : ""));// FIXME: Debug

		return sb.toString();
	}

	public String toString(String prefix) {
		return prefix + toString();
	}

	/*
	 * Override this method if you want to customize how the node dumps out its
	 * children.
	 */

	public void dump(String prefix) {
		System.out.println(toString(prefix));
		if (children != null) {
			for (int i = 0; i < children.length; ++i) {
				SimpleNode n = (SimpleNode) children[i];
				if (n != null) {
					n.dump(prefix + ".");
				}
			}
		}
	}

	public void dumpConnections(String prefix) {
		Connections conn = getConnections();
		if (conn != null && conn.getOwner() == this) {
			System.out.println(toString(prefix));
			if (conn.getFirst() != null) {
				System.out.println(conn.getFirst().toString(prefix + "1"));
			}
			if (conn.getSecond() != null) {
				System.out.println(conn.getSecond().toString(prefix + "2"));
			}
			if (conn.getThird() != null) {
				System.out.println(conn.getThird().toString(prefix + "3"));
			}
			if (conn.getFourth() != null) {
				System.out.println(conn.getFourth().toString(prefix + "4"));
			}
		}

		if (children != null) {
			for (int i = 0; i < children.length; ++i) {
				SimpleNode n = (SimpleNode) children[i];
				if (n != null) {
					n.dumpConnections(prefix + ".");
				}
			}
		}
	}

	public Integer getArraySize() {
		return arraySize;
	}

	public void setArraySize(Integer arraySize) {
		this.arraySize = arraySize;
	}

	public String getPort() {
		return port;
	}

	public void setPort(String port) {
		this.port = port;
	}

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	public Integer getWidth() {
		if (width != null) {
			return width;
		} else if (this.id == ALPParserTreeConstants.JJTASSIGNMENT) {
			return getConnections().getFirst().getWidth();
		} else if (this.id == ALPParserTreeConstants.JJTLHS) {
			if (parser.allVariables.containsKey(getIdentifier()))
				return parser.allVariables.get(getIdentifier()).getWidth();
			else if (parser.allPins.containsKey(getIdentifier()))
				return parser.allPins.get(getIdentifier()).getWidth();
			else
				return null;
		} else
			return null;
	}

	public void setWidth(Integer width) {
		this.width = width;
	}

	public String getIncOper() {
		return counterIncrementOperation;
	}

	public void setIncOper(String incOper) {
		this.counterIncrementOperation = incOper;
	}

	public String getTermCond() {
		return counterTerminationCondition;
	}

	public void setTermCond(String termCond) {
		this.counterTerminationCondition = termCond;
	}

	public Object getLoad() {
		return counterLoad;
	}

	public void setLoad(Object load) {
		this.counterLoad = load;
	}

	public Integer getInc() {
		return counterIncrement;
	}

	public void setInc(Integer inc) {
		this.counterIncrement = inc;
	}

	public Object getTerm() {
		return counterTermination;
	}

	public void setTerm(Object term) {
		this.counterTermination = term;
	}

	public Integer getStepDelay() {
		return stepDelay;
	}

	public void setStepDelay(Integer delay) {
		this.stepDelay = delay;
	}

	@SuppressWarnings("rawtypes")
	public Class getComponentClass() {
		return componentClass;
	}

	@SuppressWarnings("rawtypes")
	public void setComponentClass(Class cc) {
		this.componentClass = cc;
	}

	/**
	 * 
	 * @return
	 */
	public Component getComponent() {
		if (this.component != null) {
			return component;
		} else if (this.getIdentifier() != null
				&& allComponents.containsKey(this.getIdentifier())) {
			return allComponents.get(this.getIdentifier());
		}
		return null;
	}

	public void setComponent(Component comp) {
		this.component = comp;
	}

	public Connections getConnections() {
		return connections;
	}

	public void setConnections(Connections connections) {
		this.connections = connections;
	}

	public PortType getPortType() {
		return portType;
	}

	public void setPortType(PortType portType) {
		this.portType = portType;
	}

	public boolean isCounterDown() {
		return counterDown;
	}

	public void setCounterDown(boolean counterDown) {
		this.counterDown = counterDown;
	}

	public Token getToken() {
		return token;
	}

	public void setToken(Token token) {
		this.token = token;
	}

	public Vector<Long> getInits() {
		return inits;
	}

	public void setInits(Vector<Long> inits) {
		this.inits = inits;
	}

	public boolean hasChildFloat() {
		Integer n_children = jjtGetNumChildren();

		if (n_children > 0) {
			for (int i = 0; i < n_children; i++) {
				SimpleNode child = (SimpleNode) children[i];

				if (child.hasChildFloat()) {
					floatNumber = true;
					return floatNumber;
				}
			}
		}
		return floatNumber;
	}

	/**
	 * This method is used to set floatNumber for all nodes that have a
	 * floating-point number This method is recursive!
	 * */

	public void updateFloat() {
		Integer n_children = jjtGetNumChildren();

		hasChildFloat();

		if (n_children > 0) {
			for (int i = 0; i < n_children; i++) {
				SimpleNode child = (SimpleNode) jjtGetChild(i);
				child.updateFloat();
			}
		}
	}

	/**
	 * This method is used to replace default Integer operators by
	 * Floating-point operators. This method is recursive!
	 * */

	public void updateOperators() {
		Integer n_children = jjtGetNumChildren();

		if (getComponentClass() != null) {

			if (this.floatNumber) {
				System.out.println("\nFound a floating-point operation.");
				System.out.println("Replacing " + getComponentClass());

				if (getComponentClass() == add_op_s.class) {
					this.setComponentClass(add_op_fl.class);
				} else if (getComponentClass() == sub_op_s.class) {
					this.setComponentClass(sub_op_fl.class);
				} else if (getComponentClass() == mult_op_s.class) {
					this.setComponentClass(mult_op_fl.class);
				} else if (getComponentClass() == div_op_s.class) {
					this.setComponentClass(div_op_fl.class);
				}
			}
		}
		/*
		 * if(getIdentifier()=="+="){ if(this.floatNumber){
		 * System.out.println("\nFound a floating-point operation.");
		 * System.out.println("Replacing operator " + getIdentifier());
		 * this.setComponentClass(add_reg_op_fl.class); } }
		 */
		if (n_children > 0) {

			for (int i = 0; i < n_children; i++) {
				SimpleNode child = (SimpleNode) jjtGetChild(i);
				child.updateOperators();
			}
		}
	}

	/**
	 * Update connections between nodes, eliminating nodes without operations
	 * and naming others. This method is recursive!
	 */
	public void updateConnections() {
		if (this.id == ALPParserTreeConstants.JJTASSIGNMENT
				|| getComponentClass() != null) {
			setConnections(new Connections(this));
			if (((SimpleNode) parent).getConnections() != null) {
				getConnections().setParent(
						((SimpleNode) parent).getConnections().getOwner());
				if (((SimpleNode) parent).getConnections().getFirst() == null) {
					((SimpleNode) parent).getConnections().setFirst(this);
				} else if (((SimpleNode) parent).getConnections().getSecond() == null) {
					((SimpleNode) parent).getConnections().setSecond(this);
				} else if (((SimpleNode) parent).getConnections().getThird() == null) {
					((SimpleNode) parent).getConnections().setThird(this);
				} else if (((SimpleNode) parent).getConnections().getFourth() == null) {
					((SimpleNode) parent).getConnections().setFourth(this);
				} else if (((SimpleNode) parent).getConnections().getFifth() == null) {
					((SimpleNode) parent).getConnections().setFifth(this);
				} else {
					System.out.println("Too many connections in parent!");
					System.exit(1);
				}
			}
		} else {
			if (this.id != ALPParserTreeConstants.JJTSTART) {
				setConnections(((SimpleNode) parent).getConnections());
			}
		}
		if (children != null) {
			for (int i = 0; i < children.length; ++i) {
				SimpleNode n = (SimpleNode) children[i];
				if (n != null) {
					n.updateConnections();
				}
			}
		} else {
			if (getConnections() != null) {
				if (getConnections().getFirst() == null) {
					getConnections().setFirst(this);
				} else if (getConnections().getSecond() == null) {
					getConnections().setSecond(this);
				} else if (getConnections().getThird() == null) {
					getConnections().setThird(this);
				} else if (getConnections().getFourth() == null) {
					getConnections().setFourth(this);
				} else if (getConnections().getFifth() == null) {
					getConnections().setFifth(this);
				} else {
					System.out.println("Too many connections!");
					System.exit(1);
				}
			}
		}
		// name components on expressions
		if (getConnections() != null && getConnections().getOwner() == this) { // it's
																				// a
																				// connections
																				// point
			if (getComponentClass() != null && getIdentifier() == null) { // expression
																			// operation
				if (id == ALPParserTreeConstants.JJTCONDITIONALEXPRESSION
						&& getConnections().getParent().id == ALPParserTreeConstants.JJTASSIGNMENT) {
					setIdentifier(getConnections().getParent().getConnections()
							.getFirst().getIdentifier());
					allOperations.add(this);
				} else {
					SimpleNode first = getConnections().getFirst();
					SimpleNode second = getConnections().getSecond();
					// use component name
					String identifier = getComponentClass().getName();
					int pos = identifier.lastIndexOf(".");
					identifier = identifier.substring(pos + 1,
							identifier.length());
					// use 1st operand identifier[.port] or value
					String name = (first.getIdentifier() != null ? first
							.getIdentifier() : first.jjtGetValue().toString());
					if (first.getPort() != null) {
						name = name + "_" + first.getPort();
					}
					name = name + "_" + identifier;
					// use 1st operand identifier[.port] or value
					if (second != null) {
						name = name
								+ "_"
								+ (second.getIdentifier() != null ? second
										.getIdentifier() : second.jjtGetValue()
										.toString());
						if (second.getPort() != null) {
							name = name + "_" + second.getPort();
						}
					}
					// use amount in case of delay and shift operations
					if (getStepDelay() != null) {
						name = name + "_" + getStepDelay();
					}
					while (allOperations.contains(name)) {
						name = "_" + name;
					}
					setIdentifier(name);
					allOperations.add(this);
				}
			}
		}
	}

	/**
	 * Generates a Vector with each access of a LHS() This method is recursive!
	 */
	public void accessComponents() {
		if (this.id == ALPParserTreeConstants.JJTLHS
				|| this.id == ALPParserTreeConstants.JJTNAME
				|| this.id == ALPParserTreeConstants.JJTCOUNTER) {
			if (!allAccess.containsKey(getIdentifier())) {
				allAccess.put(getIdentifier(), new Vector<SimpleNode>());
			}
			allAccess.get(getIdentifier()).add(this);
		}
		if (children != null) {
			for (int i = 0; i < children.length; ++i) {
				SimpleNode n = (SimpleNode) children[i];
				if (n != null) {
					n.accessComponents();
				}
			}
		}
	}

	/**
	 * Connect components recursively
	 */
	public void connectComponents() {

		if (children != null) {
			for (int i = 0; i < children.length; ++i) {
				SimpleNode n = (SimpleNode) children[i];
				if (n != null) {
					n.connectComponents();
				}
			}
		}

		if (getConnections() != null && getConnections().getOwner() == this) { // connectable
																				// components
			try {
				if (this.id == ALPParserTreeConstants.JJTCOUNTER) {
					connectCounter();
				} else if (this.id == ALPParserTreeConstants.JJTDELAYEXPRESSION) {
					connectDelay();
				} else if (this.id == ALPParserTreeConstants.JJTCONDITIONALEXPRESSION) {
					connectConditional();
				} else if (this.id == ALPParserTreeConstants.JJTASSIGNMENT) {
					Component cTo = getConnections().getFirst().getComponent();
					if (getIdentifier().equals("=")) {
						if (cTo instanceof mux_m_op) {
							connectMux();
						} else if (getConnections().getSecond().id != ALPParserTreeConstants.JJTCONDITIONALEXPRESSION) {
							connectRegister();
						}
					} else {
						connectAccumulator();
					}
				} else {
					connectOthers();
				}
			} catch (Exception e) {
				e.printStackTrace();
				// System.exit(1);
			}
		}
	}

	private void connectAccumulator() {
		Component cFirst = getConnections().getFirst().getComponent();
		String cFirstPort = getConnections().getFirst().getPort();
		connectComponents(cFirst, cFirstPort, cFirst, "I0");
		if (getConnections().getSecond() != null) {
			Component cSecond = getConnections().getSecond().getComponent();
			String cSecondPort = getConnections().getSecond().getPort();
			if (cSecond == null) {
				cSecond = createConstant(getConnections().getSecond());
			}
			connectComponents(cSecond, cSecondPort, cFirst, "I1");
		}
		if (getConnections().getThird() != null) {
			Component cCond = getConnections().getThird().getComponent();
			String cCondPort = getConnections().getThird().getPort();
			connectComponents(cCond, cCondPort, cFirst, "we");
		}
	}

	private void connectOthers() {
		Component cTo = getComponent();
		Component cFirst = getConnections().getFirst().getComponent();
		String cFirstPort = getConnections().getFirst().getPort();
		if (cFirst == null) {
			cFirst = createConstant(getConnections().getFirst());
		}
		connectComponents(cFirst, cFirstPort, cTo, "I0");
		if (getConnections().getSecond() != null) {
			Component cSecond = getConnections().getSecond().getComponent();
			String cSecondPort = getConnections().getSecond().getPort();
			if (cSecond == null) {
				cSecond = createConstant(getConnections().getSecond());
			}
			connectComponents(cSecond, cSecondPort, cTo, "I1");
		}
		if (getConnections().getThird() != null) {
			Component cCond = getConnections().getThird().getComponent();
			String cCondPort = getConnections().getThird().getPort();
			connectComponents(cCond, cCondPort, cTo, "we");
		}
	}

	private void connectConditional() throws Exception {
		Component cFirst = getConnections().getSecond().getComponent();
		String cFirstPort = getConnections().getSecond().getPort();
		if (cFirst == null) {
			cFirst = createConstant(getConnections().getSecond());
		}
		Component cSecond = getConnections().getThird().getComponent();
		String cSecondPort = getConnections().getThird().getPort();
		if (cSecond == null) {
			cSecond = createConstant(getConnections().getThird());
		}
		connectComponents(getConnections().getFirst().getComponent(),
				getConnections().getFirst().getPort(), getComponent(), "Sel1");
		connectComponents(cFirst, cFirstPort, getComponent(), "I1");
		connectComponents(cSecond, cSecondPort, getComponent(), "I0");
		if (getConnections().getParent().id == ALPParserTreeConstants.JJTASSIGNMENT) {
			if (getConnections().getParent().getConnections().getThird() != null) {
				Component cCond = getConnections().getParent().getConnections()
						.getThird().getComponent();
				String cCondPort = getConnections().getParent()
						.getConnections().getThird().getPort();
				connectComponents(cCond, cCondPort, getComponent(), "we");
			}
		}
	}

	private void connectRegister() {
		Component cTo = getConnections().getFirst().getComponent();
		String cToPort = getConnections().getFirst().getPort();

		Component cFrom = getConnections().getSecond().getComponent();
		String cFromPort = getConnections().getSecond().getPort();
		if (cFrom == null) {
			cFrom = createConstant(getConnections().getSecond());
		}
		connectComponents(cFrom, cFromPort, cTo, cToPort);
		if (getConnections().getThird() != null) {
			Component cCond = getConnections().getThird().getComponent();
			String cCondPort = getConnections().getThird().getPort();
			cTo.setUserSync(true);
			if (cToPort != null && cToPort.equals("address"))
				connectComponents(cCond, cCondPort, cTo, "oe");
			else
				connectComponents(cCond, cCondPort, cTo, "we");
		}
	}

	private void connectMux() {
		Component cFrom = null;
		Component cTo = getConnections().getFirst().getComponent();
		String cFromPort = null, cToPort = "I0";
		if (getConnections().getSecond().id == ALPParserTreeConstants.JJTLITERAL) {
			int width = cTo.getWidth();
			cFrom = parser.design.addComponent(new const_op(new Integer(
					getConnections().getSecond().jjtGetValue().toString()),
					width));
		} else {
			cFrom = getConnections().getSecond().getComponent();
			cFromPort = getConnections().getSecond().getPort();
		}
		connectComponents(cFrom, cFromPort, cTo, cToPort);
		if (getConnections().getThird() != null) {
			Component cCond = getConnections().getThird().getComponent();
			String cCondPort = getConnections().getThird().getPort();
			connectComponents(cCond, cCondPort, cTo, "Sel");
		}
	}

	private void connectDelay() {
		connectComponents(getConnections().getFirst().getComponent(),
				getConnections().getFirst().getPort(), this.getComponent(),
				null);
	}

	private void connectCounter() {
		if (getLoad() instanceof Integer) { // counter initialization with
											// literal
			Component c = new const_op((Integer) getLoad(), getWidth());
			c = parser.design.addComponent(c);
			connectComponents(c, null, getComponent(), "input");
		} else { // counter initialization with variable
			SimpleNode nl = (SimpleNode) getLoad();
			connectComponents(nl.getComponent(), nl.getPort(), getComponent(),
					"input");
		}
		if (getTerm() instanceof Integer) { // counter termination with literal
			Component c = new const_op((Integer) getTerm(), getWidth());
			c = parser.design.addComponent(c);
			connectComponents(c, null, getComponent(), "termination");
		} else { // counter termination with variable
			SimpleNode nl = (SimpleNode) getTerm();
			connectComponents(nl.getComponent(), nl.getPort(), getComponent(),
					"termination");
		}
	}

	/**
	 * Instantiate <code>Component</code> for constants and literals
	 * 
	 * @param n
	 * @return
	 */
	private Component createConstant(SimpleNode n) {
		Component c = null;
		if (n.id == ALPParserTreeConstants.JJTLITERAL) {
			c = parser.design.addComponent(new const_op((Long) n.value,
					getWidth()));
		} else {
			String name = n.getIdentifier();
			Integer width = parser.allConsts.get(name);
			c = parser.design
					.addComponent(new const_op(name, width, getWidth()));
		}
		return c;
	}

	/**
	 * Invokes the adequate method:
	 * <ul>
	 * <li>Component.connectComponent(String, Component, String)</li>
	 * <li>Component.connectComponent(Component, String)</li>
	 * <li>Component.connectComponent(String, Component)</li>
	 * <li>Component.connectComponent(Component)</li>
	 * </ul>
	 * 
	 * @param cFrom
	 * @param cFromPort
	 * @param cTo
	 * @param cToPort
	 */
	private void connectComponents(Component cFrom, String cFromPort,
			Component cTo, String cToPort) {
		try {
			if (cFromPort != null) {
				if (cToPort != null) {
					cFrom.connectComponent(cFromPort, cTo, cToPort);
				} else {
					cFrom.connectComponent(cFromPort, cTo);
				}
			} else {
				if (cToPort != null) {
					cFrom.connectComponent(cTo, cToPort);
				} else {
					cFrom.connectComponent(cTo);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			// System.exit(1);
		}
	}

	public Integer getEndStepDelay() {
		return endStepDelay;
	}

	public void setEndStepDelay(Integer endStepDelay) {
		this.endStepDelay = endStepDelay;
	}

	public boolean isFloat() {
		return floatNumber;
	}

	public void setFloatNumber(boolean b) {
		this.floatNumber = b;
	}

	public boolean isFixed() {
		return fixedNumber;
	}

	public void setFixedNumber(boolean b) {
		this.fixedNumber = b;
	}

	public Integer getFixedIntSize() {
		return fixedIntSize;
	}

	public void setFixedIntSize(Integer val) {
		this.fixedIntSize = val;
	}

	public Integer getFixedDecSize() {
		return fixedDecSize;
	}

	public void setFixedDecSize(Integer val) {
		this.fixedDecSize = val;
	}
}

/*
 * JavaCC - OriginalChecksum=13ec5256960ef4ed695df3f6102ae4e2 (do not edit this
 * line)
 */
