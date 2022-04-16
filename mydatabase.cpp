#include "mydatabase.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>
#include <QDir>
#include <QSqlError>
#include <QFile>
#include <QDebug>
myDataBase::myDataBase(QObject* parent) : QObject (parent){}

bool myDataBase::checkConnectDB(QString dbName)
{
    QSqlDatabase db;
    if(QSqlDatabase::contains("qt_sql_default_connection"))
        db = QSqlDatabase::database("qt_sql_default_connection");
    else
        db = QSqlDatabase::addDatabase("QSQLITE");
//    QFile file("/storage/emulated/0/data/userTable.db");
//    if(!file.exists() || file.size() == 0)
//    {
//        QFile::copy("assets:/dbfile/userTable.db","/storage/emulated/0/data/userTable.db");
//        file.setPermissions(QFile::ReadUser  | QFile::WriteUser);
//    }
//    db.setDatabaseName("/storage/emulated/0/data/userTable.db");
    db.setDatabaseName(dbName);
    if(!db.open())
    {
        qDebug() << "fail to open DB";
        return false;
    }
    return true;
}

QString myDataBase::findPwd(QString id)
{
    bool conRes = checkConnectDB("./userTable.db");
    if( !conRes ) return "error";
    QSqlQuery query;
    bool res = query.exec(QString("select userPwd from usertable where userID = '%1'").arg(id));
    if(!res)
    {
        qDebug() << "sql have error" << query.lastError();
        return "error";
    }
    query.next();
    QString pwd = query.value(0).toString();
    qDebug() << "The password is = " << pwd;
    return pwd;
}

QString myDataBase::getPhone(QString id)
{
    bool conRes = checkConnectDB("./userTable.db");
    if( !conRes ) return "";
    QSqlQuery query;
    bool res = query.exec(QString("select phoneNum from usertable where userID = '%1'").arg(id));
    if(!res)
    {
        qDebug() << "sql have error" << query.lastError();
        return "";
    }
    query.next();
    QString uPhone = query.value(0).toString();
    qDebug() << "The id is = " << uPhone;
    return uPhone;
}

bool myDataBase::findPhone(QString phone)
{
    bool conRes = checkConnectDB("./userTable.db");
    if( !conRes ) return false;
    QSqlQuery query;
    bool res = query.exec(QString("select userID from usertable where phoneNum = '%1'").arg(phone));
    if(!res)
    {
        qDebug() << "sql have error" << query.lastError();
        return false;
    }
    query.next();
    QString uID = query.value(0).toString();
    qDebug() << "The id is = " << uID;
    return (uID =="" ) ? true : false;
}

bool myDataBase::insertRecord(QString phoneNum,QString userType,QString userID,QString pwd)
{
    qDebug() << "insert message" << QString("%1  %2  %3  %4").arg(phoneNum).arg(userType).arg(userID).arg(pwd);
    bool conRes = checkConnectDB("./userTable.db");
    if( !conRes ) return false;
    QSqlQuery query;
    //²åÈë
    bool sqlRes = query.exec(QString("insert into usertable values('%1','%2','%3','%4')").
                             arg(userID).arg(userType).arg(pwd).arg(phoneNum));
    if(!sqlRes)
    {
        qDebug() << "error :" << query.lastError();
        return false;
    }
    return true;
}

bool myDataBase::delRecord(QString context)
{
    bool conRes = checkConnectDB("./userTable.db");
    if( !conRes ) return false;
    QSqlQuery query;
    //É¾³ý
    bool sqlRes = query.exec(context);
    if(!sqlRes)
    {
        qDebug() << "error :" << query.lastError();
        return false;
    }
    return true;
}
