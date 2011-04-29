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

package lalp.algorithms;

import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.Vector;

import lalp.LALP;
import lalp.components.block_ram;
import lalp.components.counter;
import lalp.components.delay_op;
import lalp.components.mux_m_op;
import lalp.core.Component;
import lalp.core.Design;
import lalp.core.IComponent;
import lalp.core.IOComponent;
import lalp.core.Parameters;
import lalp.core.Signal;
import lalp.parser.LangParser;



/**  
 * Scheduling algorithms
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version March, 2010
 */
public class Scheduling {

	/**
	 * @see #Scheduling(Design)
	 */
	protected TreeMap<Integer, Component> components = new TreeMap<Integer, Component>();
	
	/**
	 * This constructor creates a {@link TreeMap} of components ordered by line attribution in source code
	 * @param design
	 */
	public Scheduling(Design design) {
		for (Component c : design.getComponents()) {
			int line = c.getLine();
			if (c instanceof IComponent && line != 0)
				components.put(line, c);
		}
	}
	
	/**
	 * Try to detect backward edges based on source code
	 * @param design
	 * @param lp
	 */
	public void detectBackwardEdges(Design design, LangParser lp) {
		System.out.println("\nDetecting Backward Edges (Topological)...");
		ExecutionTimer t = new ExecutionTimer();
		t.start();
		for (Signal s : design.getSignals()) {
			Component source = (Component) s.getSource();
			Component dest = (Component) s.getDest();
			if (source.equals(dest)) { // self-connected component 
				s.setBackEdge(true);
				if (Parameters.verbose)
					LALP.info("signal " + source + " -> "+ dest + " marked as backedge (self-connected)"); 
			}
			else if (source.isSuccessorOf(dest)) { // self-connected components (pair)
				s.setBackEdge(true);
				if (Parameters.verbose)
					LALP.info("signal " + source + " -> "+ dest + " marked as backedge (self-connected pair)"); 
			}
			else {
				int sourceLine = source.getLine();
				if (sourceLine > 0 && dest instanceof IComponent) {
					int destLine = dest.getLine();
					if (destLine == 0)
						destLine = dest.getSuccessorsLine();
					if (sourceLine > destLine) { // defined after
						s.setBackEdge(true);
						if (Parameters.verbose)
							LALP.info("signal " + source + " -> "+ dest + " marked as backedge (source defined after destination in source code)"); 
					}
				}
			}
		}
	    t.end();
		System.out.println("Detecting Backward Edges (Topological)...Ok! " + t.duration() + " ms");
	}

