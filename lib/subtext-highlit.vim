" What: Different syntax highlighting within regions_of a file
" From: http://vim.wikia.com/wiki/Different_syntax_highlighting_within_regions_of_a_file
" When: 2015-08-27

" Sample usage
call TextEnableCodeSnip(  'c',   '@begin=c@',   '@end=c@', 'SpecialComment')
call TextEnableCodeSnip('cpp', '@begin=cpp@', '@end=cpp@', 'SpecialComment')
call TextEnableCodeSnip('sql', '@begin=sql@', '@end=sql@', 'SpecialComment')
call TextEnableCodeSnip('html' ,'#{{{html' ,'#html}}}', 'SpecialComment') 

function! Snippet_highlight_example()
  " To Highlight this cpp snippet in a text file:
  " @begin=cpp@
  "   int q;
  "   struct w { double e };
  " @end=cpp@  
  
  " You can do this:
  :syntax on
  :syntax include @CPP syntax/cpp.vim
  :syntax region cppSnip matchgroup=Snip
    \ start="@begin=cpp@" end="@end=cpp@" contains=@CPP
  :hi link Snip SpecialComment
endfunction

function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
  \ matchgroup='.a:textSnipHl.'
  \ start="'.a:start.'" end="'.a:end.'"
  \ contains=@'.group
endfunction

