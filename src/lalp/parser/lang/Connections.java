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

package lalp.parser.lang;

/**
 * A set of connections for children used on recursion process
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://menotti.pro.br/">Author Page</a>
 * @author <a href="http://www.dc.ufscar.br/">DC UFSCar</a>
 * @version January, 2009
 *
 */
public class Connections {

	protected SimpleNode parent = null;
	protected SimpleNode owner = null;
	protected SimpleNode first = null;
	protected SimpleNode second = null;
	protected SimpleNode third = null;
	protected SimpleNode fourth = null;
	protected SimpleNode fifth = null;

	public String toString() {
		return parent+"^"+owner+"="+"["+first+","+second+","+third+","+fourth+","+fifth+"]";
	}
	
	public Connections(SimpleNode owner) {
		this.owner = owner;
	}

	public SimpleNode getParent() {
		return parent;
	}

	public void setParent(SimpleNode parent) {
		this.parent = parent;
	}

	public SimpleNode getOwner() {
		return owner;
	}

	public void setOwner(SimpleNode owner) {
		this.owner = owner;
	}

	public SimpleNode getFirst() {
		return first;
	}

	public void setFirst(SimpleNode first) {
		this.first = first;
	}

	public SimpleNode getSecond() {
		return second;
	}

	public void setSecond(SimpleNode second) {
		this.second = second;
	}

	public SimpleNode getThird() {
		return third;
	}

	public void setThird(SimpleNode third) {
		this.third = third;
	}

	public SimpleNode getFourth() {
		return fourth;
	}

	public void setFourth(SimpleNode fourth) {
		this.fourth = fourth;
	}

	public SimpleNode getFifth() {
		return fifth;
	}

	public void setFifth(SimpleNode fifth) {
		this.fifth = fifth;
	}
}
