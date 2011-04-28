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

/* Comentarios:
 * Este design precisa de 11 ciclos por iteracao, ver ciclo: 
 * indexTable, index2, index3, index, stepSizeTable, step, vpdiff, vpdiff2, vpdiff3, vpdiff4, delta4, indexTable 
 * Calculando-se os SCC esses 11 registros fazem parte de um SCC maior que envolve muitos outros registros, 
 * no entanto, acredito que o valor 11 é dado pelo maior ciclo encontrado dentro do SCC
 */

package alp.designs.adpcm;

import alp.components.add_op_s;
import alp.components.add_reg_op_s;
import alp.components.and_op;
import alp.components.block_ram;
import alp.components.const_op;
import alp.components.delay_op;
import alp.components.gt_op;
import alp.components.if_ge_op_s;
import alp.components.input;
import alp.components.lt_op_s;
import alp.components.module_for;
import alp.components.neg_op_s;
import alp.components.not_op;
import alp.components.or_op;
import alp.components.output;
import alp.components.range_op_s;
import alp.components.reg_mux_op;
import alp.components.reg_op;
import alp.components.shl_c_op;
import alp.components.shr_c_op;
import alp.components.sub_op_s;
import alp.components.sub_reg_op_s;
import alp.core.Design;
import alp.core.Parameters;

/**
 * ADPCM coder.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 * @deprecated
 */
public class adpcm_coder_hw extends Design {
	
