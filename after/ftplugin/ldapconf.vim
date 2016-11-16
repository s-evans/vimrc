" define a custom help handler for ldap.conf files
function! s:ViewDoc_ldapconf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man ldap.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_ldapconf=[ function('s:ViewDoc_ldapconf') ]
