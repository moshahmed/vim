" WHAT: set and see gvim colors
" Usage: gvim -c ':e thisfile|:so %'
" GPL(C) moshahmed_at_gmail.com
" vim:nowrap:filetype=text:

function! MoshTrackCursorCrossHair()
  " This doesn't work on win32 console bozikovic
  :autocmd BufEnter * setlocal cursorline cursorcolumn
  :hi cursorcolumn ctermbg=247 guibg=grey70 | :syn keyword cursorcolumn cursorcolumn
  :hi cursorline   ctermbg=247 guibg=grey70 | :syn keyword cursorline cursorline
endfunction
 
function! MoshColorsGui()
    " hi Sys_Window .. #9e9e9e background matches VC/Windows.
    hi Title      gui=None guifg=DarkOliveGreen | :syn keyword Title Title
   "hi Normal                                    guibg=Sys_Window
    hi Normal                                    guibg=grey75 | :syn keyword Normal Normal
    hi Visual              guifg=grey            guibg=lightyellow | :syn keyword Visual Visual
    hi Search              guifg=Black           guibg=LightYellow | :syn keyword Search Search

    hi Cursor              guifg=grey5           guibg=Red | :syn keyword Cursor Cursor
    hi NonText    gui=None guifg=DarkBlue        guibg=grey60 | :syn keyword NonText NonText
    hi Special             guifg=grey90 | :syn keyword Special Special
    hi StatusLine          guifg=grey90          guibg=darkolivegreen | :syn keyword StatusLine StatusLine
    hi Pmenu                                     guibg=grey60 | :syn keyword Pmenu Pmenu
    hi Error                                     guibg=DarkRed | :syn keyword Error Error
    hi ErrorMsg                                  guibg=DarkRed | :syn keyword ErrorMsg ErrorMsg
    hi WildMenu                                  guibg=LightYellow | :syn keyword WildMenu WildMenu
    hi Todo                                      guibg=LightYellow | :syn keyword Todo Todo
    hi Question   gui=None guifg=DarkOliveGreen | :syn keyword Question Question
    hi Directory           guifg=darkblue | :syn keyword Directory Directory
    hi WarningMsg          guifg=DarkRed | :syn keyword WarningMsg WarningMsg
    hi Underlined          guifg=#4040a0 | :syn keyword Underlined Underlined
    hi MoreMsg    gui=None guifg=#106030 | :syn keyword MoreMsg MoreMsg

    hi Constant            guifg=DarkOliveGreen | :syn keyword Constant Constant
    hi Statement  gui=NONE guifg=DarkBlue | :syn keyword Statement Statement
    hi Comment    gui=NONE guifg=DarkRed | :syn keyword Comment Comment
    hi PreProc             guifg=purple4 | :syn keyword PreProc PreProc
    hi Type       gui=NONE guifg=DarkOliveGreen | :syn keyword Type Type
    hi function            guifg=blue4 | :syn keyword function function
    hi Identifier          guifg=DarkBlue | :syn keyword Identifier Identifier
    hi Folded     gui=NONE guifg=grey55          guibg=NONE | :syn keyword Folded Folded
    hi Brighton            guifg=grey50 | :syn keyword Brighton Brighton

    hi DiffText   gui=NONE guifg=Gold            guibg=grey50 | :syn keyword DiffText DiffText
    hi DiffChange gui=NONE guifg=thistle         guibg=grey50 | :syn keyword DiffChange DiffChange
    hi DiffAdd    gui=NONE guifg=pink            guibg=grey60 | :syn keyword DiffAdd DiffAdd
    hi DiffDelete gui=NONE guifg=grey50          guibg=grey60 | :syn keyword DiffDelete DiffDelete
endfunc
 