	public adpcm_coder_hw() {
		super("adpcm_coder");
		final int DATASIZE = 1024;
		int[] sw_indata = new int[DATASIZE];
		final int sw_indexTable[] = {
				-1, -1, -1, -1, 2, 4, 6, 8,
				-1, -1, -1, -1, 2, 4, 6, 8,
		};
		final int sw_stepSizeTable[] = {
				7,		8,		9,		10,		11,		12,		13,		14,		16,		17,
				19,		21,		23,		25,		28,		31,		34,		37,		41,		45,
				50,		55,		60,		66,		73,		80,		88,		97,		107,	118,
				130,	143,	157,	173,	190,	209,	230,	253,	279,	307,
				337,	371,	408,	449,	494,	544,	598,	658,	724,	796,
				876,	963,	1060,	1166,	1282,	1411,	1552,	1707,	1878,	2066,
				2272,	2499,	2749,	3024,	3327,	3660,	4026,	4428,	4871,	5358,
				5894,	6484,	7132,	7845,	8630,	9493,	10442,	11487,	12635,	13899,
				15289,	16818,	18500,	20350,	22385,	24623,	27086,	29794,	32767,
				// just to complete memory size
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		};
		for (int i = 0; i < DATASIZE; i++) {
			sw_indata[i] = (i * 10 + 7) % 127;
//			System.out.print((i * 10 + 7) % 127);
//			System.out.print(", ");
//			if ((i+1) % 128 == 0) 
//				System.out.println();
		}
		Parameters.setDefaultDataWidth(32);
		Parameters.setDefaultAddressWidth(16);
		// input/output pins and constants
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		output done = (output)this.addComponent(new output("done"));
		output output = (output)this.addComponent(new output("output", true));
		// memory components
		block_ram indata = (block_ram)this.addComponent(new block_ram("indata", 10, 32));
		indata.setInitialValue(sw_indata);
		block_ram outdata = (block_ram)this.addComponent(new block_ram("outdata", 9, 32));
		block_ram indexTable = (block_ram)this.addComponent(new block_ram("indexTable", 4, 32));
		indexTable.setInitialValue(sw_indexTable);
		block_ram stepSizeTable = (block_ram)this.addComponent(new block_ram("stepSizeTable", 7, 32));
		stepSizeTable.setInitialValue(sw_stepSizeTable);
		// intermediate components
		module_for len = (module_for)this.addComponent(new module_for("len", 10, DATASIZE, 16));
		// registers
		add_reg_op_s i = (add_reg_op_s)this.addComponent(new add_reg_op_s("i"));
		reg_op step = (reg_op)this.addComponent(new reg_op("step"));
		reg_op step2 = (reg_op)this.addComponent(new reg_op("step2"));
		reg_op step3 = (reg_op)this.addComponent(new reg_op("step3"));
		reg_op index = (reg_op)this.addComponent(new reg_op("index"));
		add_reg_op_s index2 = (add_reg_op_s)this.addComponent(new add_reg_op_s("index2"));
		reg_op val = (reg_op)this.addComponent(new reg_op("val"));
		reg_mux_op sign = (reg_mux_op)this.addComponent(new reg_mux_op("sign"));
		reg_mux_op delta = (reg_mux_op)this.addComponent(new reg_mux_op("delta"));
		reg_mux_op delta2 = (reg_mux_op)this.addComponent(new reg_mux_op("delta2"));
		reg_mux_op delta3 = (reg_mux_op)this.addComponent(new reg_mux_op("delta3"));
		reg_op delta4 = (reg_op)this.addComponent(new reg_op("delta4"));
		reg_op diff = (reg_op)this.addComponent(new reg_op("diff"));
		reg_mux_op diff2 = (reg_mux_op)this.addComponent(new reg_mux_op("diff2"));
		sub_reg_op_s diff3 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("diff3"));
		sub_reg_op_s diff4 = (sub_reg_op_s)this.addComponent(new sub_reg_op_s("diff4"));
		reg_op valpred = (reg_op)this.addComponent(new reg_op("valpred"));
		reg_mux_op valpred2 = (reg_mux_op)this.addComponent(new reg_mux_op("valpred2"));
		reg_op vpdiff = (reg_op)this.addComponent(new reg_op("vpdiff"));
		add_reg_op_s vpdiff2 = (add_reg_op_s)this.addComponent(new add_reg_op_s("vpdiff2"));
		add_reg_op_s vpdiff3 = (add_reg_op_s)this.addComponent(new add_reg_op_s("vpdiff3"));
		add_reg_op_s vpdiff4 = (add_reg_op_s)this.addComponent(new add_reg_op_s("vpdiff4"));
		reg_op outputbuffer = (reg_op)this.addComponent(new reg_op("outputbuffer"));
		reg_op notBufferstep = (reg_op)this.addComponent(new reg_op("notBufferstep", 1));
		// others
		lt_op_s diffLT0 = (lt_op_s)this.addComponent(new lt_op_s("diffLT0"));
		gt_op signGT0 = (gt_op)this.addComponent(new gt_op("signGT0"));
		if_ge_op_s diff2GEstep = (if_ge_op_s)this.addComponent(new if_ge_op_s("diff2GEstep"));
		if_ge_op_s diff3GEstep2 = (if_ge_op_s)this.addComponent(new if_ge_op_s("diff3GEstep2"));
		if_ge_op_s diff4GEstep3 = (if_ge_op_s)this.addComponent(new if_ge_op_s("diff4GEstep3"));
		// arith
		sub_op_s subVal = (sub_op_s)this.addComponent(new sub_op_s("subVal"));
		or_op orDelta = (or_op)this.addComponent(new or_op("orDelta"));
		or_op orDelta2 = (or_op)this.addComponent(new or_op("orDelta2"));
		or_op orDelta3 = (or_op)this.addComponent(new or_op("orDelta3"));
		neg_op_s negDiff = (neg_op_s)this.addComponent(new neg_op_s("negDiff"));
		shr_c_op shr3step = (shr_c_op)this.addComponent(new shr_c_op("shr3step", 3));
		shr_c_op shr1step = (shr_c_op)this.addComponent(new shr_c_op("shr1step"));
		shr_c_op shr1step2 = (shr_c_op)this.addComponent(new shr_c_op("shr1step2"));
		shl_c_op shl4delta4 = (shl_c_op)this.addComponent(new shl_c_op("shl4delta4", 4));
		sub_op_s subValpred = (sub_op_s)this.addComponent(new sub_op_s("subValpred"));
		add_op_s addValpred = (add_op_s)this.addComponent(new add_op_s("addValpred"));
		range_op_s valpred3 = (range_op_s)this.addComponent(new range_op_s("valpred3"));
		valpred3.setRange(-32768, 32767);
		range_op_s index3 = (range_op_s)this.addComponent(new range_op_s("index3"));
		index3.setRange(0, 88);		
		not_op bufferstep = (not_op)this.addComponent(new not_op("bufferstep", 1));
		and_op delta4andF0 = (and_op)this.addComponent(new and_op("delta4andF0"));
		and_op delta4andF = (and_op)this.addComponent(new and_op("delta4andF"));
//		and_op notBufferstepGT0delayedAndstep11 = (and_op)this.addComponent(new and_op("notBufferstepGT0delayedAndstep11", 1));
		and_op notBufferstepDelayedAndStep10 = (and_op)this.addComponent(new and_op("notBufferstepDelayedAndStep10", 1));
		and_op bufferstepDelayedAndStep10 = (and_op)this.addComponent(new and_op("bufferstepDelayedAndStep10", 1));
		or_op delta4andForOutputbuffer = (or_op)this.addComponent(new or_op("delta4andForOutputbuffer"));
//		not_op notBufferstepGT0 = (not_op)this.addComponent(new not_op("notBufferstepGT0", 1));
		// delays
		delay_op len_step1 = (delay_op)this.addComponent(new delay_op("len_step1", 1, 1));
		delay_op len_step2 = (delay_op)this.addComponent(new delay_op("len_step2", 1, 2));
//		delay_op len_step3 = (delay_op)this.addComponent(new delay_op("len_step3", 1, 3));
//		delay_op len_step4 = (delay_op)this.addComponent(new delay_op("len_step4", 1, 4));
		delay_op len_step5 = (delay_op)this.addComponent(new delay_op("len_step5", 1, 5));
//		delay_op len_step6 = (delay_op)this.addComponent(new delay_op("len_step6", 1, 6));
//		delay_op len_step7 = (delay_op)this.addComponent(new delay_op("len_step7", 1, 7));
//		delay_op len_step8 = (delay_op)this.addComponent(new delay_op("len_step8", 1, 8));
		delay_op len_step9 = (delay_op)this.addComponent(new delay_op("len_step9", 1, 9));
		delay_op len_step10 = (delay_op)this.addComponent(new delay_op("len_step10", 1, 10));
//		delay_op len_step11 = (delay_op)this.addComponent(new delay_op("len_step11", 1, 11));
		delay_op signGT0delayed = (delay_op)this.addComponent(new delay_op("signGT0Delayed", 1, 5));
		delay_op bufferstepDelayed = (delay_op)this.addComponent(new delay_op("bufferstepDelayed", 1, 9));
		not_op notBufferstepDelayed = (not_op)this.addComponent(new not_op("notBufferstepDelayed", 1));
		// connections
		try {
			// sync connections
			len_step1.connectComponent(valpred, "we");
			len_step9.connectComponent(delta4, "we");
			len_step5.connectComponent(vpdiff, "we");
			len_step2.connectComponent(index, "we");
			len.connectComponent("step", index2, "we");
			len_step10.connectComponent(notBufferstep, "we");
			bufferstepDelayedAndStep10.connectComponent(outputbuffer, "we");
			notBufferstepDelayedAndStep10.connectComponent(i);
			signGT0.connectComponent(signGT0delayed);
			// data/control connections
			init.connectComponent(len, "clk_en");
			len.connectComponent("output", indata, "address");
			len.connectComponent("done", done);
			len.connectComponent("step", len_step1);
			len.connectComponent("step", len_step2);
//			len.connectComponent("step", len_step3);
//			len.connectComponent("step", len_step4);
			len.connectComponent("step", len_step5);
//			len.connectComponent("step", len_step6);
//			len.connectComponent("step", len_step7);
//			len.connectComponent("step", len_step8);
			len.connectComponent("step", len_step9);
			len.connectComponent("step", len_step10);
//			len.connectComponent("step", len_step11);
			i.connectComponent(outdata);
			i.connectComponent(i, "I0");
			this.addComponent(new const_op(1, true)).connectComponent(i, "I1");
			stepSizeTable.connectComponent(step);
			index.connectComponent(stepSizeTable, "address");
			indata.connectComponent(val);
			val.connectComponent(subVal, "I0");
			valpred.connectComponent(subVal, "I1");
			subVal.connectComponent(diff);
			diff.connectComponent(diffLT0);
			diff.connectComponent(diff2, "I0");
			diff.connectComponent(negDiff);
			diffLT0.connectComponent(sign);
			negDiff.connectComponent(diff2, "I1");
			this.addComponent(new const_op(0, true)).connectComponent(sign, "I0");
			this.addComponent(new const_op(8, true)).connectComponent(sign, "I1");
			sign.connectComponent(signGT0);
			signGT0.connectComponent(diff2);
			step.connectComponent(shr3step);
			shr3step.connectComponent(vpdiff);
			step.connectComponent(shr1step);
			shr1step.connectComponent(step2);
			step2.connectComponent(shr1step2);
			shr1step2.connectComponent(step3);
			diff2.connectComponent(diff2GEstep,"I0");
			step.connectComponent(diff2GEstep,"I1");
			diff2GEstep.connectComponent(delta);
			diff2GEstep.connectComponent(diff3);
			diff2GEstep.connectComponent(vpdiff2);
			this.addComponent(new const_op(0, true)).connectComponent(delta, "I0");
			this.addComponent(new const_op(4, true)).connectComponent(delta, "I1");
			diff3.connectComponent(diff3GEstep2, "I0");
			step2.connectComponent(diff3GEstep2, "I1");
			diff3GEstep2.connectComponent(delta2);
			diff3GEstep2.connectComponent(diff4);
			diff3GEstep2.connectComponent(vpdiff3);
			diff4GEstep3.connectComponent(delta3);
			diff4GEstep3.connectComponent(vpdiff4);
			diff4.connectComponent(diff4GEstep3, "I0");
			step3.connectComponent(diff4GEstep3, "I1");
			vpdiff.connectComponent(vpdiff2, "I0");
			step.connectComponent(vpdiff2, "I1");
			diff2.connectComponent(diff3, "I0");
			step.connectComponent(diff3, "I1");
			diff3.connectComponent(diff4, "I0");
			step2.connectComponent(diff4, "I1");
			vpdiff2.connectComponent(vpdiff3, "I0");
			step2.connectComponent(vpdiff3, "I1");
			delta.connectComponent(delta2, "I0");
			delta.connectComponent(orDelta, "I0");
			this.addComponent(new const_op(2, true)).connectComponent(orDelta, "I1");
			orDelta.connectComponent(delta2, "I1");
			vpdiff3.connectComponent(vpdiff4, "I0");
			step3.connectComponent(vpdiff4, "I1");
			delta2.connectComponent(delta3, "I0");
			delta2.connectComponent(orDelta2, "I0");
			this.addComponent(new const_op(1, true)).connectComponent(orDelta2, "I1");
			orDelta2.connectComponent(delta3, "I1");
			signGT0delayed.connectComponent(valpred2);
			valpred.connectComponent(addValpred, "I0");
			valpred.connectComponent(subValpred, "I0");
			vpdiff4.connectComponent(addValpred, "I1");
			vpdiff4.connectComponent(subValpred, "I1");
			addValpred.connectComponent(valpred2, "I0");
			subValpred.connectComponent(valpred2, "I1");
			valpred2.connectComponent(valpred3);
			valpred3.connectComponent(valpred);
			delta3.connectComponent(orDelta3, "I0");
			sign.connectComponent(orDelta3, "I1");
			orDelta3.connectComponent(delta4);
			index.connectComponent(index2, "I0");
			indexTable.connectComponent(index2, "I1");
			delta4.connectComponent(indexTable);
			index2.connectComponent(index3);
			bufferstep.connectComponent(notBufferstep);
			notBufferstep.connectComponent(bufferstep);
			bufferstep.connectComponent(bufferstepDelayed);
			bufferstepDelayed.connectComponent(notBufferstepDelayed);
			delta4.connectComponent(shl4delta4);
			shl4delta4.connectComponent(delta4andF0, "I0");
			this.addComponent(new const_op(240, true)).connectComponent(delta4andF0, "I1");
			delta4andF0.connectComponent(outputbuffer, "I0");
			delta4.connectComponent(delta4andF, "I0");
			this.addComponent(new const_op(15, true)).connectComponent(delta4andF, "I1");
			delta4andF.connectComponent(delta4andForOutputbuffer, "I0");
			outputbuffer.connectComponent(delta4andForOutputbuffer, "I1");
			delta4andForOutputbuffer.connectComponent(outdata, "data_in");
			notBufferstepDelayedAndStep10.connectComponent(outdata, "we");
			index3.connectComponent(index);
			notBufferstepDelayed.connectComponent(notBufferstepDelayedAndStep10,  "I0");
			len_step10.connectComponent(notBufferstepDelayedAndStep10, "I1");
			bufferstepDelayed.connectComponent(bufferstepDelayedAndStep10,  "I0");
			len_step10.connectComponent(bufferstepDelayedAndStep10, "I1");
			outdata.connectComponent(output);
			// back edges
//			bufferstep.getDefaultOutput().getSignal().setBackEdge(true);
//			i.getPort("I0").getSignal().setBackEdge(true);
//			index2.getPort("I0").getSignal().setBackEdge(true);
//			indexTable.getDefaultOutput().getSignal().setBackEdge(true);
//			valpred.getDefaultOutput().getSignal().getSignal().setBackEdge(true);
//			valpred.getDefaultOutput().getSignal().getSignal().getSignal().setBackEdge(true);
		} catch (Exception e) {
			e.printStackTrace();
			return;
		}
	}
}
