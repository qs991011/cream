#include <arpa/inet.h>
#include <stdio.h>

int main(int argc,  char *argv[])
{
	struct in_addr s;
    char* ipadd = argv[1];
    printf("%s\n", ipadd);
    inet_pton(AF_INET,ipadd,(void *)&s);
    printf("0x%x\n", s.s_addr);
	
}