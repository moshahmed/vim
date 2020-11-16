" What: VLC remote control, for editing synchronizing lyrics.
" How:  Remote control vlc via tcp socket.
" GPL(C) moshahmed/at/gmail
" Usage:
"
"   1. start c:/view/vlc/vlc.exe
"   2. VLC setup: $ vlc > tools > prefs > show settings all >
"                    > main interface > Enable telnet checkbox > RC > enable RC (Remote Control),
"       Tcp-command-Input=[localhost:2150]  .. ~/sound/vlc.pl will open this socket.
"       check [donot_open console]
"   3. VIM Setup:
"     c:\> start c:/view/vlc/vlc.exe
"     c:\> vim
"          :e ~/vim/vlc.vim
"          :so %
"          :sp ~/sound/mallige.lrc
"          [F5] on mallige.mp3 to play it.
"     and cline is '[0:23.10] file:///C:/mosh/sound/mallige.mp3' .. press F5 to play from 23s
"     and cline is '[0:33.10]             ../sound/mallige.mp3'  .. press F5 to play from 23s
"
"   4. Vim audio controls:
"     [F2] Play
"     [F3] Stop
"     [F4] Pause toggle
"     [F5] Play [cfile][timestamp] on cline
"
"   5. Vim lyric synchronize keys:
"     [F9]  Get filename:time into/from vlc.
"     [F10] Get file from vlc into cline.
"     [F11] Get Time from vlc into cline.
"     [F12] Send cfile via SendToApp (specify exe path in SendToApp)
"
" Tested:
"     vlc3,     gvim82, cygwin-perl-5.26 on Win7, 2020-11-15
"     vlc2.2.6, gvim80, cygwin-perl-5.26 on Windows-7
"     vlc2.1.3, gvim74, cygwin-perl-5.22 on Windows-7
"     vlc2,     gvim73, cygwin-perl-5.14 on XP-PRO-SP4
" Testing:
"     To debug: change 'perl ~/sound/vlc.pl' to 'vimrun perl ~/sound/vlc.pl -debug'
"     0. :so %
"        :!start c:/view/vlc/vlc.exe
"        :e ~/sound/mallige.lrc
"     1. file:///c:/mosh/sound/mallige.mp3         .. press F5 play this file in vlc.
"     2. [0:1:4] file:///c:/mosh/sound/mallige.mp3 .. press F5 play this file from 64 seconds.
"     3. 0:1:5                                     .. press F5 to cue/seek vlc to 65 second.
"     4. press F9, to add [time][filename playing in vlc] to this line.
" TODO: 
"     o Test Audio filenames with spaces, unicode characters
"     o Test on Linux
" ==============================================================================

nmap <F2>   :call system("perl ~/sound/vlc.pl -cmd=play")<CR>
nmap <F3>   :call system("perl ~/sound/vlc.pl -cmd=stop")<CR>
nmap <F4>   :call system("perl ~/sound/vlc.pl -cmd=pause")<CR>
nmap <F5>   :call Vlc_Set_File_Time()<CR>

nmap <F9>   :call Vlc_Get_File_Time()<CR>
nmap <F10>  :call Vlc_Get_Filename()<CR>
nmap <F11>  :call Vlc_Get_Time()<CR><CR>
nmap <F12>  :call SendToApp()<CR>

nmap <M-Right> :call Vlc_Seek_Delta(10)
nmap <M-Left>  :call Vlc_Seek_Delta(-10)

" ==============================================================================

function! Vlc_Get_File_Time()
  :call Vlc_Get_Filename()
  :call Vlc_Get_Time()
endfunction

function! Vlc_Set_File_Time()
  " On cline look for
  " [timestamp] filename
  " file:///dir/filename
  " filename
  " [timestamp], eg. [10] for 10 seconds, [1:1] for 61 seconds.
  "  time:stamp, eg. 1:2 for 62 seconds.
  let l:matcher_file = matchlist(getline('.'),'\v<(file:///.*[.]\w+)>')
  let l:matcher_time_bracketed = matchlist(getline('.'),'\v\[(\d.*)\]')
  let l:matcher_time_digited = matchlist(getline('.'),'\v(\d+:\d[0-9:.]*)')
  let l:cfile = expand("<cfile>:p") 
  let l:mp3file = substitute(expand("%"), '[.]\w\+$', '.mp3','')

  if len(l:matcher_file) > 4 && filereadable(l:matcher_file[1])
    :echom      ("perl ~/sound/vlc.pl -cmd=set_file=" . l:matcher_file[1])
    :call system("perl ~/sound/vlc.pl -cmd=set_file=" . l:matcher_file[1])
  elseif  filereadable(l:cfile)
    :echom       "perl ~/sound/vlc.pl -cmd=set_file=file:///".l:cfile
    :call system("perl ~/sound/vlc.pl -cmd=set_file=file:///".l:cfile)
  elseif len(l:matcher_time_bracketed) > 0
    :echom      ("perl ~/sound/vlc.pl -cmd=set_time=" . l:matcher_time_bracketed[1])
    :call system("perl ~/sound/vlc.pl -cmd=set_time=" . l:matcher_time_bracketed[1])
  elseif len(l:matcher_time_digited) > 0
    :echom      ("perl ~/sound/vlc.pl -cmd=set_time=" . l:matcher_time_digited[1])
    :call system("perl ~/sound/vlc.pl -cmd=set_time=" . l:matcher_time_digited[1])
  elseif filereadable(l:mp3file)
    :echom       "perl ~/sound/vlc.pl -cmd=set_file=file:///".l:mp3file
    :call system("perl ~/sound/vlc.pl -cmd=set_file=file:///".l:mp3file)
  endif
