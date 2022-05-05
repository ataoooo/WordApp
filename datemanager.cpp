#include "datemanager.h"
#include<QSqlDatabase>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>
#include <QFile>
DateManager::DateManager(QObject* parent) : QObject (parent){}

bool DateManager::connectDB()
{
    QSqlDatabase db;
    if(QSqlDatabase::contains("qt_sql_default_connection"))
        db = QSqlDatabase::database("qt_sql_default_connection");
    else
        db = QSqlDatabase::addDatabase("QSQLITE");


    //----------------复制文件至手机文件夹------------------

//    QFile file("/storage/emulated/0/data/lookup.db");
//    if(!file.exists() || file.size() == 0)
//    {
//        QFile::copy("assets:/dbfile/lookup.db","/storage/emulated/0/data/lookup.db");
//        file.setPermissions(QFile::ReadUser  | QFile::WriteUser);
//    }
//    db.setDatabaseName("/storage/emulated/0/data/lookup.db");
    //----------------复制文件至手机文件夹------------------

    db.setDatabaseName("./lookup.db");
    if(!db.open())
    {
        qDebug() << "fail to open DB";
        return false;
    }
    return true;
}

QDateTime DateManager::getTime(int i)
{
    return QDateTime::currentDateTime().addSecs(360).addDays(i);
}

QString DateManager::getCurrenTime(int i)
{
    return getTime(i).toString("yyyy-MM-dd");
}

int DateManager::getNum(int sno,int time,bool isSum)
{
    QString stime= getCurrenTime(time);
    qDebug() << "the time is = " << stime << " and " << sno;
    if(connectDB() == false) return 0;
    QSqlQuery query;
    bool res = query.exec(QString("select * from dateTable where usersno = %1 and time = '%2'").arg(sno).arg(stime));
    if(!res)
    {
        qDebug() << "fail...:" << query.lastError();
        return 0;
    }
    int sum(0),yn(0);
    while(query.next())
    {
        sum = query.value(2).toInt();
        yn = query.value(3).toInt();
    }
    qDebug() << "The result of it is = " << sum << " and " << yn;
    if( isSum ) return sum;
    return yn;
}

QDateTime DateManager::stringToDate(QString tmp)
{
    QDateTime time = QDateTime::fromString(tmp,"yyyy-MM-dd");
    return time;
}

QString DateManager::DateToString(QDateTime time)
{
    QString stime = time.toString("yyyy-MM-dd");
    return stime;
}

void DateManager::insetRecord(int uson,QString date,int sum,int yesw)
{
    if(connectDB() == false) return;
    QSqlQuery query;
    bool res = query.exec(QString("select * from dateTable where usersno = %1 and time = '%2'").arg(uson).arg(date));
    if(!res)
    {
        qDebug() << "select error is = " << query.lastError();
        return;
    }
    int uo = -1,n = 0,ny = 0;
    while (query.next()) {
        n= query.value(2).toInt();
        ny = query.value(3).toInt();
        uo = query.value(0).toInt();
    }
    qDebug() << "get number = " << n << " and " << ny;
    if(uo == uson)
    {
        qDebug() << "insert";
        res = query.exec(QString("update dateTable set wordSum = %1,rightWord = %2 where usersno = %3 and time = '%4'").arg(n + sum).arg(ny + yesw).arg(uson).arg(date));
        if(!res)
            qDebug() << "select 2error is = " << query.lastError();
        return;
    }
    res = query.exec(QString("insert into dateTable values(%1,'%2',%3,%4)").arg(uson).arg(date).arg(sum).arg(yesw));
    if(!res)
        qDebug() << "select 2error is = " << query.lastError();
    return;
}
