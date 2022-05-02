#include "dictionary.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>
#include <QDir>
#include <QSqlError>
#include <QFile>
#include <QDebug>
#include <QSqlRecord>
#include <ctime>

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

QVariantList Dictionary::searchWord(QString wordName,QString prefiex)
{
    if(connectDB()==false)
    {
        return QVariantList();
    }
    QSqlQuery query;
    //查询
    bool sqlRes = query.exec(QString("select word from '%1' order by word ASC").arg(wordName));
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

QVariantList Dictionary::searchTargetWord(QString wordName, QString word)
{
    if(connectDB()==false)
    {
        qDebug() << "connect db fail";
        return QVariantList();
    }
    QSqlQuery query;
    //查询
    qDebug() << "The word is = " << word;
    bool sqlRes = query.exec(QString("select * from '%1' where word = '%2'").arg(wordName).arg(word));
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

void Dictionary::createAllWordTable(QString sno)
{
    if(connectDB()==false)
    {
        qDebug() << "connect db fail";
        return;
    }
    QSqlQuery query;
    QString tablename = "allWords" + sno;
    qDebug() << "The tablename is = " << tablename;
    bool sqlRes = query.exec(QString("create table %1 as select * from allWords").arg(tablename));
    if(!sqlRes)
        qDebug() << "error :" << query.lastError();
    return;
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

bool Dictionary::saveWordToBook(QString bookname,QString word,QString accent,QString mean_cn,
                                QString tenses,QString origin){
    QSqlQuery query;
    bool res = query.exec(QString("update '%1' set accent = '%2' where word = '%3'").arg(bookname).arg(accent).arg(word));
    res = query.exec(QString("update '%1' set mean_cn = '%2' where word = '%3'").arg(bookname).arg(mean_cn).arg(word));
    res = query.exec(QString("update '%1' set tenses = '%2' where word = '%3'").arg(bookname).arg(tenses).arg(word));
    res = query.exec(QString("update '%1' set origin = '%2' where word = '%3'").arg(bookname).arg(origin).arg(word));
    if(!res)
    {
        qDebug() << "insert error :" << query.lastError();
        return false;
    }
    return true;
}

bool Dictionary::collectWord(QString bookname,QString word)
{
    QSqlQuery query;
    bool res = query.exec(QString("update '%1' set collect = 1 where word = '%3'")
                          .arg(bookname).arg(word));
    if(!res)
    {
        qDebug() << "insert error :" << query.lastError();
        return false;
    }
    return true;
}

bool Dictionary::cancelCollect(QString bookname,QString word)
{
    QSqlQuery query;
    qDebug() << "Table name is = " << bookname << "  and = " << word;
    bool res = query.exec(QString("update %0 set collect = 0 where word = '%2'").arg(bookname).arg(word));
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
    if(!res){
        qDebug() << "227 The error is = " << query.lastError();
    }
    query.next();
    return query.value(0).toString() != "";
}

QVariantList Dictionary::collectWords(QString bookname)
{
    if(connectDB()==false)
    {
        qDebug() << "connect db fail";
        return QVariantList{};
    }
    QString tableName = "allWords" + bookname;
    qDebug() << "collect table is = " << tableName;
    QSqlQuery query;
    bool res = query.exec(QString("select word,mean_cn from %1 where collect = 1").arg(tableName));
    if(!res)
    {
        qDebug() << "insert error :" << query.lastError();
        return QVariantList{};
    }
    QVariantList wordlist;
    while(query.next())
    {
        QString tmps = query.value(0).toString() + '&' + query.value(1).toString();
        wordlist.push_back(tmps);
    }
    return wordlist;
}

bool Dictionary::importWord(QString sno,QString word,QString mean){
    createImportTable(sno.toInt());
    QString tablename = "ImportTable" + sno;
    //插入
    QSqlQuery query,query2;
    bool res = query.exec(QString("select * from '%1'").arg(tablename));
    if(!res) return false;
    while(query.next())
    {
        res = query.exec(QString("update '%1' set mean_cn = '%2' where word = '%3'").arg(tablename).arg(mean).arg(word));
        return res;
    }
    res = query.exec(QString("insert into %1 values('%2','%3')").arg(tablename).arg(word).arg(mean));
    if(!res)
    {
        qDebug() << "insert error :" << query.lastError();
        return false;
    }
    return true;
}

QVariantList Dictionary::lastErrorWord(QString sno){
    if(connectDB()==false)
    {
        qDebug() << "connect db fail";
        return QVariantList{};
    }
    QString tablename = "allWords" + sno;
    QSqlQuery query,query1;
    bool res = query.exec(QString("select word,mean_cn,occurrence from '%1' where lastMistake = 1").arg(tablename));
    if(!res){
        qDebug() << "the sql is error" << query.lastError();
        return QVariantList{};
    }
    QVariantList wordlist;
    int i = 0;
    while(query.next())
    {
        if(i == 10) break;
        ++i;
        QString tmps = query.value(0).toString() + '&' + query.value(1).toString();
        if(query.value(2).toInt() < 5)
        {
            qDebug() << "write the appear is = " << query.value(2).toInt();
            query1.exec(QString("update '%1' set occurrence = %2 where word = '%3'").arg(tablename).arg(query.value(2).toInt() + 1).arg(query.value(0).toString()));
        }
        wordlist.push_back(tmps);
    }
    qDebug() << "Last error num is = " << wordlist.size();
    return wordlist;
}

QVariantList Dictionary::rememberWord(QString sno,int num,float lev1,float lev2,
                                      float lev3,float lev4)
{
    srand(time(0));
    if(connectDB()==false)
    {
        qDebug() << "connect db fail";
        return QVariantList{};
    }
    QString tablename = "allWords" + sno;
    if(sno == "-1") tablename = "allWords";
    QSqlQuery query,query1;
    qDebug() << "the num = " << num << "   and name is = " << tablename << " -1: " << lev1
             << " -2: " << lev2 << " -3: " << lev3 << " -4: " << lev4;
    QVariantList wordlist{};
    int haveRem = 0;    //已经熟背的最多只占40%
    int n = 0;          //其他词数
    //------------------------------------筛选最难----------------------------
    n = num * lev4;
    qDebug() << "the result of n4 = " << n;
    haveRem = n * 0.4;
    n -= haveRem;
    bool res = query.exec(QString("select * from '%1' where word_length between 26 and 40 "
                                  "order by occurrence asc,freq asc,accuracy asc").arg(tablename));
    if(!res)
    {
        qDebug() << "The lev4 is error"<< query.lastError();
        return wordlist;
    }
    while(query.next()){
        if(query.value(13).toInt() == 1) continue;
        if(n == 0 && haveRem == 0) break;
        if( haveRem == 0 && query.value(11).toInt() == 5 ) break;
        if(query.value(11).toInt() == 5) --haveRem;
        else if(n > 0) --n;
        else --haveRem;
        QString tmps = query.value(1).toString() + '&' + query.value(3).toString();
        //出现次数+1
        if(query.value(12).toInt() < 5)
            query1.exec(QString("update '%1' set occurrence = %2 where word = '%3'").arg(tablename).arg(query.value(12).toInt() + 1).arg(query.value(1).toString()));
        wordlist.insert(rand()%(wordlist.size() + 1),tmps);
    }

    //------------------------------------筛选较难----------------------------
    n += haveRem;   //上一阶段难度所剩单词
    n += num * lev3;
    qDebug() << "the result of n3 = " << n;    haveRem = n * 0.4;
    n -= haveRem;
    res = query.exec(QString("select * from '%1' where word_length between 16 and 25 "
                             "order by occurrence asc,freq asc,accuracy asc").arg(tablename));
    if(!res)
    {
        qDebug() << "The lev3 is error"<< query.lastError();
        return wordlist;
    }
    while(query.next()){
        if(query.value(13).toInt() == 1) continue;
        if(n == 0 && haveRem == 0) break;
        if( haveRem == 0 && query.value(11).toInt() == 5 ) break;
        if(query.value(11).toInt() == 5) --haveRem;
        else if(n > 0) --n;
        else --haveRem;
        QString tmps = query.value(1).toString() + '&' + query.value(3).toString();
        if(query.value(12).toInt() < 5)
            query1.exec(QString("update '%1' set occurrence = %2 where word = '%3'").arg(tablename).arg(query.value(12).toInt() + 1).arg(query.value(1).toString()));
        wordlist.insert(rand()%(wordlist.size() + 1),tmps);
    }


    //------------------------------------筛选较简单----------------------------
    n += haveRem;   //上一阶段难度所剩单词
    n += num * lev2;
    qDebug() << "the result of n2 = " << n;    haveRem = n * 0.4;
    n -= haveRem;
    res = query.exec(QString("select * from '%1' where word_length between 6 and 15 "
                             "order by occurrence asc,freq asc,accuracy asc").arg(tablename));
    if(!res)
    {
        qDebug() << "The lev2 is error"<< query.lastError();
        return wordlist;
    }
    while(query.next()){
        if(query.value(13).toInt() == 1) continue;
        if(n == 0 && haveRem == 0) break;
        if( haveRem == 0 && query.value(11).toInt() == 5 ) break;
        if(query.value(11).toInt() == 5) --haveRem;
        else if(n > 0) --n;
        else --haveRem;
        QString tmps = query.value(1).toString() + '&' + query.value(3).toString();
        if(query.value(12).toInt() < 5)
            query1.exec(QString("update '%1' set occurrence = %2 where word = '%3'").arg(tablename).arg(query.value(12).toInt() + 1).arg(query.value(1).toString()));
        wordlist.insert(rand()%(wordlist.size() + 1),tmps);
    }

    //------------------------------------筛选简单----------------------------
    n = num - wordlist.size();
    qDebug() << "the result of n1 = " << n;
    res = query.exec(QString("select * from '%1' where word_length between 0 and 5 "
                             "order by occurrence asc,freq asc,accuracy asc").arg(tablename));
    if(!res)
    {
        qDebug() << "The lev2 is error"<< query.lastError();
        return wordlist;
    }
    while(query.next()){
        if(query.value(13).toInt() == 1) continue;
        if(n == 0) break;
        --n;
        QString tmps = query.value(1).toString() + '&' + query.value(3).toString();
        if(query.value(12).toInt() < 5)
            query1.exec(QString("update '%1' set occurrence = %2 where word = '%3'").arg(tablename).arg(query.value(12).toInt() + 1).arg(query.value(1).toString()));
        wordlist.insert(rand()%(wordlist.size() + 1),tmps);
    }
    qDebug() << "The number of word is = " << wordlist.size();

    return wordlist;
}

QVariantList Dictionary::getAllWords(QString tablename){
    if(connectDB() == false) return QVariantList{};
    QSqlQuery query;
    qDebug() << "The table name is = " << tablename;
    bool res = query.exec(QString("select word,mean_cn from '%1'").arg(tablename));
    if(!res)
    {
        qDebug() << "select error : = " << query.lastError();
        return QVariantList{};
    }
    QVariantList wordlist;
    while(query.next())
    {
        QString tmps = query.value(0).toString() + "\n" + query.value(1).toString();
        wordlist.push_back(tmps);
    }
    return wordlist;
}

QVariantList Dictionary::getAllSentence(){
    if(connectDB() == false) return QVariantList{};
    QSqlQuery query;
    QString tablename = "sentence";
    qDebug() << "The table name is = " << tablename;
    bool res = query.exec(QString("select * from '%1'").arg(tablename));
    if(!res)
    {
        qDebug() << "select error : = " << query.lastError();
        return QVariantList{};
    }
    QVariantList wordlist;
    while(query.next())
    {
        //单词+句子1英中+句子二英中
        QString tmps = query.value(0).toString() + "&" + query.value(3).toString() + "&" + query.value(4).toString()
                + "&" + query.value(5).toString() + "&" + query.value(6).toString();
        wordlist.push_back(tmps);
    }
    return wordlist;
}

void Dictionary::insertToRemember(int sno)
{
    if(connectDB() == false) return;
    QSqlQuery query;
    bool res = query.exec(QString("insert into rememberTable(usersno) values(%1)").arg(sno));
    if(!res)
    {
        qDebug() << "insert into table error" << query.lastError();
        return;
    }
    qDebug() << "insert into success!";
    return;
}

void Dictionary::setDiffer(int sno,int wordNum,int diff)
{
    if(connectDB() == false) return;
    qDebug() << "The upgrade information is = " << sno << "  and " << wordNum << " " << diff;
    QSqlQuery query;
    bool res = query.exec(QString("UPDATE rememberTable SET wordNum=%1,diff=%2 WHERE usersno=%3;").arg(wordNum).arg(diff).arg(sno));
    if(!res)
    {
        qDebug() << "error is = " << query.lastError();
        return;
    }
}

QVariantList Dictionary::getDiffer(int sno)
{
    if(sno == -1)
    {
        return QVariantList{20,1};
    }
    if(connectDB() == false) return QVariantList{};
    QSqlQuery query;
    qDebug() << "The sno is = " << sno;
    bool res = query.exec(QString("select * from rememberTable WHERE usersno = %1;").arg(sno));
    if(!res)
    {
        qDebug() << "error is = " << query.lastError();
        return QVariantList{};
    }
    QVariantList info;
    while(query.next())
    {
        info.push_back(query.value(1).toInt());
        info.push_back(query.value(2).toInt());
    }
    return info;
}

void Dictionary::setAccuracy(QString sno,QString word,int isTrue)
{
    if(connectDB() == false) return;
    QSqlQuery query;
    QString tablename = "allWords" + sno;
    bool res = query.exec(QString("select accuracy from '%1' where word = '%2'").arg(tablename).arg(word));
    if(!res)
    {
        qDebug() << "The error is = " << query.lastError();
        return;
    }
    query.next();
    int tmpn = query.value(0).toInt();
    qDebug() << "The accuracy is = " << tmpn;
    if((!isTrue && tmpn < 1) || (isTrue && tmpn > 4)) return;
    if(isTrue) ++tmpn;
    else  --tmpn;
    res = query.exec(QString("update '%1' set accuracy = %2 where word = '%3'").arg(tablename).arg(tmpn).arg(word));
    if(!res)
    {
        qDebug() << "The error is = " << query.lastError();
    }
}

void Dictionary::setLastMistake(QString sno,QString word,int notTrue)
{
    if(connectDB() == false) return;
    QSqlQuery query;
    QString tablename = "allWords" + sno;
    bool res = query.exec(QString("update '%1' set lastMistake = %2 where word = '%3'").arg(tablename).arg(notTrue).arg(word));
    if(!res)
    {
        qDebug() << "The error is = " << query.lastError();
    }
}

QVariantList Dictionary::calculateWord(QString sno){
    if(connectDB() == false) return QVariantList{};
    QSqlQuery query;
    QString tablename = "allWords" + sno;
    if(sno == "-1") tablename = "allWords";
    bool res = query.exec(QString("select accuracy,occurrence from %1").arg(tablename));
    if(!res)
    {
        qDebug() << "The error is = " << query.lastError();
        return QVariantList{};
    }
    int a1(0),a2(0),a3(0),a4(0);
    while(query.next()){
        if(query.value(0).toInt() == 0 && query.value(1).toInt() > 0) ++a1;
        else if(query.value(0).toInt() < 3 && query.value(0).toInt() > 0) ++a2;
        else if(query.value(0).toInt() < 5 && query.value(0).toInt() > 2) ++a3;
        else if(query.value(0).toInt() == 5) ++a4;
    }
    if(sno == "-1")
    {
        a1 = 100;
    }
    qDebug() << "The a1:::" << a1 << " " << a2 << " " << a3 << " " << a4;
    QVariantList tmplis;
    tmplis.push_back(a1);
    tmplis.push_back(a2);
    tmplis.push_back(a3);
    tmplis.push_back(a4);
    return tmplis;
}
