" What: Thesaurus completion.
" Usage: :so % <CR> zymosis[press C-x C-o]
" How:  Perl grep_aspell word_before_cursor in thesaurus*.*
" Ref: https://stackoverflow.com/questions/33453468/vim-thesaurus-file/41754422#41754422
" =============================================================

set thesaurus=thesaurii.txt
let b:thesaurus_pat = "thesaurii.txt"

set completeopt+=menuone
set omnifunc=MoshThesaurusOmniCompleter
function!    MoshThesaurusOmniCompleter(findstart, base)
    " == First call: find-space-backwards, see :help omnifunc
    if a:findstart
        let s:line = getline('.')
        let s:wordStart = col('.') - 1
        " Check backward, accepting only non-white space
        while s:wordStart > 0 && s:line[s:wordStart - 1] =~ '\S'
            let s:wordStart -= 1
        endwhile
        return s:wordStart

    else
        " == Second call: perl grep thesaurus for word_before_cursor, output: comma separated wordlist
        " == Test: so % and altitude[press <C-x><C-o>]
        let a:word_before_cursor = substitute(a:base,'\W','.','g')
        let s:cmd='perl -ne ''chomp; '
                    \.'next if m/^[;#]/;'
                    \.'print qq/$_,/ if '
                      \.'/\b'.a:word_before_cursor.'\b/io; '' '
                    \.b:thesaurus_pat
        " == To: Debug perl grep cmd, redir to file and echom till redir END.
        " redir >> c:/tmp/vim.log
        " echom s:cmd
        let   s:rawOutput = substitute(system(s:cmd), '\n\+$', '', '')
        " echom s:rawOutput
        let   s:listing = split(s:rawOutput, ',')
        " echom join(s:listing,',')
        " redir END
        if len(s:listing) > 0
          return s:listing
        endif

        " Try spell correction with aspell: echo mispeltword | aspell -a
        let s:cmd2 ='echo '.a:word_before_cursor
            \.'|aspell -a'
            \.'|perl -lne ''chomp; next unless s/^[&]\s.*?:\s*//;  print '' '
        let   s:rawOutput2 = substitute(system(s:cmd2), '\n\+$', '', '')
        let   s:listing2 = split(s:rawOutput2, ',\s*')
        if len(s:listing2) > 0
          return s:listing2
        endif

        " Search dictionary without word delimiters.
        let s:cmd3='perl -ne ''chomp; '
                    \.'next if m/^[;#]/;'
                    \.'print qq/$_,/ if '
                      \.'/'.a:word_before_cursor.'/io; '' '
                    \.&dictionary
        let   s:rawOutput3 = substitute(system(s:cmd3), '\n\+$', '', '')
        let   s:listing3 = split(s:rawOutput3, ',\s*')
        if len(s:listing3) > 0
          return s:listing3
        endif

        " Don't return empty list
        return [a:word_before_cursor, '(no synonyms or spell correction)']

    endif
endfunction
