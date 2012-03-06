/* Generated By:JavaCC: Do not edit this line. ALPGParserConstants.java */
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


/**
 * Token literal values and constants.
 * Generated by org.javacc.parser.OtherFilesGen#start()
 */
public interface ALPGParserConstants {

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
  int BACK = 17;
  /** RegularExpression Id. */
  int CONST = 18;
  /** RegularExpression Id. */
  int LPAREN = 19;
  /** RegularExpression Id. */
  int RPAREN = 20;
  /** RegularExpression Id. */
  int LBRACE = 21;
  /** RegularExpression Id. */
  int RBRACE = 22;
  /** RegularExpression Id. */
  int LBRACKET = 23;
  /** RegularExpression Id. */
  int RBRACKET = 24;
  /** RegularExpression Id. */
  int ASSIGN = 25;
  /** RegularExpression Id. */
  int SEMICOLON = 26;
  /** RegularExpression Id. */
  int COMMA = 27;
  /** RegularExpression Id. */
  int DOT = 28;
  /** RegularExpression Id. */
  int AT = 29;
  /** RegularExpression Id. */
  int CONST_INTEGER = 30;
  /** RegularExpression Id. */
  int IDENTIFIER = 31;

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
    "\"backward\"",
    "\"const\"",
    "\"(\"",
    "\")\"",
    "\"{\"",
    "\"}\"",
    "\"[\"",
    "\"]\"",
    "\"<-\"",
    "\";\"",
    "\",\"",
    "\".\"",
    "\"@\"",
    "<CONST_INTEGER>",
    "<IDENTIFIER>",
    "\"=\"",
    "\":\"",
  };

}
