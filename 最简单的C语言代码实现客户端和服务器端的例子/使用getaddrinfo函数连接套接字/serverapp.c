//
//
//  Created by qiansheng on 2019/4/23.
//  Copyright © 2019 GCI. All rights reserved.
//

#include <stdio.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <string.h>
#include <netinet/in.h>
#include <unistd.h>

int open_listenfd(char *port);
int main(int argc, char * argv[]) {
    int listenfd, connfd = 0;
    socklen_t clientlen;
    if (argc != 2) {
        printf("must two params \n");
        return 0;
    }
    char *port = argv[1];
    listenfd = open_listenfd(port);
    int connd = accept(listenfd, (struct sockaddr*)&clientlen, &clientlen);
    if (connfd < 1) {
        printf("appect error");
    }
    char str[] = "qiansheng \n";
    write(connd, str, sizeof(str));
    close(connfd);
    close(listenfd);
    return 0;
}


int open_listenfd(char *port) {
    
    struct addrinfo hints, *listp, *p;
    int listenfd = 0, optval = 1;
    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE | AI_ADDRCONFIG; // 被动的  任何IP address
    hints.ai_flags |= AI_NUMERICSERV; // use port number
    getaddrinfo(NULL, port, &hints, &listp);
    
    for (p = listp; p ; p = p->ai_next) {
        if ((listenfd = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) < 0) {
            continue;
        }
        
        setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, (const void *)&optval, sizeof(int));
        
        if (bind(listenfd, p->ai_addr, p->ai_addrlen) == 0) {
            break;//Success
        }
        close(listenfd);
    }
    
    freeaddrinfo(listp);
    if (!p) {
        return -1;
    }
    if (listen(listenfd, 30) < 0) {
        close(listenfd);
        return -1;
    }
    return listenfd;
}

