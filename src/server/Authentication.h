#include "Messages.h"

class Database;

class Authentication
{
    public:
        Authentication();
        bool loginAuth(const Login& data);


    private:
        Database* db;
};
