#include <arpa/inet.h>
#include <stdio.h>

int main(int argc,  char *argv[])
{
	struct in_addr s;
	char* src = argv[1];
	inet_aton(src,&s);
    char ipadd[20];
    const char* hex	= inet_ntop(AF_INET, (void *)&s, ipadd, 20);
	printf("%s\n", ipadd);
	
}