function! MoshDefineColors()
    :hi Red1d        guifg=#8f0000       ctermfg=88 | :syn keyword Red1d Red1d
    :hi Red2d        guifg=#702020       ctermfg=94 | :syn keyword Red2d Red2d
    :hi Red3d        guifg=#500707       ctermfg=95 | :syn keyword Red3d Red3d
    :hi Red1p        guifg=#fa4740       ctermfg=196 | :syn keyword Red1p Red1p
    :hi Red2p        guifg=#f08787       ctermfg=198 | :syn keyword Red2p Red2p
    :hi Red3p        guifg=#f0a787       ctermfg=214 | :syn keyword Red3p Red3p
    :hi Blue1d       guifg=#1010f0       ctermfg=27 | :syn keyword Blue1d Blue1d
    :hi Blue2d       guifg=#101090       ctermfg=26 | :syn keyword Blue2d Blue2d
    :hi Blue3d       guifg=#103050       ctermfg=24 | :syn keyword Blue3d Blue3d
    :hi Blue1p       guifg=#8080f0       ctermfg=74 | :syn keyword Blue1p Blue1p
    :hi Blue2p       guifg=#a080f0       ctermfg=133 | :syn keyword Blue2p Blue2p
    :hi Blue3p       guifg=#70a0f0       ctermfg=44 | :syn keyword Blue3p Blue3p
    :hi Green1d      guifg=#01a001       ctermfg=70 | :syn keyword Green1d Green1d
    :hi Green2d      guifg=#017001       ctermfg=71 | :syn keyword Green2d Green2d
    :hi Green3d      guifg=#015001       ctermfg=28 | :syn keyword Green3d Green3d
    :hi Green1p      guifg=#a0f0a0       ctermfg=82 | :syn keyword Green1p Green1p
    :hi Green2p      guifg=#c0ffa0       ctermfg=84 | :syn keyword Green2p Green2p
    :hi Green3p      guifg=#c0f010       ctermfg=154 | :syn keyword Green3p Green3p
    :hi Yellow1p     guifg=#f0f000       ctermfg=226 | :syn keyword Yellow1p Yellow1p
    :hi Yellow2p     guifg=#fafa0a       ctermfg=228 | :syn keyword Yellow2p Yellow2p
    :hi Yellow3p     guifg=#fdda0a       ctermfg=220 | :syn keyword Yellow3p Yellow3p
    :hi Yellow1d     guifg=#adaa0a       ctermfg=142 | :syn keyword Yellow1d Yellow1d
    :hi Yellow2d     guifg=#8a8a01       ctermfg=144 | :syn keyword Yellow2d Yellow2d
    :hi Yellow3d     guifg=#4a4a01       ctermfg=100 | :syn keyword Yellow3d Yellow3d

    :hi brown        guifg=brown         ctermfg=130 | :syn keyword brown brown
    :hi brown4       guifg=brown4        ctermfg=124 | :syn keyword brown4 brown4
    :hi maroon       guifg=maroon        ctermfg=160 | :syn keyword maroon maroon
    :hi maroon4      guifg=maroon4       ctermfg=160 | :syn keyword maroon4 maroon4
    :hi purple4      guifg=purple4       ctermfg=160 | :syn keyword purple4 purple4
    :hi NavyBlue     guifg=NavyBlue      ctermfg=60 | :syn keyword NavyBlue NavyBlue
    :hi DeepSkyBlue4 guifg=DeepSkyBlue4  ctermfg=30 | :syn keyword DeepSkyBlue4 DeepSkyBlue4
    :hi DarkViolet   guifg=DarkViolet    ctermfg=165 | :syn keyword DarkViolet DarkViolet
    :hi DarkMagenta  guifg=DarkMagenta   ctermfg=165 | :syn keyword DarkMagenta DarkMagenta
    :hi DarkOrchid4  guifg=DarkOrchid4   ctermfg=165 | :syn keyword DarkOrchid4 DarkOrchid4
    :hi cyan4        guifg=cyan4         ctermfg=165 | :syn keyword cyan4 cyan4
    :hi DodgerBlue4  guifg=DodgerBlue4   ctermfg=165 | :syn keyword DodgerBlue4 DodgerBlue4

    :hi lightgoldenrod guifg=lightgoldenrod   guibg=grey50 ctermfg=229 ctermbg=244 | :syn keyword lightgoldenrod lightgoldenrod
    :hi gold           guifg=gold             guibg=grey50 ctermfg=220 ctermbg=244 | :syn keyword gold gold
    :hi thistle        guifg=thistle          guibg=grey50 ctermfg=218 ctermbg=244 | :syn keyword thistle thistle
    :hi PeachPuff3     guifg=PeachPuff3       guibg=grey50 ctermfg=216 ctermbg=244 | :syn keyword PeachPuff3 PeachPuff3
