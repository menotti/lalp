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

package alp.designs.adpcm;

import alp.components.add_op_s;
import alp.components.add_reg_op_s;
import alp.components.and_op;
import alp.components.block_ram;
import alp.components.const_op;
import alp.components.delay_op;
import alp.components.gt_op;
import alp.components.input;
import alp.components.module_for;
import alp.components.mux_op;
import alp.components.not_op;
import alp.components.output;
import alp.components.range_op_s;
import alp.components.reg_mux_op;
import alp.components.reg_op;
import alp.components.shr_c_op;
import alp.components.sub_op_s;
import alp.core.Design;
import alp.core.Parameters;

/**
 * ADPCM decoder.
 * 
 * @author <a href="mailto:ricardomenotti@acm.org">Ricardo Menotti</a>
 * @author <a href="http://www.icmc.usp.br/~menotti/">ICMC/USP</a>
 * @author <a href="http://www.cm.utfpr.edu.br/menotti/">UTFPR</a>
 * @version September, 2007
 * @deprecated
*/
public class adpcm_decoder_hw_2c extends Design {	
	public adpcm_decoder_hw_2c() {
		super("adpcm_decoder_auto");
		final int DATASIZE = 1024;
		int[] sw_indata = new int[DATASIZE/2];
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
		for (int i = 0; i < DATASIZE/2; i++) {
			sw_indata[i] = (i * 10 + 7) % 127;
		}
		Parameters.setDefaultDataWidth(32);
		Parameters.setDefaultAddressWidth(32);
		// input/output pins and constants
		this.addGlobalComponent(new input("clk"));
		this.addGlobalComponent(new input("reset"));
		this.addGlobalComponent(new input("clear"));
		input init = (input)this.addComponent(new input("init"));
		this.setInit(init);
		output done = (output)this.addComponent(new output("done"));
		output output = (output)this.addComponent(new output("output", true));
		// memory components
		block_ram indata = (block_ram)this.addComponent(new block_ram("indata", 9, 32));
		indata.setInitialValue(sw_indata);
		block_ram outdata = (block_ram)this.addComponent(new block_ram("outdata", 10, 32));
		block_ram indexTable = (block_ram)this.addComponent(new block_ram("indexTable", 4, 32));
		indexTable.setInitialValue(sw_indexTable);
		block_ram stepSizeTable = (block_ram)this.addComponent(new block_ram("stepSizeTable", 7, 32));
		stepSizeTable.setInitialValue(sw_stepSizeTable);
		// intermediate components
		module_for len = (module_for)this.addComponent(new module_for(10, DATASIZE, 3));
		module_for len2 = (module_for)this.addComponent(new module_for(10, DATASIZE, 3));
		// registers
		add_reg_op_s i = (add_reg_op_s)this.addComponent(new add_reg_op_s("i"));
		reg_op step = (reg_op)this.addComponent(new reg_op("step"));
		reg_op index = (reg_op)this.addComponent(new reg_op("index"));
		add_reg_op_s index2 = (add_reg_op_s)this.addComponent(new add_reg_op_s("index2"));
		reg_op sign = (reg_op)this.addComponent(new reg_op("sign"));
		reg_mux_op delta = (reg_mux_op)this.addComponent(new reg_mux_op("delta"));
		reg_op delta2 = (reg_op)this.addComponent(new reg_op("delta2"));
		reg_op valpred = (reg_op)this.addComponent(new reg_op("valpred"));
		reg_op valpred3 = (reg_op)this.addComponent(new reg_op("valpred3"));
		reg_op vpdiff = (reg_op)this.addComponent(new reg_op("vpdiff"));
		reg_op vpdiff2 = (reg_op)this.addComponent(new reg_op("vpdiff2"));
		reg_op inputbuffer = (reg_op)this.addComponent(new reg_op("inputbuffer"));
		reg_op bufferstep = (reg_op)this.addComponent(new reg_op("bufferstep", 1));
		// others
		gt_op signGT0 = (gt_op)this.addComponent(new gt_op("signGT0"));
		gt_op bufferstepGT0 = (gt_op)this.addComponent(new gt_op("bufferstepGT0", 1));
		gt_op notBufferstepGT0 = (gt_op)this.addComponent(new gt_op("notBufferstepGT0", 1));
		// arith
		shr_c_op stepShr1 = (shr_c_op)this.addComponent(new shr_c_op("stepShr1"));
		shr_c_op stepShr2 = (shr_c_op)this.addComponent(new shr_c_op("stepShr2"));
		stepShr2.setAmount(2);
		shr_c_op stepShr3 = (shr_c_op)this.addComponent(new shr_c_op("stepShr3"));
		stepShr3.setAmount(3);
		add_op_s vpdiffAddStep = (add_op_s)this.addComponent(new add_op_s("vpdiffAddStep"));
		add_op_s vpdiffAddStepShr1 = (add_op_s)this.addComponent(new add_op_s("vpdiffAddStepShr1"));
		add_op_s vpdiffAddStepShr2 = (add_op_s)this.addComponent(new add_op_s("vpdiffAddStepShr2"));
		sub_op_s valpredSubVpdiff2 = (sub_op_s)this.addComponent(new sub_op_s("valpredSubVpdiff2"));
		add_op_s valpredAddVpdiff2 = (add_op_s)this.addComponent(new add_op_s("valpredAddVpdiff2"));
		range_op_s valpred2 = (range_op_s)this.addComponent(new range_op_s("valpred2"));
		valpred2.setRange(-32768, 32767);
		range_op_s index3 = (range_op_s)this.addComponent(new range_op_s("index3"));
		index3.setRange(0, 88);
		not_op notBufferstep = (not_op)this.addComponent(new not_op("notBufferstep", 1));
		and_op inputbufferAndF = (and_op)this.addComponent(new and_op("inputbufferAndF"));
		and_op inputbufferShr4AndF = (and_op)this.addComponent(new and_op("inputbufferShr4AndF"));
		and_op deltaAnd8 = (and_op)this.addComponent(new and_op("deltaAnd8"));
		and_op deltaAnd7 = (and_op)this.addComponent(new and_op("deltaAnd7"));
		and_op delta2and1 = (and_op)this.addComponent(new and_op("delta2And1"));
		and_op delta2and2 = (and_op)this.addComponent(new and_op("delta2And2"));
		and_op delta2and4 = (and_op)this.addComponent(new and_op("delta2And4"));
		shr_c_op inputbufferShr4 = (shr_c_op)this.addComponent(new shr_c_op("inputbufferShr4"));
		inputbufferShr4.setAmount(4);
		mux_op mux_delta2and1 = (mux_op)this.addComponent(new mux_op("mux_delta2and1"));
		mux_op mux_delta2and2 = (mux_op)this.addComponent(new mux_op("mux_delta2and2"));
		mux_op mux_delta2and4 = (mux_op)this.addComponent(new mux_op("mux_delta2and4"));
		mux_op mux_valpred = (mux_op)this.addComponent(new mux_op("mux_valpred"));
		gt_op delta2and1GT0 = (gt_op)this.addComponent(new gt_op("delta2and1GT0"));
		gt_op delta2and2GT0 = (gt_op)this.addComponent(new gt_op("delta2and2GT0"));
		gt_op delta2and4GT0 = (gt_op)this.addComponent(new gt_op("delta2and4GT0"));
		// delay
		reg_op bufferstep1Ddelta = (reg_op)this.addComponent(new reg_op(1));
		delay_op delta2delayed = (delay_op)this.addComponent(new delay_op());
		delta2delayed.setDelay(5);
		reg_op stepShr1delayed = (reg_op)this.addComponent(new reg_op());
		reg_op stepShr2delayed = (reg_op)this.addComponent(new reg_op());
		delay_op signDelayed = (delay_op)this.addComponent(new delay_op());
		signDelayed.setDelay(5);

		delay_op initDelayed = (delay_op)this.addComponent(new delay_op(1, 9));
		
//		delay_op step2 = (delay_op)this.addComponent(new delay_op("step2", 1, 1));
		delay_op step3 = (delay_op)this.addComponent(new delay_op("step3", 1, 2));
//		delay_op step4 = (delay_op)this.addComponent(new delay_op("step4", 1, 3));
//		delay_op step5 = (delay_op)this.addComponent(new delay_op("step5", 1, 4));
//		delay_op step6 = (delay_op)this.addComponent(new delay_op("step6", 1, 5));
		delay_op step7 = (delay_op)this.addComponent(new delay_op("step7", 1, 6));
		delay_op step8 = (delay_op)this.addComponent(new delay_op("step8", 1, 7));
//		delay_op step9 = (delay_op)this.addComponent(new delay_op("step9", 1, 8));
//		delay_op step10 = (delay_op)this.addComponent(new delay_op("step9", 1, 9));
		
		// connections
		try {
			len.connectComponent("clk_en", init);
			len.connectComponent("step", bufferstep, "we");
			len.connectComponent("step", i, "we");
//			len.connectComponent("step", step2);
			len.connectComponent("step", step3);
//			len.connectComponent("step", step4);
//			len.connectComponent("step", step5);
//			len.connectComponent("step", step6);
			len.connectComponent("step", step7);
			len.connectComponent("step", step8);
//			len.connectComponent("step", step9);
//			len.connectComponent("step", step10);
			init.connectComponent(initDelayed);
			initDelayed.connectComponent(len2, "clk_en");
			len2.connectComponent("done", done);
			
			bufferstep.connectComponent(notBufferstep);
			notBufferstep.connectComponent(bufferstep);
			bufferstep.connectComponent(bufferstepGT0);
			notBufferstep.connectComponent(notBufferstepGT0);

			// delay: 1
			bufferstep.connectComponent(bufferstep1Ddelta);
			bufferstep1Ddelta.connectComponent(delta);
			
			inputbufferAndF.connectComponent(delta, "I1");
			inputbufferShr4AndF.connectComponent(delta, "I0");
			
			inputbuffer.connectComponent(inputbufferShr4);
			inputbuffer.connectComponent(inputbufferAndF, "I0");
			inputbufferShr4.connectComponent(inputbufferShr4AndF, "I0");
			
			this.addComponent(new const_op(15, true)).connectComponent(inputbufferAndF, "I1");
			this.addComponent(new const_op(15, true)).connectComponent(inputbufferShr4AndF, "I1");
			
			indata.connectComponent(inputbuffer);
			i.connectComponent(indata);
			i.connectComponent(i, "I0");
			this.addComponent(new const_op(1, true)).connectComponent(i, "I1");
			notBufferstepGT0.connectComponent(i);
			notBufferstepGT0.connectComponent(inputbuffer, "we");
			
			delta.connectComponent(indexTable);
			
			index.connectComponent(stepSizeTable);
			//stepSizeTable.connectComponent("we", this.addComponent(new const_op(0, 1)));
			this.addComponent(new const_op(0, 1)).connectComponent(stepSizeTable, "we");
			stepSizeTable.connectComponent(step);
			
			index.connectComponent(index2, "I0");
			indexTable.connectComponent(index2, "I1");
			index2.connectComponent(index3);
			index3.connectComponent(index);
			//len.connectComponent("step", index2, "we");
			step3.connectComponent(index2, "we");
			
			delta.connectComponent(deltaAnd8, "I0");
			this.addComponent(new const_op(8, true)).connectComponent(deltaAnd8, "I1");
			deltaAnd8.connectComponent(sign);
			sign.connectComponent(signDelayed);
			
			delta.connectComponent(deltaAnd7, "I0");
			this.addComponent(new const_op(7, true)).connectComponent(deltaAnd7, "I1");
			deltaAnd7.connectComponent(delta2);
			delta2.connectComponent(delta2delayed);
			
			stepShr3.connectComponent(vpdiff);
			step.connectComponent(stepShr1);
			step.connectComponent(stepShr2);
			step.connectComponent(stepShr3);
			stepShr1.connectComponent(stepShr1delayed);
			stepShr2.connectComponent(stepShr2delayed);

			delta2delayed.connectComponent(delta2and1, "I0");
			delta2delayed.connectComponent(delta2and2, "I0");
			delta2delayed.connectComponent(delta2and4, "I0");

			this.addComponent(new const_op(1, true)).connectComponent(delta2and1, "I1");
			this.addComponent(new const_op(2, true)).connectComponent(delta2and2, "I1");
			this.addComponent(new const_op(4, true)).connectComponent(delta2and4, "I1");
			
			vpdiff.connectComponent(vpdiffAddStep, "I0");
			vpdiff.connectComponent(vpdiffAddStepShr1, "I0");
			vpdiff.connectComponent(vpdiffAddStepShr2, "I0");
			step.connectComponent(vpdiffAddStep, "I1");
			stepShr1delayed.connectComponent(vpdiffAddStepShr1, "I1");
			stepShr2delayed.connectComponent(vpdiffAddStepShr2, "I1");
			
			delta2and1.connectComponent(delta2and1GT0);
			delta2and2.connectComponent(delta2and2GT0);
			delta2and4.connectComponent(delta2and4GT0);

			delta2and1GT0.connectComponent(mux_delta2and1);
			delta2and2GT0.connectComponent(mux_delta2and2);
			delta2and4GT0.connectComponent(mux_delta2and4);
			
			mux_delta2and4.connectComponent(vpdiff2);
			vpdiffAddStep.connectComponent(mux_delta2and4, "I1");
			mux_delta2and2.connectComponent(mux_delta2and4, "I0");
			vpdiffAddStepShr1.connectComponent(mux_delta2and2, "I1");
			mux_delta2and1.connectComponent(mux_delta2and2, "I0");
			vpdiffAddStepShr2.connectComponent(mux_delta2and1, "I1");
			vpdiff.connectComponent(mux_delta2and1, "I0");
			
			valpred.connectComponent(valpredAddVpdiff2, "I0");
			valpred.connectComponent(valpredSubVpdiff2, "I0");
			vpdiff2.connectComponent(valpredAddVpdiff2, "I1");
			vpdiff2.connectComponent(valpredSubVpdiff2, "I1");
			step7.connectComponent(vpdiff2, "we");
			step7.connectComponent(valpred, "we");
			len2.connectComponent("step", outdata, "we");
			
			signDelayed.connectComponent(signGT0);
			signGT0.connectComponent(mux_valpred);
			valpredSubVpdiff2.connectComponent(mux_valpred, "I1");
			valpredAddVpdiff2.connectComponent(mux_valpred, "I0");
			mux_valpred.connectComponent(valpred2);
			valpred2.connectComponent(valpred3);
			valpred3.connectComponent(outdata, "data_in");
			valpred3.connectComponent(valpred);
			len2.connectComponent(outdata);
			step8.connectComponent(valpred2, "we");
			outdata.connectComponent(output);
		} catch (Exception e) {
			e.printStackTrace();
			return;
		}
	}
}
