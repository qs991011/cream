
//
//  main.c
//  csapp
//
//  Created by 胜的钱 on 2018/10/19.
//  Copyright © 2018年 胜的钱. All rights reserved.
//

#include <stdio.h>
#include <netinet/in.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

int open_listenfd(int port);

int main(int argc, const char * argv[]) {
    // insert code here...
    int server_socket = open_listenfd(8887);

    if (server_socket == -1) {
        return -1;
    }
    struct sockaddr_in clnt_addr;
    socklen_t clnt_addr_size = sizeof(clnt_addr);
    int clnt_sock = accept(server_socket, (struct sockaddr*)&clnt_addr, &clnt_addr_size);
    if (clnt_sock == -1) {
        printf("appect error");
        return -1;
    }
    char str[] = "Hello world";
    write(clnt_sock, str, sizeof(str));
    close(clnt_sock);
    close(server_socket);
    
}
/**
 打开和返回一个监听描述符，这个描述符准备好在知名端口port上接受连接请求
 创建了listenfd 套接字描述符之后,我们使用setsockopt函数来配置服务器,使它能被立即停止和重启，默认地 一个重启的服务器将在大约30秒内拒绝客户端的连接请求，严重阻碍调试。
 */

int open_listenfd(int port)
{
    int listenfd, optvar=1;
    struct sockaddr_in serveraddr;

    if ((listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        return -1;
    }

    if (setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, (const void *)&optvar, sizeof(int)) < 0) {
        return -1;
    }

    /**
     Listenfd will be an end point for all requests to port on any IP address for this host
     */
    //void((char *)&serveraddr,sizeof(serveraddr));
    bzero((char *)&serveraddr,sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons((unsigned short)port);
    if (bind(listenfd, (const struct sockaddr*)&serveraddr, sizeof(serveraddr)) < 0) {
        return -1;
    }
    /**Make it a listening socket ready to accept connection requests*/
    if (listen(listenfd, 20)) {
        return -1;
    }
    return listenfd;
}
