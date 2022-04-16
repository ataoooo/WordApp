#include "dictionary.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>
#include <QDir>
#include <QSqlError>
#include <QFile>
#include <QDebug>
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
    bool sqlRes = query.exec(QString("select word from dict_a_b"));
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

