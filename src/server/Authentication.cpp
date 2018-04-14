#include "Authentication.h"
#include "Database.h"
#include <QDebug>

Authentication::Authentication(): db(nullptr)
{
    db = Database::getInstance();
}

bool Authentication::loginAuth(const Login& data)
{

    if(db->verifyUser(data._name, data._password))
        return true;

    return false;
}
