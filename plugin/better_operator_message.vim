function! s:better_operator_message()
  let number = len(v:event['regcontents'])

  if v:event['operator'] == 'c' || v:event['operator'] == 'd'
    let message = number . ' fewer lines'
  elseif v:event['operator'] == 'y'
    let message = number . ' lines yanked'
  else
    return
  endif

  if v:event['regname'] != ''
    let message = message . ' into register ' . v:event['regname']
  endif

  " We want to temporarily disable the report message
  let s:old_report = &report
  set report=100000000

  echom message
endfunction

function! s:register_callback()
  augroup better_operator_message_callback
    autocmd!
    autocmd CursorHold * call <sid>callback()
    autocmd CursorHoldI * call <sid>callback()
    autocmd CursorMoved * call <sid>callback()
    autocmd CursorMovedI * call <sid>callback()
  augroup end
endfunction

function! s:callback()
  let &report = s:old_report
  autocmd! better_operator_message_callback
endfunction

set report=10000000000
augroup better_operator_message
  autocmd!
  autocmd TextYankPost * call <sid>better_operator_message()
augroup end
