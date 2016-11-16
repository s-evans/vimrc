" define a custom help handler for dnsmasq files
function! s:ViewDoc_dnsmasq(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man dnsmasq',
                \'ft':     'man',
                \'search': a:topic,
                \}
endfunction
let g:ViewDoc_dnsmasq=[ function('s:ViewDoc_dnsmasq') ]