endfunction

" ==============================================================================
function! Vlc_Get_Filename()
  let l:fileis=system("perl ~/sound/vlc.pl -cmd=get_file")
    if  len(l:fileis) < 1
      echoerr "Vlc_Get_Filename no file?"
    endif
    if l:fileis =~ '[ ,]'
      echoerr "Vlc_Get_Filename filenames has spaces etc."
    endif
    " Insert shorter relative path if possible.
    "   relfile1=$(basename fileis) 
    "   relfile2=./path/file if (fileis is file://dir/./path/file)
    let l:relfile1=substitute(l:fileis, '^.*/', '', '')
    let l:relfile2=substitute(l:fileis, '^.*/\./', './', '')
    if filereadable(l:relfile1)
      exe ':s,^, '.l:relfile1.' ,'
    elseif filereadable(l:relfile2)
      exe ':s,^, '.l:relfile2.' ,'
    else
      exe ':s,^,'.l:fileis.' ,'
    endif
endfunction

" ==============================================================================
function! Vlc_Get_Time()
    " Get current file time from vlc and insert into current line eg. [2:20]
    let l:timeis=system("perl ~/sound/vlc.pl -cmd=get_time")
    if  len(l:timeis) < 1
      echoerr "Vlc_Get_Time no time?"
    endif
    let l:timeis=substitute(l:timeis, '[^0-9:.]', '', 'g')
    let l:timeis='['.l:timeis.']'
    exe ':s/^/'.l:timeis.'/'
    " :put ='"'.l:timeis.'"'
endfunction

" ==============================================================================
function! Vlc_Seek_Delta(delta)
    " Get current file time from vlc.
    let l:timeis=system("perl ~/sound/vlc.pl -cmd=get_time")
    if  len(l:timeis) < 1
      echoerr "Vlc_Seek_Delta no time, need h:m:s?"
    endif

    " Convert timeis into seconds
    " See python https://stackoverflow.com/questions/12325291/parse-a-date-in-vimscript
    let l:hms = matchlist(l:timeis,'\v^(\d+):(\d+):(\d+)$')
    let l:ms  = matchlist(l:timeis,'\v^(\d+):(\d+)$')
    if len(l:hms) > 0
      let l:secondsis = l:hms[1] * 60*60 + l:hms[2] *60 + l:hms[3]
      "echom "l:hms=".l:hms[1].'~'.hms[2].'~'.hms[3]."=> secondsis=".l:secondsis
    elseif len(l:ms) > 0
      let l:secondsis = l:ms[1] *60  + l:ms[2]
      "echom "l:ms=".l:ms[1].'~'.l:ms[2]."=> secondsis=".l:secondsis
    else
      let l:secondsis = l:timeis
      "echom ", secondis=" . l:secondsis
    endif

    " Add delta
    let l:seekto = l:secondsis + a:delta
    :echom      ("perl ~/sound/vlc.pl -cmd=set_time=" . l:seekto)
    :call system("perl ~/sound/vlc.pl -cmd=set_time=" . l:seekto)
endfunction
 
" ==============================================================================
function! SendToApp()
    " Look for cfile (filename under cursor) in PWD
    let l:cfile = expand("<cfile>:p") 
    if !filereadable(l:cfile)
      echoerr "No cfile ".l:cfile
      return
    endif
    let l:cfile=substitute(l:cfile, '/', '\\\\', 'g')
    let l:app="c:/view/mp3directcut/mp3directcut "
    let l:app="pskill vlc "
    let l:app="c:/view/vlc/vlc "
    let l:cmd=l:app.' '.l:cfile .' &'
    :echom(l:cmd)
    :call system(l:cmd)
endfunction
" ==============================================================================
