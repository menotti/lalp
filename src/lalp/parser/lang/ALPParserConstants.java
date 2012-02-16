/* Generated By:JJTree&JavaCC: Do not edit this line. ALPParserConstants.java */
/* Copyright (c) 2009 João M. P. Cardoso <jmpc@acm.org>, All Rights Reserved.
 * Copyright (c) 2009 Ricardo Menotti <ricardomenotti@acm.org>, All Rights Reserved.
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
 * Token literal values and constants.
 * Generated by org.javacc.parser.OtherFilesGen#start()
 */
public interface ALPParserConstants {

  /** End of File. */
  int EOF = 0;
  /** RegularExpression Id. */
  int SINGLE_LINE_COMMENT = 9;
  /** RegularExpression Id. */
  int FORMAL_COMMENT = 10;
  /** RegularExpression Id. */
  int MULTI_LINE_COMMENT = 11;
  /** RegularExpression Id. */
  int TYPEDEF = 13;
  /** RegularExpression Id. */
  int FIXED = 14;
  /** RegularExpression Id. */
  int IN = 15;
  /** RegularExpression Id. */
  int OUT = 16;
  /** RegularExpression Id. */
  int CONST = 17;
  /** RegularExpression Id. */
  int COUNTER = 18;
  /** RegularExpression Id. */
  int WHEN = 19;
  /** RegularExpression Id. */
  int ASSERT = 20;
  /** RegularExpression Id. */
  int CHECK = 21;
  /** RegularExpression Id. */
  int FOREACH = 22;
  /** RegularExpression Id. */
  int CHANGES = 23;
  /** RegularExpression Id. */
  int AS = 24;
  /** RegularExpression Id. */
  int CLOCK = 25;
  /** RegularExpression Id. */
  int INTEGER_LITERAL = 26;
  /** RegularExpression Id. */
  int DECIMAL_LITERAL = 27;
  /** RegularExpression Id. */
  int HEX_LITERAL = 28;
  /** RegularExpression Id. */
  int CHARACTER_LITERAL = 29;
  /** RegularExpression Id. */
  int STRING_LITERAL = 30;
  /** RegularExpression Id. */
  int IDENTIFIER = 31;
  /** RegularExpression Id. */
  int LETTER = 32;
  /** RegularExpression Id. */
  int DIGIT = 33;
  /** RegularExpression Id. */
  int LPAREN = 34;
  /** RegularExpression Id. */
  int RPAREN = 35;
  /** RegularExpression Id. */
  int LBRACE = 36;
  /** RegularExpression Id. */
  int RBRACE = 37;
  /** RegularExpression Id. */
  int LBRACKET = 38;
  /** RegularExpression Id. */
  int RBRACKET = 39;
  /** RegularExpression Id. */
  int SEMICOLON = 40;
  /** RegularExpression Id. */
  int COMMA = 41;
  /** RegularExpression Id. */
  int DOT = 42;
  /** RegularExpression Id. */
  int ASSIGN = 43;
  /** RegularExpression Id. */
  int AT = 44;
  /** RegularExpression Id. */
  int GT = 45;
  /** RegularExpression Id. */
  int LT = 46;
  /** RegularExpression Id. */
  int BANG = 47;
  /** RegularExpression Id. */
  int TILDE = 48;
  /** RegularExpression Id. */
  int HOOK = 49;
  /** RegularExpression Id. */
  int COLON = 50;
  /** RegularExpression Id. */
  int EQ = 51;
  /** RegularExpression Id. */
  int LE = 52;
  /** RegularExpression Id. */
  int GE = 53;
  /** RegularExpression Id. */
  int NE = 54;
  /** RegularExpression Id. */
  int SC_OR = 55;
  /** RegularExpression Id. */
  int SC_AND = 56;
  /** RegularExpression Id. */
  int INCR = 57;
  /** RegularExpression Id. */
  int DECR = 58;
  /** RegularExpression Id. */
  int PLUS = 59;
  /** RegularExpression Id. */
  int MINUS = 60;
  /** RegularExpression Id. */
  int STAR = 61;
  /** RegularExpression Id. */
  int SLASH = 62;
  /** RegularExpression Id. */
  int BIT_AND = 63;
  /** RegularExpression Id. */
  int BIT_OR = 64;
  /** RegularExpression Id. */
  int XOR = 65;
  /** RegularExpression Id. */
  int REM = 66;
  /** RegularExpression Id. */
  int LSHIFT = 67;
  /** RegularExpression Id. */
  int RSIGNEDSHIFT = 68;
  /** RegularExpression Id. */
  int RUNSIGNEDSHIFT = 69;
  /** RegularExpression Id. */
  int PLUSASSIGN = 70;
  /** RegularExpression Id. */
  int MINUSASSIGN = 71;
  /** RegularExpression Id. */
  int STARASSIGN = 72;
  /** RegularExpression Id. */
  int SLASHASSIGN = 73;
  /** RegularExpression Id. */
  int ANDASSIGN = 74;
  /** RegularExpression Id. */
  int ORASSIGN = 75;
  /** RegularExpression Id. */
  int XORASSIGN = 76;
  /** RegularExpression Id. */
  int REMASSIGN = 77;
  /** RegularExpression Id. */
  int LSHIFTASSIGN = 78;
  /** RegularExpression Id. */
  int RSIGNEDSHIFTASSIGN = 79;
  /** RegularExpression Id. */
  int RUNSIGNEDSHIFTASSIGN = 80;