	/**
	 * As Soon As Possible scheduling. Just for acyclic graphs
	 * @param design
	 */
	public int ASAP(Design design) {
		System.out.print("\nScheduling (ASAP)...");
		ExecutionTimer t = new ExecutionTimer();
		t.start();
		design.resetSchedulingTimes();
		boolean change = true;
		int max, pred;
		while (change) {
			change = false;
			for (Component dest : design.getComponents()) {
				max = pred = 0;
				if (Parameters.verbose)
					LALP.info("scheduling "+dest+" ASAP:" + dest.getASAP() + " line:" + dest.getLine());
				//all predecessors 
				for (Component source : (Set<Component>)dest.getPredecessors()) {
					pred = source.getASAP() + source.getDelay();
					if (pred > max) {
						max = pred;
						if (Parameters.verbose)
							LALP.info(" dependence "+source+" ASAP:" + source.getASAP() + " line:" + source.getLine());
					}
				}
				//all source code predecessors
				if (components.containsValue(dest)) {
					inner:for (Map.Entry<Integer, Component> me : components.entrySet()) {
						int line = me.getKey();
						Component source = me.getValue();
						if (line > dest.getLine()) {
							LALP.info(" break on "+source+" ASAP:" + source.getASAP() + " line:" + source.getLine());
							break inner;
						}
						pred = source.getASAP();
						if (pred > max) {
							max = pred;
							if (Parameters.verbose)
								LALP.info(" predecessor "+source+" ASAP:" + source.getASAP() + " line:" + source.getLine());
						}
					}
				}
				if (dest.getASAP() != max) {
					dest.setASAP(max);
					change = true;
					if (max > design.getMaxSchedulingTime())
						design.setMaxSchedulingTime(max);
				}
				//DEBUG: disable to debug
				if (t.execution() > 2000) {
					System.out.println("Failed! " + t.execution() + " ms. Time out!!!");
					return -1;
				}
			}
		}
	    t.end();
	    System.out.println("Ok! " + t.duration() + " ms");		
	    return 0;
	}
	/**
	 * As Late As Possible scheduling. Just for acyclic graphs
	 * @param design
	 */
	public int ALAP(Design design) {
		design.resetSchedulingTimes();
		if (ASAP(design) != 0)
			return -1;
		design.copySchedulingTimes();
		System.out.print("Scheduling (ALAP)...");
		ExecutionTimer t = new ExecutionTimer();
		t.start();
		boolean change = true;
		int min, succ;
		while (change) {
			change = false;
			for (Component n : design.getComponents()) {
				min = succ = design.getMaxSchedulingTime();
				for (Component s : (Set<Component>)n.getSuccessors()) {
					succ = s.getALAP() - n.getDelay();
					if (succ < min)
						min = succ;
				}
				if (n.getALAP() != min) {
					n.setALAP(min);
					change = true;
				}
				if (t.execution() > 2000) {
					System.out.println("Failed! " + t.execution() + " ms. Time out!!!");
					return -2;
				}
			}
		}
	    t.end();
	    System.out.println("Ok! " + t.duration() + " ms");	
	    return 0;
	}
	/**
	 * Balance and Synchronize operations by creating control signals and inserting delays between operations 
	 * @param design
	 */
	public void balanceAndSyncrhonize(Design design) {
		System.out.println("\nBalancing and synchronizing operations...");
		ExecutionTimer t = new ExecutionTimer();
		t.start();
		Component counter = null, firstCounter = null;
		int mii = 0, ats = 0;
		for (Map.Entry<Integer, Component> me : components.entrySet()) {
			Component c = me.getValue();
			if (c instanceof counter) {
				counter = c;
				if (firstCounter == null)
					firstCounter = counter;
				if (((counter)counter).getSteps() > mii)
					mii = ((counter)counter).getSteps();
				if (Parameters.verbose)
					LALP.info("using counter " + counter + " to syncronize operations");
				int counterSched = counter.getASAP();
				Signal s = counter.getDefaultOutput().getSignal();
				// iterate over all output signals
				while (s != null) {
					Component dest = (Component)s.getDest();
					if (dest instanceof block_ram && s.getDestPort().getName().equals("address")) {
						int distance = dest.getASAP() - counterSched;
						if (distance > 1) {
							s.insertDelay(distance-1).setASAP(counter.getASAP()+counter.getDelay());
							ats++;
							if (Parameters.verbose)
								LALP.info("inserting " + (distance-1) + " delay(s) on signal " + counter + " -> "+ dest + " (memory address)");
							String port = "we";
							if (((IComponent)dest).getPort("data_in").getSignal() == null && ((IComponent)dest).getPort("oe").getSignal() == null) {
								port = "oe";
							}
							Component delay = design.addComponent((Component)new delay_op(1, distance-1));
							delay.setASAP(counter.getASAP()+counter.getDelay());
							try {
								ats++;
								if (Parameters.verbose)
									LALP.info("inserting " + (distance-1) + " delay(s) on new signal " + counter + " -> "+ dest + " (memory " + port + ")");
								counter.connectComponent("step", delay);
								delay.connectComponent(dest, port);
							} catch (Exception e) {
								e.printStackTrace();
								System.exit(1);
							}
						}
					}
					s = s.getSignal();
				}
			} // after a counter, intermediate componente, has a we port and we is unconnected
			else if (counter != null && c instanceof IComponent && !(c instanceof block_ram) && ((IComponent)c).getPort("we") != null) {
				if (((IComponent)c).getPort("we").getSignal() == null) {
					int distance = c.getASAP() - counter.getASAP();
					if (distance > 1) {
						Component delay = design.addComponent((Component)new delay_op(1, distance-1));
						delay.setASAP(counter.getASAP()+counter.getDelay());
						try {
							ats++;
							if (Parameters.verbose)
								LALP.info("inserting " + (distance-1) + " delay(s) on new signal " + counter + " -> "+ c + " (write enable) " + delay);
							counter.connectComponent("step", delay);
							delay.connectComponent(c, "we");							
						} catch (Exception e) {
							e.printStackTrace();
							System.exit(1);
						}
					}
				}
				else {
					LALP.warning("port 'we' of component " + c + " is connected, please check if aditional synchronization is needed (when ... && "+counter.getName()+".step@N)");
				}
			}
		}
		
		Component init = design.getComponent("init");
		if (firstCounter != null && init != null && ((IOComponent)init).getPort().getSignal() == null) {
			try {
				init.connectComponent(firstCounter, "clk_en");
			} catch (Exception e) {
				e.printStackTrace();
				System.exit(1);			}
		}
		
		Component done = design.getComponent("done");
		if (counter != null && done != null && ((IOComponent)done).getPort().getSignal() == null) {
			int amount = design.getMaxSchedulingTime() - counter.getASAP() - 1;
			Component delay = design.addComponent((Component)new delay_op(1, amount));
			delay.setASAP(counter.getASAP()+counter.getDelay());
			try {
				ats++;
				if (Parameters.verbose)
					LALP.info("inserting " + amount + " delay(s) on new signal " + counter + " -> "+ done + " (termination)");
				counter.connectComponent("done", delay);
				delay.connectComponent(done);
			} catch (Exception e) {
				e.printStackTrace();
				System.exit(1);
			}
		}
		Vector<Signal> signals = new Vector<Signal>();
		for (Signal signal : design.getSignals()) {
			signals.add(signal);
		}
		for (Signal signal : signals) {
			Component source = (Component)signal.getSource();
			Component dest = (Component)signal.getDest();
			if (!(source instanceof delay_op || dest instanceof delay_op || source instanceof mux_m_op || dest instanceof mux_m_op || source instanceof IOComponent || dest instanceof IOComponent || dest.getUserSync())) {
				int sourceSched = calculateASAP(source);
				int destSched =  dest.getASAP();
				int distance = destSched - sourceSched;
				if (distance > 1) {
					ats++;
					if (Parameters.verbose)
						LALP.info("inserting " + distance + " delay(s) on signal " + source + " -> "+ dest + " (balance)");
					signal.insertDelay(distance);
				}
			}
		}
		for (Signal signal : signals) {
			if (signal.isBackEdge()) {
				Component source = (Component)signal.getSource();
				Component dest = (Component)signal.getDest();
				int sourceSched = source.getASAP() + source.getDelay(); 
				int destSched = dest.getASAP();
				int distance = sourceSched - destSched;
				if (source.getSync() && dest.getSync()) {
					if (distance > mii) {
						LALP.warning("backedge " + source + " -> "+ dest + " have distance " + distance + " which is bigger than MII = "+mii+", this can limit MII to lower value");
					}					
				}
				if (Parameters.verbose)
					LALP.info("backedge " + source + " -> "+ dest + " with distance " + distance);
			}
		}
	    t.end();
	    System.out.println("Balancing and synchronizing operations...Ok! " + t.duration() + " ms");
	    System.out.println("Inserted " + ats + " @s");
	}
	
	private int calculateASAP(Component comp) {
		if (comp.getSync()) {
			return comp.getASAP() + comp.getDelay();
		}
		else {
			int max = 0;			
			for (Component parent : comp.getAllPredecessors()) {
				if (parent instanceof IComponent) {
					int newMax = calculateASAP(parent);
					if (newMax > max) {
						max = newMax; 
						if (Parameters.verbose)
							LALP.info("calculating ASAP of "+comp+" by "+parent);
					}
				}
			}
			return max;
		}
	}
}