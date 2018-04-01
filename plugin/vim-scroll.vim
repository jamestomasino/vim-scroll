" Execute :ScrollDown or :ScrollUp to start auto movement of the cursor.
" Press <Space> or <Escape> to stop it.

" BUG: Our <Esc> and <Space>  mapping may be overwriting others, if not when
" created then when later cleared.  I tried <SID><Esc> but it didn't work!

if !exists("g:AutoScrollSpeed")
  let g:AutoScrollSpeed = 500
endif

command! ScrollDown call <SID>StartScrolling("j","zz")
command! ScrollUp call <SID>StartScrolling("k","zz")
command! StopScrolling call <SID>StopScrolling()

function! s:StartScrolling(action1,action2)
  let s:action1 = a:action1
  let s:action2 = a:action2
  if exists(":RepeatLastOff")
    :RepeatLastOff
  endif
  if !exists("s:initialUpdateTime")
    let s:initialUpdateTime = &updatetime
  endif
  let &updatetime = g:AutoScrollSpeed
  augroup SCROLLING
    autocmd!
    autocmd CursorMoved * exec "normal ".s:action2
    autocmd CursorHold * exec "normal ".s:action1
  augroup END
  map <silent> <Esc> :call <SID>StopScrolling()<Enter>
  map <silent> <Space> :call <SID>StopScrolling()<Enter>
endfunction

function! s:StopScrolling()
  augroup SCROLLING
    autocmd!
  augroup END
  unmap <silent> <Esc>
  unmap <silent> <Space>
  let &updatetime = s:initialUpdateTime
endfunction
