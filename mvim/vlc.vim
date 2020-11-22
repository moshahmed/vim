" What: VLC remote control, for editing synchronizing lyrics.
" How:  Remote control vlc via tcp socket.
" GPL(C) moshahmed/at/gmail
" Usage:
"
"   1. start c:/view/vlc/vlc.exe
"   2. VLC setup: $ vlc > tools > prefs > show settings all >
"                    > main interface > Enable telnet checkbox > RC > enable RC (Remote Control),
"       Tcp-command-Input=[localhost:2150]  .. ~/mvim/vlc.pl will open this socket.
"       check [donot_open console]
"   3. VIM Setup:
"     c:\> start c:/view/vlc/vlc.exe
"     c:\> vim
"          :e ~/vim/vlc.vim
"          :so %
"          :sp ~/sound/mallige.lrc
"          [F5] on mallige.mp3 to play it.
"     and cline is '[0:33.10]             ../sound/mallige.mp3'  .. press F5 to play from 23s
"
"   +------------------------------+----------------------------------------+
"   | 4. Vim audio controls:       | 5. Vim lyric synchronize keys:         |
"   +------------------------------+----------------------------------------+
"   | [F12] Start vlc on [cfile]   | [F9]  Get filename:time into/from vlc. |
"   | [F2] Play                    | [F10] Get file from vlc into cline.    |
"   | [F3] Stop                    | [F11] Get Time from vlc into cline.    |
"   | [F4] Pause toggle            | [F1]  This help                        |
"   | [F5] Play [cfile][timestamp] | [C-F12] Kill vlc                       |
"   +------------------------------+----------------------------------------+
"
" Tested:
"     vlc3,     gvim82, cygwin-perl-5.26 on Win7, 2020-11-15
"     vlc2.2.6, gvim80, cygwin-perl-5.26 on Windows-7
"     vlc2.1.3, gvim74, cygwin-perl-5.22 on Windows-7
"     vlc2,     gvim73, cygwin-perl-5.14 on XP-PRO-SP4
" Testing:
"     To debug: change 'perl ~/mvim/vlc.pl' to 'vimrun perl ~/mvim/vlc.pl -debug'
"     0. :so %
"        :!start c:/view/vlc/vlc.exe
"        :e ~/sound/mallige.lrc
"     .  mallige.mp3                               .. Press F12 to play, C-F12 to kill VLC
"     1. file:///c:/mosh/sound/mallige.mp3         .. press F5 play this file in vlc.
"     2. [0:1:4] file:///c:/mosh/sound/mallige.mp3 .. press F5 play this file from 64 seconds.
"     3. 0:1:5                                     .. press F5 to cue/seek vlc to 65 second.
"     4. press F9, to add [time][filename playing in vlc] to this line.
" TODO:
"     o Test Audio filenames with spaces, unicode characters
"     o Test on Linux
" ==============================================================================

nmap <F1>   :call Vlc_Lrc_Help()<CR>
nmap <F2>   :call system("perl ~/mvim/vlc.pl -cmd=play")<CR>
nmap <F3>   :call system("perl ~/mvim/vlc.pl -cmd=stop")<CR>
nmap <F4>   :call system("perl ~/mvim/vlc.pl -cmd=pause")<CR>
nmap <F5>   :call Vlc_Set_File_Time()<CR>

nmap <F9>   :call Vlc_Get_File_And_Time()<CR>
nmap <F10>  :call Vlc_Get_Filename()<CR>
nmap <F11>  :call Vlc_Get_Time()<CR><CR>
nmap <F12>  :call Vlc_Play_File('')<CR>
nmap <C-F12> :call system("pskill vlc ")<CR>

nmap <M-Right> :call Vlc_Seek_Delta(10)<CR>
nmap <M-Left>  :call Vlc_Seek_Delta(-10)<CR>

" ==============================================================================
function! Vlc_Lrc_Help()
  echo "   | [F12] Start vlc on [cfile]   | [F9]  Get filename:time into/from vlc. |"
  echo "   | [F2] Play                    | [F10] Get file from vlc into cline.    |"
  echo "   | [F3] Stop                    | [F11] Get Time from vlc into cline.    |"
  echo "   | [F4] Pause toggle            | [F1]  This help.                       |"
  echo "   | [F5] Play [cfile][timestamp] | [C-F12] Kill vlc.                      |"
endfunc

