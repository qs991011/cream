//
//  clintapp.c
//  csapp
//
//  Created by 胜的钱 on 2018/10/19.
//  Copyright © 2018年 胜的钱. All rights reserved.
//

#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <netdb.h>
#include <string.h>

int open_clientfd(char *hostname,int port);

int main()
{
    //最好用不常用的端口号 并且与serverapp.c 文件中的端口一致。
    int sock_cli = open_clientfd("172.31.42.208",8887);
    if (sock_cli == -1) {
        printf("creat socket error");
    }
    char str[64];
    read(sock_cli, str, 64);
    printf("%s", str);
    
    close(sock_cli);
}

int open_clientfd(char *hostname,int port)
{
    int clientfd;
    struct hostent *hp;
    struct sockaddr_in serveraddr;
    // 创建套接字
    if ((clientfd = socket(AF_INET, SOCK_STREAM, 0))<0 ){
        return -1;
    }
    
    if ((hp = gethostbyname(hostname)) == NULL ){
        printf("网址不对");
        return -1;
    }
    bzero((char *)&serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    bcopy((char *)hp->h_addr_list[0], (char *)&serveraddr.sin_addr.s_addr, hp->h_length);
    serveraddr.sin_port = htons(port);
    //serveraddr.sin_addr.s_addr = inet_addr("61.135.169.125");
    if (connect(clientfd, (const struct sockaddr*)&serveraddr, sizeof(serveraddr)) < 0 ) {
        return -1;
    }
    return clientfd;
    
}


