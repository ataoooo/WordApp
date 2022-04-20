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
    //查询
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
    //查询
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

    //前缀词
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

QVariant Dictionary::getSentence(QString str)
{
    if(connectDB()==false)
    {
        qDebug() << "connect db fail";
        return QVariantList();
    }
    QSqlQuery query;
    //查询
    qDebug() << "The word is = " << str;
    bool sqlRes = query.exec(QString("select * from sentence where englishWord = '%1'").arg(str));
    if(!sqlRes)
    {
        qDebug() << "error :" << query.lastError();
        return QVariantList();
    }
    QVariantList zoneIdList;
    query.next();
    for(int i = 3 ; i < 7 ; ++ i)
    {
        qDebug() << "word context : = " << query.value(i).toString();
        if(query.value(i).toString() == "") return zoneIdList;
        zoneIdList.push_back(query.value(i).toString());
    }
    return zoneIdList;
}

bool Dictionary::createCollectTable(int sno)
{
    if(connectDB()==false)
    {
        qDebug() << "connect db fail";
        return false;
    }
    QSqlQuery query;
    QString tablename = "collectTable" + QString::number(sno);
    qDebug() << "The tablename is = " << tablename;
    bool sqlRes = query.exec(QString("create table %1 "
                                     "(word text primary key,accent text,mean_cn text,freq int,"
                                     "wordlength int,exID int,tenses text,voice text)").arg(tablename));
    if(!sqlRes)
    {
        qDebug() << "error :" << query.lastError();
        return false;
    }
    return true;
}

bool Dictionary::createEditBook(int sno)
{
    if(connectDB()==false)
    {
        qDebug() << "connect db fail";
        return false;
    }
    QSqlQuery query;
    QString tablename = "editTable" + QString::number(sno);
    qDebug() << "The tablename is = " << tablename;
    bool sqlRes = query.exec(QString("create table %1 (word text primary key,accent text,mean_cn text,freq int,wordlength int,exID int,tenses text,voice text)").arg(tablename));
    if(!sqlRes)
    {
        qDebug() << "error :" << query.lastError();
        return false;
    }
    return true;
}

bool Dictionary::createImportTable(int sno)
{
    if(connectDB()==false)
    {
        qDebug() << "connect db fail";
        return false;
    }
    QSqlQuery query;
    QString tablename = "ImportTable" + QString::number(sno);
    qDebug() << "The tablename is = " << tablename;
    bool sqlRes = query.exec(QString("create table %1 (word text primary key,mean_cn text)").arg(tablename));
    if(!sqlRes)
    {
        qDebug() << "error :" << query.lastError();
        return false;
    }
    return true;
}

bool Dictionary::saveWordToBook(QString bookname,QString word,QString accent,QString mean_cn,int freq,
                                int wordlength,int exID,QString tenses,QString voice){
    createEditBook(bookname.toInt());
    QSqlQuery query;
    QString tablename = "editTable" + bookname;
    //删除目标记录
    bool res = query.exec(QString("delete from %1 where word = '%2'").arg(tablename).arg(word));
    if(!res)
        qDebug() << "delete error :" << query.lastError();
    //插入
    res = query.exec(QString("insert into %1 values('%2','%3','%4',%5,%6,%7,'%8','%9')")
                     .arg(tablename).arg(word).arg(accent).arg(mean_cn).arg(freq).arg(wordlength).arg(exID).arg(tenses).arg(voice));
    if(!res)
    {
        qDebug() << "insert error :" << query.lastError();
        return false;
    }
    return true;
}

bool Dictionary::collectWord(QString bookname,QString word,QString accent,QString mean_cn,int freq,
                             int wordlength,int exID,QString tenses,QString voice)
{
    createCollectTable(bookname.toInt());
    QSqlQuery query;
    QString tablename = "collectTable" + bookname;
    qDebug() << "The table name is = " << tablename;
    qDebug() << word;
    qDebug() << accent;
    qDebug() << mean_cn;
    qDebug() << freq;
    qDebug() << wordlength;
    qDebug() << exID;
    qDebug() << tenses;
    qDebug() << voice;
    //插入
    bool res = query.exec(QString("insert into %1 values('%2','%3','%4',%5,%6,%7,'%8','%9')")
                     .arg(tablename).arg(word).arg(accent).arg(mean_cn).arg(freq).arg(wordlength).arg(exID).arg(tenses).arg(voice));
    if(!res)
    {
        qDebug() << "insert error :" << query.lastError();
        return false;
    }
    return true;
}

bool Dictionary::cancelCollect(QString bookname,QString word)
{
    createCollectTable(bookname.toInt());
    QSqlQuery query;
    QString tablename = "collectTable" + bookname;
    //插入
    bool res = query.exec(QString("delete from %1 where word = '%2'").arg(tablename).arg(word));
    if(!res)
    {
        qDebug() << "insert error :" << query.lastError();
        return false;
    }
    return true;
}

bool Dictionary::isCollect(QString bookname,QString word)
{
    QString tablename = "collectTable" + bookname;
    QSqlQuery query;
    bool res = query.exec(QString("select word from %1 where word = '%2'").arg(tablename).arg(word));
    query.next();
    return query.value(0).toString() != "";
}

bool Dictionary::importWord(QString sno,QString word,QString mean){
    createImportTable(sno.toInt());
    QString tablename = "ImportTable" + sno;
    //插入
    QSqlQuery query;
    bool res = query.exec(QString("insert into %1 values('%2','%3')").arg(tablename).arg(word).arg(mean));
    if(!res)
    {
        qDebug() << "insert error :" << query.lastError();
        return false;
    }
    return true;
}