endfunc

function! MoshPuttyColors()
    :hi search                 ctermbg=3 | :syn keyword search search
    :hi statusline             ctermbg=186 | :syn keyword statusline statusline
    :hi statuslinenc term=none ctermbg=187 | :syn keyword statuslinenc statuslinenc

    :hi cursorcolumn ctermbg=248 | :syn keyword cursorcolumn cursorcolumn
    :hi cursorline   ctermbg=248 | :syn keyword cursorline cursorline

    :hi folded      term=none             ctermbg=249 | :syn keyword folded folded
    :hi DiffAdd                cterm=none ctermbg=250 | :syn keyword DiffAdd DiffAdd
    :hi DiffDelete ctermfg=250 cterm=none ctermbg=247 | :syn keyword DiffDelete DiffDelete
    :hi Comment    ctermfg=8 | :syn keyword Comment Comment
    :hi Statement  ctermfg=24 | :syn keyword Statement Statement

    " if version >= 700
    :au InsertEnter * hi StatusLine term=None ctermbg=229
    :au InsertLeave * hi StatusLine term=None ctermbg=186
    " endif
endfunc

function! MoshKonsoleColors()
    " Colors over 16 blink in Konsole, unset cterm and ctermbg.
    :set t_Co=16
    :hi cursorcolumn ctermbg=8 | :syn keyword cursorcolumn cursorcolumn
    :hi cursorline   ctermbg=8 term=None cterm=none | :syn keyword cursorline cursorline
    :hi StatusLine   ctermbg=8 term=None cterm=none | :syn keyword StatusLine StatusLine
    :hi Normal       ctermbg=11 | :syn keyword Normal Normal
    :au BufEnter * setlocal cursorline cursorcolumn

    :au InsertEnter * hi StatusLine term=None ctermbg=11
    :au InsertLeave * hi StatusLine term=None ctermbg=8
endfunc

function! MoshXtermColors()
    :set t_Co=256
    "set t_AB=<Char-033>[4%p1%dm
    "set t_AF=<Char-033>[3%p1%dm
    :hi Search     ctermbg=3 | :syn keyword Search Search
    :hi StatusLine cterm=bold ctermbg=8 | :syn keyword StatusLine StatusLine
    :hi Pmenu      ctermbg=8 | :syn keyword Pmenu Pmenu
    :hi Ignore     ctermfg=8 | :syn keyword Ignore Ignore

    :hi folded       ctermbg=243 | :syn keyword folded folded
    :hi DiffText     ctermfg=7   ctermbg=8 | :syn keyword DiffText DiffText
    :hi DiffChange   ctermfg=1   ctermbg=8 | :syn keyword DiffChange DiffChange
    :hi DiffAdd      ctermfg=11  ctermbg=8 | :syn keyword DiffAdd DiffAdd
    :hi DiffDelete   ctermfg=0   ctermbg=8 | :syn keyword DiffDelete DiffDelete

    " Xterm256 diff
    hi DiffText      ctermfg=9    ctermbg=255 cterm=NONE | :syn keyword DiffText DiffText
    hi DiffChange    ctermfg=9    ctermbg=252 cterm=NONE | :syn keyword DiffChange DiffChange
    hi DiffAdd       ctermfg=9    ctermbg=253 | :syn keyword DiffAdd DiffAdd
    hi DiffDelete    ctermfg=240  ctermbg=245 | :syn keyword DiffDelete DiffDelete
endfunc

function! MoshDefaultColor()
    :hi  DiffText    ctermbg=1 ctermfg=10   ctermbg=8 | :syn keyword DiffText DiffText
    :hi  DiffChange  term=NONE ctermfg=15   ctermbg=8 | :syn keyword DiffChange DiffChange
    :hi  DiffAdd     term=NONE ctermfg=15   ctermbg=8 | :syn keyword DiffAdd DiffAdd
    :hi  DiffDelete  term=NONE ctermfg=7    ctermbg=8 | :syn keyword DiffDelete DiffDelete
endfunc

call MoshTrackCursorCrossHair()
call MoshColorsGui()
call MoshDefineColors()
