#include <iostream>
#include <stdexcept>
#include <cstring>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <map>
#include <sstream>
#include <fstream>

class Socket
{
private:
	struct sockaddr_in _servaddr;

public:
	int _sockfd;
	Socket(int port) :
			_sockfd(socket(AF_INET, SOCK_STREAM, 0))
		{
			if(_sockfd == -1){
				throw std::runtime_error("Socket creation failed");
			}

			memset(&_servaddr, 0, sizeof(_servaddr));
			_servaddr.sin_family = AF_INET;
			_servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
			_servaddr.sin_port = htons(port);
		}

	~Socket()
		{
			if (_sockfd != -1)
			{
				close(_sockfd);
			}
		}
	void bindAndListen()
		{
			if(bind(_sockfd, (struct sockaddr *)&_servaddr, sizeof(_servaddr)) < 0)
			{
				throw std::runtime_error("Socket bind failed");
			}

			if (listen(_sockfd, 10) < 0)
			{
				throw std::runtime_error("Socket listen failed");
			}
		}
	int accept(struct sockaddr_in& clientAddr)
		{
			socklen_t clientLen = sizeof(clientAddr);
			int clientSocketFd = ::accept(_sockfd, (struct sockaddr*)&clientAddr, &clientLen);
			if(clientSocketFd < 0)
			{
				throw std::runtime_error("Failed to accept connection");
			}
			return clientSocketFd;
		}
    std::string pullMessage(int fd)
    {
		char buf[1024];
		int bytes_read = recv(fd, buf, 1023, 0);
		if(bytes_read <= 0)
			return std::string("");
		buf[bytes_read] = '\0';
		std::string res(buf);
		return res;
    }
};

class Server
{
private:
	Socket _listeningSocket;
    fd_set afds, wfds, rfds;
	int max_fd;
    std::map<std::string, std::string> &db;

public:
	Server(int port, std::map<std::string, std::string> &db) :_listeningSocket(port), db(db)
	{
		FD_ZERO(&afds);
    }
	int handleMessage(int fd, std::string msg)
	{
		std::istringstream s(msg);
		std::string command, key, value;
		s >> command >> key >> value;

		if(command == "GET" && value.empty()){
			auto it = db.find(key);
			if(it == db.end()){
				return send(fd, "1\n", 2, 0);
			}
			std::string res = "0 " + it->second + '\n';
			return send(fd, res.c_str(), res.size(), 0);
		}
		else if(command == "POST" && !value.empty()){
			db[key] = value;
			return send(fd, "0\n", 2, 0);
		}
		else if(command == "DELETE" && value.empty()){
			auto it = db.find(key);
			if(it == db.end()){
				return send(fd, "1\n", 2, 0);
			}
			db.erase(key);
			return send(fd, "0\n", 2, 0);
		}
		else{
			return send(fd, "2\n", 2, 0);
		}
	}
	int run()
		{
			sockaddr_in clientAddr;
			try
			{
				_listeningSocket.bindAndListen();
				FD_SET(_listeningSocket._sockfd, &afds);
				max_fd = _listeningSocket._sockfd;

				std::cout << "ready" << std::endl;

				while(true){
					rfds = afds;
					wfds = afds;

					if(select(max_fd + 1, &rfds, &wfds, NULL, NULL) < 0)
						throw std::runtime_error("Failed to select");

					for(int fd = 0; fd <= max_fd; ++fd){
						if(!FD_ISSET(fd, &rfds))
							continue;

						if(fd == _listeningSocket._sockfd){
							int clientFd = _listeningSocket.accept(clientAddr);
							FD_SET(clientFd, &afds);
							max_fd = std::max(max_fd, clientFd);
							break;
						}
						else{
							std::string msg = _listeningSocket.pullMessage(fd);
							if(msg.empty()){
								FD_CLR(fd, &afds);
								close(fd);
							}
							handleMessage(fd, msg);
						}
					}
				}

				return 0; // Success
			}
			catch(const std::exception& e)
			{
				std::cerr << "Error during server run: " << e.what() << std::endl;
				return 1; // Return error code if server fails to start
			}
		}
};
