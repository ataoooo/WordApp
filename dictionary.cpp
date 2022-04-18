#include "dictionary.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>
#include <QDir>
#include <QSqlError>
#include <QFile>
#include <QDebug>
#include <QSqlRecord>
Dictionary::Dictionary(QObject* parent) : QObject (parent){}

bool Dictionary::connectDB()
{
    QSqlDatabase db;
    if(QSqlDatabase::contains("qt_sql_default_connection"))
        db = QSqlDatabase::database("qt_sql_default_connection");
    else
        db = QSqlDatabase::addDatabase("QSQLITE");


    //    QFile file("/storage/emulated/0/data/lookup.db");
    //    if(!file.exists() || file.size() == 0)
    //    {
    //        QFile::copy("assets:/dbfile/lookup.db","/storage/emulated/0/data/lookup.db");
    //        file.setPermissions(QFile::ReadUser  | QFile::WriteUser);
    //    }
    //    db.setDatabaseName("/storage/emulated/0/data/lookup.db");

    db.setDatabaseName("./lookup.db");
    if(!db.open())
    {
        qDebug() << "fail to open DB";
        return false;
    }
    return true;
}

QVariantList Dictionary::searchWord(QString prefiex)
{
    if(connectDB()==false)
    {
        return QVariantList();
    }
    QSqlQuery query;
    //²éÑ¯
    bool sqlRes = query.exec(QString("select word from allWords"));
    if(!sqlRes)
    {
        qDebug() << "error :" << query.lastError();
        return QVariantList();
    }
    QVariantList zoneIdList;
    bool start = false;
    while(query.next())
    {
        QString tmpWord = query.value(0).toString();
        if( tmpWord.indexOf(prefiex) == 0 )
        {
            start = true;
            zoneIdList.push_back(tmpWord);
        }
        else if( start ) break;
    }
    return  zoneIdList;
}

QVariantList Dictionary::searchTargetWord(QString word)
{
    if(connectDB()==false)
    {
        qDebug() << "connect db fail";
        return QVariantList();
    }
    QSqlQuery query;
    //²éÑ¯
    qDebug() << "The word is = " << word;
    bool sqlRes = query.exec(QString("select * from allWords where word = '%1'").arg(word));
    if(!sqlRes)
    {
        qDebug() << "error :" << query.lastError();
        return QVariantList();
    }
    QVariantList zoneIdList;
    query.next();
    for(int i = 0 ; i < query.record().count() ; ++ i)
    {
        qDebug() << "word context : = " << query.value(i).toString();
        zoneIdList.push_back(query.value(i).toString());
    }

    //Ç°×º´Ê
    sqlRes = query.exec(QString("select * from prefixes where variant = '%1'").arg(word));
    if(!sqlRes)
    {
        qDebug() << "error :" << query.lastError();
        return QVariantList();
    }
    query.next();
    zoneIdList.push_back(query.value(1).toString());

    return zoneIdList;
}

