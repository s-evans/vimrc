syntax match ciscoIfName /\<\(FastEthernet\|Port-channel\|Vlan\|Loopback\|Tunnel\|Dialer\)[0-9][0-9]*\>/
syn match ciscoIfName +\<\(Ethernet\|FastEthernet\|GigabitEthernet\|TenGigabitEthernet\|Serial\)[0-9][0-9]*/[0-9][0-9]*\(/[0-9][0-9]*\)\?\(\.[0-9][0-9]*\)\?\>+
syn match ciscoIfName +\<ATM[0-9][0-9]*\(/[0-9][0-9]*\)*\(\.[0-9][0-9]*\)\?\>+
hi def link ciscoIfName Identifier
