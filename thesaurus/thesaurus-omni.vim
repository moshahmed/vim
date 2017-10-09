" What: Thesaurus completion.
" Usage: :so % <CR> zymosis[press C-x C-o]
" How:  Perl grep thesaurus*.*
" Ref: https://stackoverflow.com/questions/33453468/vim-thesaurus-file/41754422#41754422
" =============================================================
set completeopt+=menuone
set thesaurus=thesaurii.txt
set omnifunc=MoshThesaurusOmniCompleter
let b:thesaurus_pat = "thesaurii.txt"
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
        let a:word_before_cursor = substitute(a:base,'\W','.','g')
        let s:cmd='perl -ne ''chomp; '
                    \.'next if m/^[;#]/;'
                    \.'print qq/$_,/ if '
                      \.'/\b'.a:word_before_cursor.'\b/io; '' '
                    \.b:thesaurus_pat
        let   s:rawOutput = system(s:cmd)
        let   s:listing = split(s:rawOutput, ',')
        return s:listing
    endif
endfunction
