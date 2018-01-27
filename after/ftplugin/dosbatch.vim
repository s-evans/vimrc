if executable('cmd')
    " use the dos help command
    function! s:ViewDoc_doshelp(topic, filetype, synid, ctx)
        let l:tmp_topic=shellescape(a:topic,1)
        let l:output=system('cmd /C help '.l:tmp_topic)
        if match(l:output, 'This command is not supported by the help utility') != -1
            return {}
        else
            return { 'cmd': 'cmd /C help '.l:tmp_topic,
                        \ 'ft':	'dosbatch',
                        \ }
        endif
    endfunction

    " define a custom handler for dosbatch
    let g:ViewDoc_dosbatch=[ function('s:ViewDoc_doshelp') ]
endif
