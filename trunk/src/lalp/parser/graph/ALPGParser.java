/* Generated By:JavaCC: Do not edit this line. ALPGParser.java */
/* Copyright (c) 2009 João M. P. Cardoso, All Rights Reserved.
 * Copyright (c) 2009 Ricardo Menotti, All Rights Reserved.
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

package lalp.parser.graph;

import java.util.*;
import java.io.*;

import lalp.components.*;
import lalp.core.*;



@SuppressWarnings("unchecked")
public class ALPGParser implements ALPGParserConstants {

        Design design = new Design();
        Hashtable<String, Integer> allConsts = new Hashtable<String, Integer>();
        Hashtable<String, Object> allTypedefs = new Hashtable<String, Object>();
        Hashtable<String, Component> allComponents = new Hashtable<String, Component>();
        Component cFrom, cTo;
        String cFromPort, cToPort;
        String componentName;
        Boolean backward;
        String signalName;

        public static void main(String args[]) {
                FileInputStream inStream;
                if (args.length == 0) {
                        System.out.println("usage: java RunFile <input_file>");
                        System.exit(1);
                } else if (args.length != 1) {
                        System.out.println("usage: java RunFile <input_file>");
                        System.exit(1);
                }
                try {
                        System.out.println("parsing: Reading from file " + args[0] + "...");
                        inStream = new FileInputStream(args[0]);
                        ALPGParser parser = new ALPGParser(inStream);
                        parser.Start();
                } catch (FileNotFoundException e) {
                        System.out.println("parsing:  File " + args[0] + " not found.");
                        System.exit(1);
                } catch (Exception e) {
                        e.printStackTrace();
                        System.exit(1);
                }
        }

        public Design getDesign() {
                return this.design;
        }

  final public void Start() throws ParseException {
        Token t;
    label_1:
    while (true) {
      switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
      case CONST:
        ;
        break;
      default:
        jj_la1[0] = jj_gen;
        break label_1;
      }
      Consts();
    }
    label_2:
    while (true) {
      switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
      case TYPEDEF:
        ;
        break;
      default:
        jj_la1[1] = jj_gen;
        break label_2;
      }
      Typedefs();
    }
    t = jj_consume_token(IDENTIFIER);
    jj_consume_token(LPAREN);
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case IN:
    case OUT:
      Pin();
      label_3:
      while (true) {
        switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
        case COMMA:
          ;
          break;
        default:
          jj_la1[2] = jj_gen;
          break label_3;
        }
        jj_consume_token(COMMA);
        Pin();
      }
      break;
    default:
      jj_la1[3] = jj_gen;
      ;
    }
    jj_consume_token(RPAREN);
    jj_consume_token(LBRACE);
    Statements();
    jj_consume_token(RBRACE);
                design.setName(t.image);
                //DEBUG
                //Info("Design " + t.image + " parsed!");

  }

  final public void Consts() throws ParseException {
        Token constName, constVal;
    jj_consume_token(CONST);
    constName = jj_consume_token(IDENTIFIER);
    jj_consume_token(32);
    constVal = jj_consume_token(CONST_INTEGER);
    jj_consume_token(SEMICOLON);
                allConsts.put(constName.image, Integer.parseInt(constVal.image));
                //DEBUG
                //Info("Const " + constName.image + " with value " + constVal.image + " found");

  }

  final public void Typedefs() throws ParseException {
        Token typedefName;
        int typedefVal;
    jj_consume_token(TYPEDEF);
    typedefVal = Fixed();
    typedefName = jj_consume_token(IDENTIFIER);
    jj_consume_token(SEMICOLON);
                allTypedefs.put(typedefName.image, typedefVal);
                //DEBUG
                //Info("Type " + typedefName.image + " found with " + typedefVal + " bit(s)");

  }

  final public int Fixed() throws ParseException {
        Token bitwidth;
    jj_consume_token(FIXED);
    jj_consume_token(LPAREN);
    bitwidth = jj_consume_token(CONST_INTEGER);
    jj_consume_token(COMMA);
    jj_consume_token(CONST_INTEGER);
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case COMMA:
      jj_consume_token(COMMA);
      jj_consume_token(CONST_INTEGER);
      break;
    default:
      jj_la1[4] = jj_gen;
      ;
    }
    jj_consume_token(RPAREN);
                {if (true) return Integer.parseInt(bitwidth.image);}
    throw new Error("Missing return statement in function");
  }

  final public void Pin() throws ParseException {
        Token pinDir, pinName, pinType=null;
        int pinWidth=0;
        Component c;
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case IN:
      pinDir = jj_consume_token(IN);
      break;
    case OUT:
      pinDir = jj_consume_token(OUT);
      break;
    default:
      jj_la1[5] = jj_gen;
      jj_consume_token(-1);
      throw new ParseException();
    }
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case IDENTIFIER:
      pinType = jj_consume_token(IDENTIFIER);
      break;
    case FIXED:
      pinWidth = Fixed();
      break;
    default:
      jj_la1[6] = jj_gen;
      jj_consume_token(-1);
      throw new ParseException();
    }
    pinName = jj_consume_token(IDENTIFIER);
                if (pinType != null) {
                        if (allTypedefs.containsKey(pinType.image)) {
                                pinWidth=(Integer)(allTypedefs.get(pinType.image));
                                Info(pinDir.image + "put pin " + pinName.image + " of type " + pinType.image + " found");
                        }
                        else {
                                Error("Type " + pinType.image + " NOT found!");
                        }
                }
                if (pinDir.kind == IN) {
                        if (pinWidth == 1) {
                                c = new input(pinName.image);
                        }
                        else {
                                c = new input(pinName.image, pinWidth);
                        }
                }
                else {
                        if (pinWidth == 1) {
                                c = new output(pinName.image);
                        }
                        else {
                                c = new output(pinName.image, pinWidth);
                        }
                }
                allComponents.put(pinName.image, c);
                design.addComponent(c);
  }

  final public void Statements() throws ParseException {
    Declarations();
    label_4:
    while (true) {
      Connection();
      switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
      case IDENTIFIER:
        ;
        break;
      default:
        jj_la1[7] = jj_gen;
        break label_4;
      }
    }
  }

  final public void Declarations() throws ParseException {
    jj_consume_token(LBRACE);
    label_5:
    while (true) {
      Declaration();
      switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
      case IDENTIFIER:
        ;
        break;
      default:
        jj_la1[8] = jj_gen;
        break label_5;
      }
    }
    jj_consume_token(RBRACE);
  }

  final public void Declaration() throws ParseException {
        Token t1=null, t2=null, t3;
        Vector<String> comps = new Vector<String>();
        Vector<Integer> args = new Vector<Integer>();
    t1 = jj_consume_token(IDENTIFIER);
    label_6:
    while (true) {
      switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
      case COMMA:
        ;
        break;
      default:
        jj_la1[9] = jj_gen;
        break label_6;
      }
      jj_consume_token(COMMA);
      t2 = jj_consume_token(IDENTIFIER);
    }
    jj_consume_token(33);
    t3 = jj_consume_token(IDENTIFIER);
    jj_consume_token(LPAREN);
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case CONST_INTEGER:
    case IDENTIFIER:
      Arg(args);
      label_7:
      while (true) {
        switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
        case COMMA:
          ;
          break;
        default:
          jj_la1[10] = jj_gen;
          break label_7;
        }
        jj_consume_token(COMMA);
        Arg(args);
      }
      break;
    default:
      jj_la1[11] = jj_gen;
      ;
    }
    jj_consume_token(RPAREN);
    jj_consume_token(SEMICOLON);
                if (t1 != null) {
                        comps.add(t1.image);
                }
                if (t2 != null) {
                        comps.add(t2.image);
                }
                for (String c : comps) {
                        Object o=null;
                        try {
                                switch (args.size()) {
                                case 1:
                                        o = Class.forName("lalp.components." + t3.image).getConstructor(String.class, int.class).newInstance(c, args.get(0));
                                        break;
                                case 2:
                                        o = Class.forName("lalp.components." + t3.image).getConstructor(String.class, int.class, int.class).newInstance(c, args.get(0), args.get(1));
                                        break;
                                case 3:
                                        o = Class.forName("lalp.components." + t3.image).getConstructor(String.class, int.class, int.class, int.class).newInstance(c, args.get(0), args.get(1), args.get(2));
                                        break;
                                case 4:
                                        o = Class.forName("lalp.components." + t3.image).getConstructor(String.class, int.class, int.class, int.class, int.class).newInstance(c, args.get(0), args.get(1), args.get(2), args.get(3));
                                        break;
                                case 5:
                                        o = Class.forName("lalp.components." + t3.image).getConstructor(String.class, int.class, int.class, int.class, int.class, int.class).newInstance(c, args.get(0), args.get(1), args.get(2), args.get(3), args.get(4));
                                        break;
                                case 6:
                                        o = Class.forName("lalp.components." + t3.image).getConstructor(String.class, int.class, int.class, int.class, int.class, int.class, int.class).newInstance(c, args.get(0), args.get(1), args.get(2), args.get(3), args.get(4), args.get(5));
                                        break;
                                default:
                                        Error("wrong number or arguments for component " + c);
                                }
                                allComponents.put(c, (Component)o);
                                design.addComponent((Component)o);
                        } catch (InstantiationException e) {
                                e.printStackTrace();
                        } catch (IllegalAccessException e) {
                                e.printStackTrace();
                        } catch (ClassNotFoundException e) {
                                e.printStackTrace();
                        } catch (Exception e) {
                                e.printStackTrace();
                        }
        }
  }

  final public void Arg(Vector<Integer> args) throws ParseException {
        Token t;
        int val;
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case CONST_INTEGER:
      t = jj_consume_token(CONST_INTEGER);
      break;
    case IDENTIFIER:
      t = jj_consume_token(IDENTIFIER);
      break;
    default:
      jj_la1[12] = jj_gen;
      jj_consume_token(-1);
      throw new ParseException();
    }
                if (t.kind == IDENTIFIER) {
                        if (allConsts.containsKey(t.image)) {
                                val = allConsts.get(t.image);
                                args.add(val);
                        }
                        else {
                                Error("Const " + t.image + " NOT found!");
                        }
                }
                else {
                        val = Integer.parseInt(t.image);
                        args.add(val);
                }
  }

  final public void Connection() throws ParseException {
        cFromPort = null;
        cToPort = null;
        backward = false;
        Signal s;
        signalName = null;
    Lhs();
    jj_consume_token(ASSIGN);
    ConnectionName();
    Rhs();
                //DEBUG
                //Info("Trying to connect component " + cFrom + " port " + cFromPort + " on component " + cTo + " port " + cToPort);
                try {
                if (cFromPort != null) {
                        if (cToPort != null) {
                        s = cFrom.connectComponent(cFromPort, cTo, cToPort);
                        }
                        else {
                        s = cFrom.connectComponent(cFromPort, cTo);
                        }
                }
                else {
                        if (cToPort != null) {
                        s = cFrom.connectComponent(cTo, cToPort);
                        }
                        else {
                        s = cFrom.connectComponent(cTo);
                        }
                }
                if (signalName != null) {
                        s.setName(signalName);
                }
                s.setBackEdge(backward);
                } catch (Exception e) {
                        e.printStackTrace();
                }
  }

  final public void Lhs() throws ParseException {
        Token tc, tp = null;
    tc = jj_consume_token(IDENTIFIER);
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case DOT:
      jj_consume_token(DOT);
      tp = jj_consume_token(IDENTIFIER);
      break;
    default:
      jj_la1[13] = jj_gen;
      ;
    }
                cTo = allComponents.get(tc.image);
                if (cTo == null) {
                        Error("Component " + tc.image + " NOT found!");
                }
                if (tp != null) {
                        cToPort = tp.image;
                }
  }

  final public void ConnectionName() throws ParseException {
        Token t = null;
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case LPAREN:
      jj_consume_token(LPAREN);
      t = jj_consume_token(IDENTIFIER);
      jj_consume_token(RPAREN);
      break;
    default:
      jj_la1[14] = jj_gen;
      ;
    }
                if (t != null) {
                        signalName = t.image;
                }
  }

  final public void Rhs() throws ParseException {
        Token tc, tp = null, tb = null;
        int width;
    tc = jj_consume_token(IDENTIFIER);
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case DOT:
      jj_consume_token(DOT);
      tp = jj_consume_token(IDENTIFIER);
      break;
    default:
      jj_la1[15] = jj_gen;
      ;
    }
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case LPAREN:
      jj_consume_token(LPAREN);
      tb = jj_consume_token(BACK);
      jj_consume_token(RPAREN);
      break;
    default:
      jj_la1[16] = jj_gen;
      ;
    }
    jj_consume_token(SEMICOLON);
                cFrom = allComponents.get(tc.image);
                if (cFrom == null) {
                        if (allConsts.containsKey(tc.image)) {
                                //TODO gerando tamanhos diferentes ainda...
                                width = cTo.getWidth();
                                if (cToPort != null)
                                        width = ((IComponent)cTo).getPort(cToPort).getWidth();
                                cFrom = design.addComponent(new const_op(tc.image, allConsts.get(tc.image), width));
                        }
                        else
                                Error("Component or constant " + tc.image + " NOT found!");
                }
                if (tp != null) {
                        cFromPort = tp.image;
                }
                if (tb != null) {
                        backward = true;
                }
  }

  final public void Error(String s) throws ParseException {
                System.out.println(s);
                System.exit(1);
  }

  final public void Info(String s) throws ParseException {
                System.out.println("parsing: " + s);
  }

  /** Generated Token Manager. */
  public ALPGParserTokenManager token_source;
  SimpleCharStream jj_input_stream;
  /** Current token. */
  public Token token;
  /** Next token. */
  public Token jj_nt;
  private int jj_ntk;
  private int jj_gen;
  final private int[] jj_la1 = new int[17];
  static private int[] jj_la1_0;
  static private int[] jj_la1_1;
  static {
      jj_la1_init_0();
      jj_la1_init_1();
   }
   private static void jj_la1_init_0() {
      jj_la1_0 = new int[] {0x40000,0x2000,0x8000000,0x18000,0x8000000,0x18000,0x80004000,0x80000000,0x80000000,0x8000000,0x8000000,0xc0000000,0xc0000000,0x10000000,0x80000,0x10000000,0x80000,};
   }
   private static void jj_la1_init_1() {
      jj_la1_1 = new int[] {0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,};
   }

  /** Constructor with InputStream. */
  public ALPGParser(java.io.InputStream stream) {
     this(stream, null);
  }
  /** Constructor with InputStream and supplied encoding */
  public ALPGParser(java.io.InputStream stream, String encoding) {
    try { jj_input_stream = new SimpleCharStream(stream, encoding, 1, 1); } catch(java.io.UnsupportedEncodingException e) { throw new RuntimeException(e); }
    token_source = new ALPGParserTokenManager(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 17; i++) jj_la1[i] = -1;
  }

  /** Reinitialise. */
  public void ReInit(java.io.InputStream stream) {
     ReInit(stream, null);
  }
  /** Reinitialise. */
  public void ReInit(java.io.InputStream stream, String encoding) {
    try { jj_input_stream.ReInit(stream, encoding, 1, 1); } catch(java.io.UnsupportedEncodingException e) { throw new RuntimeException(e); }
    token_source.ReInit(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 17; i++) jj_la1[i] = -1;
  }

  /** Constructor. */
  public ALPGParser(java.io.Reader stream) {
    jj_input_stream = new SimpleCharStream(stream, 1, 1);
    token_source = new ALPGParserTokenManager(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 17; i++) jj_la1[i] = -1;
  }

  /** Reinitialise. */
  public void ReInit(java.io.Reader stream) {
    jj_input_stream.ReInit(stream, 1, 1);
    token_source.ReInit(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 17; i++) jj_la1[i] = -1;
  }

  /** Constructor with generated Token Manager. */
  public ALPGParser(ALPGParserTokenManager tm) {
    token_source = tm;
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 17; i++) jj_la1[i] = -1;
  }

  /** Reinitialise. */
  public void ReInit(ALPGParserTokenManager tm) {
    token_source = tm;
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 17; i++) jj_la1[i] = -1;
  }

  private Token jj_consume_token(int kind) throws ParseException {
    Token oldToken;
    if ((oldToken = token).next != null) token = token.next;
    else token = token.next = token_source.getNextToken();
    jj_ntk = -1;
    if (token.kind == kind) {
      jj_gen++;
      return token;
    }
    token = oldToken;
    jj_kind = kind;
    throw generateParseException();
  }


