/* Copyright (c) 2009 Ricardo Menotti, All Rights Reserved.
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

package lalp.core;

import java.io.DataOutputStream;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import lalp.algorithms.DepthFirstSearch;
import lalp.algorithms.Dijkstra;
import lalp.algorithms.Dominators;
import lalp.components.output;


import edu.uci.ics.jung.graph.impl.SparseVertex;

/**
 * An implementation of <code>ComponentInterface</code>.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version January, 2009
 * 
 * @see Design
 * @see IComponent
 * @see IOComponent
 */
//// Use this piece of code to instantiate Component objects and connect them
//public abstract class Component extends SparseVertex implements ComponentInterface {
public class Component extends SparseVertex implements ComponentInterface {

	protected Port defaultInput;
	protected Port defaultOutput;
	protected int delay = 1;
	protected String name;
	protected boolean sync = true;
	protected boolean userSync = false;
	protected int time = -1;
	protected boolean visited = false;
	protected int width = 1;
	protected int line = 0;
	/**
	 * @see Dijkstra
	 */
	protected int distance = Integer.MAX_VALUE;
	protected Component previous = null; 
	/**
	 * @see DepthFirstSearch
	 */
	protected int dfsStatus = DepthFirstSearch.WHITE;
	/**
	 * @see Dominators
	 */
	public Set<Component> dominators = null;
	public int domStatus = Dominators.WHITE;
	public int level = 0;
	public Component idom = null;
	/**
	 * @see Scheduling
	 */
	protected int alap = 0;
	protected int asap = 0;
		
