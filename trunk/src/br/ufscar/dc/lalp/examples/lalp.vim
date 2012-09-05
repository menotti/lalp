" Vim syntax file
" Language:     LALP
" Filenames:    *.alp
" Maintainer:   Ricardo Menotti  <menotti@gmail.com>
" URL:          http://lalp.dc.ufscar.br/lalp.vim
" Last Change:  2012 June 29 - initial version

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Errors
syn match    lalpParErr     ")"
syn match    lalpBrackErr   "]"
syn match    lalpBraceErr   "}"

" Enclosing delimiters
syn region   lalpEncl transparent matchgroup=lalpParEncl start="(" matchgroup=lalpParEncl end=")" contains=ALLBUT,lalpParErr
syn region   lalpEncl transparent matchgroup=lalpBrackEncl start="\[" matchgroup=lalpBrackEncl end="\]" contains=ALLBUT,lalpBrackErr
syn region   lalpEncl transparent matchgroup=lalpBraceEncl start="{" matchgroup=lalpBraceEncl end="}" contains=ALLBUT,lalpBraceErr

" Comments
syn region   lalpComment start="//" end="$" contains=lalpComment,lalpTodo
syn region   lalpComment start="/\*" end="\*/" contains=lalpComment,lalpTodo
syn keyword  lalpTodo contained TODO FIXME XXX LALP

" General keywords
syn keyword  lalpKeyword  const typedef fixed in out counter when

" Component ports
syn keyword  lalpType address step init done

" Special chars
syn match    lalpKeyChar  "@"
syn match    lalpKeyChar  "="
syn match    lalpKeyChar  ";"
syn match    lalpKeyChar  "->"

" Identifier
syn match    lalpIdentifier /\<\w\+\>/

" Synchronization
syn sync minlines=50
syn sync maxlines=500

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_lalp_syntax_inits")
  if version < 508
    let did_lalp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink lalpParErr	 Error
  HiLink lalpBraceErr	 Error
  HiLink lalpBrackErr	 Error

  HiLink lalpComment	 Comment
  HiLink lalpTodo	 Todo

  HiLink lalpParEncl	 Keyword
  HiLink lalpBrackEncl	 Keyword
  HiLink lalpBraceEncl	 Keyword

  HiLink lalpKeyword	 Keyword
  HiLink lalpType	 Type
  HiLink lalpKeyChar	 Keyword

  HiLink lalpIdentifier	 Identifier

  delcommand HiLink
endif

let b:current_syntax = "lalp"

" vim: ts=8