/** Get the next Token. */
  final public Token getNextToken() {
    if (token.next != null) token = token.next;
    else token = token.next = token_source.getNextToken();
    jj_ntk = -1;
    jj_gen++;
    return token;
  }

/** Get the specific Token. */
  final public Token getToken(int index) {
    Token t = token;
    for (int i = 0; i < index; i++) {
      if (t.next != null) t = t.next;
      else t = t.next = token_source.getNextToken();
    }
    return t;
  }

  private int jj_ntk() {
    if ((jj_nt=token.next) == null)
      return (jj_ntk = (token.next=token_source.getNextToken()).kind);
    else
      return (jj_ntk = jj_nt.kind);
  }

  private java.util.List jj_expentries = new java.util.ArrayList();
  private int[] jj_expentry;
  private int jj_kind = -1;

  /** Generate ParseException. */
  public ParseException generateParseException() {
    jj_expentries.clear();
    boolean[] la1tokens = new boolean[34];
    if (jj_kind >= 0) {
      la1tokens[jj_kind] = true;
      jj_kind = -1;
    }
    for (int i = 0; i < 17; i++) {
      if (jj_la1[i] == jj_gen) {
        for (int j = 0; j < 32; j++) {
          if ((jj_la1_0[i] & (1<<j)) != 0) {
            la1tokens[j] = true;
          }
          if ((jj_la1_1[i] & (1<<j)) != 0) {
            la1tokens[32+j] = true;
          }
        }
      }
    }
    for (int i = 0; i < 34; i++) {
      if (la1tokens[i]) {
        jj_expentry = new int[1];
        jj_expentry[0] = i;
        jj_expentries.add(jj_expentry);
      }
    }
    int[][] exptokseq = new int[jj_expentries.size()][];
    for (int i = 0; i < jj_expentries.size(); i++) {
      exptokseq[i] = (int[])jj_expentries.get(i);
    }
    return new ParseException(token, exptokseq, tokenImage);
  }

  /** Enable tracing. */
  final public void enable_tracing() {
  }

  /** Disable tracing. */
  final public void disable_tracing() {
  }

}
