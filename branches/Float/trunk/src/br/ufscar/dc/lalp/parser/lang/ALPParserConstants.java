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

package br.ufscar.dc.lalp.parser.lang;


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
  int UFIXED = 15;
  /** RegularExpression Id. */
  int SFIXED = 16;
  /** RegularExpression Id. */
  int FLOAT = 17;
  /** RegularExpression Id. */
  int SIGNED = 18;
  /** RegularExpression Id. */
  int UNSIGNED = 19;
  /** RegularExpression Id. */
  int BIT = 20;
  /** RegularExpression Id. */
  int IN = 21;
  /** RegularExpression Id. */
  int OUT = 22;
  /** RegularExpression Id. */
  int CONST = 23;
  /** RegularExpression Id. */
  int COUNTER = 24;
  /** RegularExpression Id. */
  int WHEN = 25;
  /** RegularExpression Id. */
  int ASSERT = 26;
  /** RegularExpression Id. */
  int CHECK = 27;
  /** RegularExpression Id. */
  int FOREACH = 28;
  /** RegularExpression Id. */
  int CHANGES = 29;
  /** RegularExpression Id. */
  int AS = 30;
  /** RegularExpression Id. */
  int CLOCK = 31;
  /** RegularExpression Id. */
  int WAIT = 32;
  /** RegularExpression Id. */
  int IMPORT = 33;
  /** RegularExpression Id. */
  int MODULE = 34;
  /** RegularExpression Id. */
  int FLOAT_LITERAL = 35;
  /** RegularExpression Id. */
  int INTEGER_LITERAL = 36;
  /** RegularExpression Id. */
  int DECIMAL_LITERAL = 37;
  /** RegularExpression Id. */
  int HEX_LITERAL = 38;
  /** RegularExpression Id. */
  int CHARACTER_LITERAL = 39;
  /** RegularExpression Id. */
  int STRING_LITERAL = 40;
  /** RegularExpression Id. */
  int IDENTIFIER = 41;
  /** RegularExpression Id. */
  int LETTER = 42;
  /** RegularExpression Id. */
  int DIGIT = 43;
  /** RegularExpression Id. */
  int LPAREN = 44;
  /** RegularExpression Id. */
  int RPAREN = 45;
  /** RegularExpression Id. */
  int LBRACE = 46;
  /** RegularExpression Id. */
  int RBRACE = 47;
  /** RegularExpression Id. */
  int LBRACKET = 48;
  /** RegularExpression Id. */
  int RBRACKET = 49;
  /** RegularExpression Id. */
  int SEMICOLON = 50;
  /** RegularExpression Id. */
  int COMMA = 51;
  /** RegularExpression Id. */
  int DOT = 52;
  /** RegularExpression Id. */
  int ASSIGN = 53;
  /** RegularExpression Id. */
  int AT = 54;
  /** RegularExpression Id. */
  int GT = 55;
  /** RegularExpression Id. */
  int LT = 56;
  /** RegularExpression Id. */
  int BANG = 57;
  /** RegularExpression Id. */
  int TILDE = 58;
  /** RegularExpression Id. */
  int HOOK = 59;
  /** RegularExpression Id. */
  int COLON = 60;
  /** RegularExpression Id. */
  int EQ = 61;
  /** RegularExpression Id. */
  int LE = 62;
  /** RegularExpression Id. */
  int GE = 63;
  /** RegularExpression Id. */
  int NE = 64;
  /** RegularExpression Id. */
  int SC_OR = 65;
  /** RegularExpression Id. */
  int SC_AND = 66;
  /** RegularExpression Id. */
  int INCR = 67;
  /** RegularExpression Id. */
  int DECR = 68;
  /** RegularExpression Id. */
  int PLUS = 69;
  /** RegularExpression Id. */
  int MINUS = 70;
  /** RegularExpression Id. */
  int STAR = 71;
  /** RegularExpression Id. */
  int SLASH = 72;
  /** RegularExpression Id. */
  int BIT_AND = 73;
  /** RegularExpression Id. */
  int BIT_OR = 74;
  /** RegularExpression Id. */
  int XOR = 75;
  /** RegularExpression Id. */
  int REM = 76;
  /** RegularExpression Id. */
  int LSHIFT = 77;
  /** RegularExpression Id. */
  int RSIGNEDSHIFT = 78;
  /** RegularExpression Id. */
  int RUNSIGNEDSHIFT = 79;
  /** RegularExpression Id. */
  int PLUSASSIGN = 80;
  /** RegularExpression Id. */
  int MINUSASSIGN = 81;
  /** RegularExpression Id. */
  int STARASSIGN = 82;
  /** RegularExpression Id. */
  int SLASHASSIGN = 83;
  /** RegularExpression Id. */
  int ANDASSIGN = 84;
  /** RegularExpression Id. */
  int ORASSIGN = 85;
  /** RegularExpression Id. */
  int XORASSIGN = 86;
  /** RegularExpression Id. */
  int REMASSIGN = 87;
  /** RegularExpression Id. */
  int LSHIFTASSIGN = 88;
  /** RegularExpression Id. */
  int RSIGNEDSHIFTASSIGN = 89;
  /** RegularExpression Id. */
  int RUNSIGNEDSHIFTASSIGN = 90;
  /** RegularExpression Id. */
  int HASH = 91;

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
    "\"ufixed\"",
    "\"sfixed\"",
    "\"float\"",
    "\"signed\"",
    "\"unsigned\"",
    "\"bit\"",
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
    "\"wait\"",
    "\"import\"",
    "\"module\"",
    "<FLOAT_LITERAL>",
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
    "\"#\"",
    "\"*@\"",
  };

}