function! Vlc_Get_File_And_Time()
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
  " let l:lrcmedia = substitute(expand("%"), '[.]\w\+$', '.mp3','')

  if len(l:matcher_file) > 4 && filereadable(l:matcher_file[1])
    :echom      ("perl ~/mvim/vlc.pl -cmd=set_file=" . l:matcher_file[1])
    :call system("perl ~/mvim/vlc.pl -cmd=set_file=" . l:matcher_file[1])
  elseif  filereadable(l:cfile)
    :echom       "perl ~/mvim/vlc.pl -cmd=set_file=file:///".l:cfile
    :call system("perl ~/mvim/vlc.pl -cmd=set_file=file:///".l:cfile)
  elseif len(l:matcher_time_bracketed) > 0
    :echom      ("perl ~/mvim/vlc.pl -cmd=set_time=" . l:matcher_time_bracketed[1])
    :call system("perl ~/mvim/vlc.pl -cmd=set_time=" . l:matcher_time_bracketed[1])
  elseif len(l:matcher_time_digited) > 0
    :echom      ("perl ~/mvim/vlc.pl -cmd=set_time=" . l:matcher_time_digited[1])
    :call system("perl ~/mvim/vlc.pl -cmd=set_time=" . l:matcher_time_digited[1])
  else
    :let l:lrcmedia = Vlc_Find_Lrc_Media( expand('%') )
    :echom       "perl ~/mvim/vlc.pl -cmd=set_file=file:///".l:lrcmedia
    :call system("perl ~/mvim/vlc.pl -cmd=set_file=file:///".l:lrcmedia)
  endif
endfunction

" ==============================================================================
function! Vlc_Get_Filename()
  let l:fileis=system("perl ~/mvim/vlc.pl -cmd=get_file")
    if len(l:fileis) < 1 || l:fileis =~ "connection refused"
      echom 'Error Vlc_Get_Filename:'.l:fileis
      return
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
    let l:timeis=system("perl ~/mvim/vlc.pl -cmd=get_time")
    if len(l:timeis) < 1 || l:timeis =~ "connection refused"
      echom 'Error Vlc_Get_Time:'.l:timeis
      return
    endif
    let l:timeis=substitute(l:timeis, '[^0-9:.]', '', 'g')
    let l:timeis='['.l:timeis.']'
    exe ':s/^/'.l:timeis.'/'
endfunction

" ==============================================================================
function! Vlc_Seek_Delta(delta)
    " Get current file time from vlc.
    let l:timeis=system("perl ~/mvim/vlc.pl -cmd=get_time")
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
    :echom      ("perl ~/mvim/vlc.pl -cmd=set_time=" . l:seekto)
    :call system("perl ~/mvim/vlc.pl -cmd=set_time=" . l:seekto)
endfunction

" ==============================================================================
function! Vlc_Play_File(infile)
    " Convert file.lrc to media file.mp3
    let l:cfile = Vlc_Find_Lrc_Media(a:infile)
    if l:cfile == '' || !filereadable(l:cfile)
      echom "No media file to play?"
      return
    endif

    " DosPath
    let l:cfile=substitute(l:cfile, '/', '\\\\', 'g')

    "let l:app="c:/view/mp3directcut/mp3directcut "
    "let l:app="c:/view/vlc/vlc "
    "let l:cmd='start '.l:app.' '.l:cfile.' &'
    ":echom(l:cmd)
    "call system(l:cmd)
    :exe '!start /B c:/view/vlc/vlc '.l:cfile
endfunction

function! Vlc_Find_Lrc_Media(infile)
  " Input:   mallige.lrc or cursor on mallige.txt or while editing mallige.txt
  " Returns: mallige.mp3 to play with vlc
  " No error if file not found.

  " Find a media file: given, under cursor, current filename.
  if a:infile != '' && filereadable(a:infile)
    let l:cfile = a:infile
  else
    let l:cfile = expand("<cfile>:p")
    if !filereadable(l:cfile)
      let l:cfile=expand('%')
    endif
  endif

  " Convert cfile to mp3file
  for l:ext in ['.mp3', '.m4a', '.avi', '.m4k', '.m4v', '.mkv', '.mp4', '.avi', '.flac', '.aac']
    let l:mp3file = substitute( l:cfile, '[.]\w\+$', l:ext,'')
    if filereadable(l:mp3file)
      let l:mp3file = fnamemodify(l:mp3file, ':p')
      echom("Found ".l:mp3file)
      return l:mp3file
    endif
  endfor

  return ''

endfun