	public Component() {
		super();
		this.name = "c" + super.id;
	}
	public Component(int width) {
		this();
		this.width = width;
	}
	public Component(String name) {
		this();
		this.name = name;
	}
	public Component(String name, int width) {
		this();
		this.name = name;
		this.width = width;
	}
	public Signal connectComponent(Component c) throws Exception {
		// Use this piece of code to instantiate Component objects and connect them
		Signal s = null;
		if ((this.getClass() == Component.class) && (c.getClass() == Component.class)) {
			s = this.getDesign().addSignal(new Signal(this, c));
			return s;
		}
		
		Port dest = c.getDefaultInput();
		if (dest == null) {
			throw new Exception("Can't connect component " + c.getFullName() + ". No default input");
		}
		else
			return connectComponent(dest);
	}
	public Signal connectComponent(Component c, String destPort) throws Exception {
		Port dest = ((IComponent)c).getPort(destPort);
		if (dest == null)
			throw new Exception("Can't connect component " + c.getFullName() + ". Port "+destPort+" not found");
		else
			return connectComponent(dest);
	}
	public Signal connectComponent(Port dest) throws Exception {
		Port source = getDefaultOutput();
		if (source == null)
			throw new Exception("Can't connect component " + dest.getComponent().getFullName() + ". No default output");
		else
			return connectComponent(source, dest);
	}
	public Signal connectComponent(Port source, Port dest) throws Exception {
		Signal s = getDesign().addSignal(new Signal(source.getComponent(), dest.getComponent()));
		if (source.getType() != PortType.INPUT) {
			s.connectPort(source);
		}
		else {
			throw new Exception("Can't connect component " + source.getComponent().getFullName() + ". Source is an input");
		}
		if (dest.getType() == PortType.INPUT) {
			s.connectPort(dest);
		}
		else {
			throw new Exception("Can't connect component " + dest.getComponent().getFullName() + ". Destination isn't an input");
		}
//		DEBUG print connections between components with port names
//		System.out.println(source.getComponent()+"."+source+" -> "+dest.getComponent()+"."+dest);
		return s;
	}
	public Signal connectComponent(String sourcePort, Component c) throws Exception {
		Port source = ((IComponent)this).getPort(sourcePort);
		Port dest = c.getDefaultInput();
		if ((source == null) || (dest == null))
			throw new Exception("Can't connect component " + c.getFullName() + ". Source port not found or no default input");
		else
			return connectComponent(source, dest);
	}
	public Signal connectComponent(String sourcePort, Component c, String destPort) throws Exception {
		Port source = ((IComponent)this).getPort(sourcePort);
		Port dest = ((IComponent)c).getPort(destPort);
		if (source == null) {
			throw new Exception("Can't connect component " + c.getFullName() + ". Port " + sourcePort + " not found");
		}
		else if (dest == null) {
			throw new Exception("Can't connect component " + c.getFullName() + ". Port " + destPort + " not found");			
		}
		else
			return connectComponent(source, dest);
	}
	public Signal connectComponent(String sourcePort, Port dest) throws Exception {
		Port source = ((IComponent)this).getPort(sourcePort);
		if (source == null)
			throw new Exception("Can't connect component " + dest.getComponent().getFullName() + ". Port " + sourcePort + " not found");
		else
			return connectComponent(source, dest);
	}
	public void connectComponentI0I1(Component cI0, Component cI1)  throws Exception {
		cI0.connectComponent(this, "I0");
		cI1.connectComponent(this, "I1");
	}
	public void copySchedulingTimes() {
		this.alap = this.asap;
	}
	/**
	 * Generate debug for default output
	 * @throws Exception
	 */
	public void debugOutput() throws Exception {
		output out;
		if (getDefaultOutput().getDataType() == VHDLType.STD_LOGIC)
			out = new output("d_" + getName());
		else
			out = new output("d_" + getName(), getDefaultOutput().getWidth());
		connectComponent(getDesign().addComponent(out));
	}
	/**
	 * Generate debug output
	 * @param port
	 * @throws Exception
	 */
	public void debugOutput(String port) throws Exception {
		output out;
		if (((IComponent)this).getPort(port).getDataType() == VHDLType.STD_LOGIC)
			out = new output("d_" + getName() + "_" + port);
		else
			out = new output("d_" + getName() + "_" + port, ((IComponent)this).getPort(port).getWidth());
		connectComponent(port, getDesign().addComponent(out));
	}
	public void generateInitialization(DataOutputStream dataOut) throws IOException, Exception {
		return;
	}
	public int getALAP() {
		return alap;
	}
	public int getASAP() {
		return asap;
	}
	public Port getDefaultInput() {
		return defaultInput;
	}
	public Port getDefaultOutput() {
		return defaultOutput;
	}
	public int getDelay() {
		return delay;
	}
	public Design getDesign() {
		return (Design)super.getGraph();
	}
	public int getDistance() {
		return distance;
	}
	/**
	 * @return The component class and instance name in the "class:name" format
	 */
	public String getFullName() {
		return this.getClass().getSimpleName() + ":" + name;
	}
	public String getName() {
		return name;
	}
	public String getNodeName() {
		return getFullName();
	}
	public String getDotName() {
		return name;
	}
//	public Set<Port> getPorts() {
//		return null;
//	}
	public Set<Component> getPredecessors() {
		Set<Component> predecessors = new HashSet<Component>();
		for (Object e : this.getIncidentEdges()) {
			Signal s = (Signal)e;
			if ((s.getDest().equals(this))&&(!s.isBackEdge()))
				predecessors.add((Component)s.getSource());
		}
		return predecessors;
	}
	public Set<Component> getAllPredecessors() {
		Set<Component> predecessors = new HashSet<Component>();
		for (Object e : this.getIncidentEdges()) {
			Signal s = (Signal)e;
			if (s.getDest().equals(this))
				predecessors.add((Component)s.getSource());
		}
		return predecessors;
	}
	public Set<Component> getSuccessors() {
		Set<Component> successors = new HashSet<Component>();
		for (Object e : this.getOutEdges()) {
			Signal s = (Signal)e;
			if ((s.getSource().equals(this))&&(!s.isBackEdge()))
				successors.add((Component)s.getDest());
		}
		return successors;
	}
	public boolean getSync() {
		return sync;
	}
	public boolean getUserSync() {
		return userSync;
	}
	public int getTime() {
		return time;
	}
	public int getWidth() {
		return width;
	}
	public boolean isIComponent() {
		return false;
	}
	public boolean isIOComponent() {
		return false;
	}
	public boolean isVHDLInitializable() {
		return false;
	}
	public boolean isVisited() {
		return visited;
	}
	public void resetDistance() {
		this.distance = Integer.MAX_VALUE;
	}
	public void resetSchedulingTimes() {
		this.asap = 0;
		this.alap = 0;
	}
	public void resetTime() {
		this.time = -1;
	}
	public void setALAP(int alap) {
		this.alap = alap;
	}
	public void setASAP(int asap) {
		this.asap = asap;
	}
	public void setDelay(int delay) {
		this.delay = delay;
	}
	public void setDistance(int distance) {
		this.distance = distance;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setSync(boolean sync) {
		this.sync = sync;
		if (!sync)
			setDelay(0);
	}
	public void setUserSync(boolean userSync) {
		this.userSync = userSync;
	}
	public void setTime(int time) {
		this.time = time;
	}
	public void setVisited(boolean visited) {
		this.visited = visited;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public String toString() {
		return getFullName();
	}
	public void setDFS(int status) {
		this.dfsStatus = status;
	}
	public int getDFS() {
		return dfsStatus;
	}
	public Component getPrevious() {
		return previous;
	}
	public void setPrevious(Component previous) {
		this.previous = previous;
	}
	public void setInitialValue(int jjtGetValue) {
		System.out.println("Oops!");
	}
	public void setInitialValue(long jjtGetValue) {
		System.out.println("Oops!");
	}
	public void setLine(int line) {
		this.line = line;
	}
	public int getLine() {
		return line;
	}
	//TODO searching Depth-first, change to Breadth-first  
	public int getSuccessorsLine() {
		for (Component c : this.getSuccessors())
			if (c.getLine() > 0)
				return c.getLine();
			else
				return c.getSuccessorsLine();
		return 0;
	}
}