  /** Lexical state. */
  int DEFAULT = 0;
  /** Lexical state. */
  int IN_SINGLE_LINE_COMMENT = 1;
  /** Lexical state. */
  int IN_FORMAL_COMMENT = 2;
  /** Lexical state. */
  int IN_MULTI_LINE_COMMENT = 3;

  /** Literal token values. */
  String[] tokenImage = {
    "<EOF>",
    "\" \"",
    "\"\\t\"",
    "\"\\n\"",
    "\"\\r\"",
    "\"\\f\"",
    "\"//\"",
    "<token of kind 7>",
    "\"/*\"",
    "<SINGLE_LINE_COMMENT>",
    "\"*/\"",
    "\"*/\"",
    "<token of kind 12>",
    "\"typedef\"",
    "\"fixed\"",
    "\"in\"",
    "\"out\"",
    "\"const\"",
    "\"counter\"",
    "\"when\"",
    "\"assert\"",
    "\"check\"",
    "\"foreach\"",
    "\"changes\"",
    "\"as\"",
    "\"clock\"",
    "<INTEGER_LITERAL>",
    "<DECIMAL_LITERAL>",
    "<HEX_LITERAL>",
    "<CHARACTER_LITERAL>",
    "<STRING_LITERAL>",
    "<IDENTIFIER>",
    "<LETTER>",
    "<DIGIT>",
    "\"(\"",
    "\")\"",
    "\"{\"",
    "\"}\"",
    "\"[\"",
    "\"]\"",
    "\";\"",
    "\",\"",
    "\".\"",
    "\"=\"",
    "\"@\"",
    "\">\"",
    "\"<\"",
    "\"!\"",
    "\"~\"",
    "\"?\"",
    "\":\"",
    "\"==\"",
    "\"<=\"",
    "\">=\"",
    "\"!=\"",
    "\"||\"",
    "\"&&\"",
    "\"++\"",
    "\"--\"",
    "\"+\"",
    "\"-\"",
    "\"*\"",
    "\"/\"",
    "\"&\"",
    "\"|\"",
    "\"^\"",
    "\"%\"",
    "\"<<\"",
    "\">>\"",
    "\">>>\"",
    "\"+=\"",
    "\"-=\"",
    "\"*=\"",
    "\"/=\"",
    "\"&=\"",
    "\"|=\"",
    "\"^=\"",
    "\"%=\"",
    "\"<<=\"",
    "\">>=\"",
    "\">>>=\"",
    "\"*@\"",
  };

}
