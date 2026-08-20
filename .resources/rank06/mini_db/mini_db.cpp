#include "mini_db.hpp"
#include <map>
#include <iostream>
#include <string>
#include <cstdlib>
#include <signal.h>
#include <fstream>

std::string path;
std::map<std::string, std::string> db;

void sigIntHandler(int)
{
    std::ofstream file(path);
    if(!file.is_open()){
        std::cerr << "Invalid file path" << std::endl;
    }
    else{
        for(auto it = db.begin(); it != db.end(); ++it){
            std::string key, value;
            file << it->first << " " << it->second << std::endl;
        }
        file.close();
    }
    exit(0);
}

void readDb()
{
    std::ifstream file(path);
    if(!file.is_open()){
        return;
    }
    std::string key, value;
    while(file >> key >> value){
        db[key] = value;
    }
    return;
}

int main(int ac, char *av[])
{
    if(ac != 3){
        std::cerr << "Wrong number of arguments" << std::endl;
        return EXIT_FAILURE;
    }
    signal(SIGINT, sigIntHandler);
    path = std::string(av[2]);
    readDb();
    try{
        Server server(atoi(av[1]), db);
        server.run();
    }
    catch(const std::exception &e){
        std::cerr << "Internal server error" << std::endl;
        return EXIT_FAILURE;
    }

	return EXIT_SUCCESS;
}
