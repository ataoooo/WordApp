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
    bool initDB(false); //是否需要建表
    QFile file(dbName);
    if(!file.exists())
    {
        qDebug() << "file do not exit";
        file.open( QIODevice::ReadWrite | QIODevice::Text );
        file.close();
        initDB = true;
    }
    QSqlDatabase db;
    if(QSqlDatabase::contains("qt_sql_default_connection"))
        db = QSqlDatabase::database("qt_sql_default_connection");
    else
        db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbName);
    if(!db.open())
    {
        qDebug() << "fail to open DB";
        return false;
    }
    if(initDB)
    {
        qDebug() << "need to create table";
        QSqlQuery query;
        //创建用户表，四个属性 id 用户类别 密码 和 电话号码
        bool sqlRes = query.exec("create table usertable (userID varchar(20) primary key, "
                   "userType varchar(20) not NULL,userPwd varchar(30) not NULL,phoneNum varchar(15) not NULL)");
        if(!sqlRes)
        {
            qDebug() << "The error is " << query.lastError();
            return false;
        }
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

bool myDataBase::insertRecord(QString& phoneNum,QString& userType,QString& userID,QString& pwd)
{
    bool conRes = checkConnectDB("./userTable.db");
    if( !conRes ) return false;
    QSqlQuery query;
    //插入
    bool sqlRes = query.exec(QString("insert into usertable values('%1','%2','%3','%4')").
                             arg(userID).arg(userType).arg(pwd).arg(phoneNum));
    if(!sqlRes)
    {
        qDebug() << "error :" << query.lastError();
        return false;
    }
    return true;
}
