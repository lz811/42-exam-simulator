#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(stderr, "Wrong number of arguments\n");
        exit(1);
    }
    
    int port = atoi(argv[1]);
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    
    if (server_fd < 0)
    {
        fprintf(stderr, "Fatal error\n");
        exit(1);
    }
    
    struct sockaddr_in address;
    address.sin_family = AF_INET;
    address.sin_port = htons(port);
    address.sin_addr.s_addr = inet_addr("127.0.0.1");
    
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0)
    {
        fprintf(stderr, "Fatal error\n");
        exit(1);
    }
    
    if (listen(server_fd, 10) < 0)
    {
        fprintf(stderr, "Fatal error\n");
        exit(1);
    }
    
    printf("ready\n");
    close(server_fd);
    return (0);
}