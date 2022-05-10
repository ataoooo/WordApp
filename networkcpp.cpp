#include "networkcpp.h"
#include <QMediaPlayer>
#include <QEventLoop>
#include <QTimer>
Networkcpp::Networkcpp(QObject* parent) : QObject (parent){}

void Networkcpp::setTargetWebUrl(QString webUrl)
{
    if(m_manager != nullptr)
    {
        delete  m_manager;
        m_manager = nullptr;
    }
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager,SIGNAL(finished(QNetworkReply*)),this,SLOT(slot_replayFinished(QNetworkReply*)));
    //发送请求
    m_manager->get(QNetworkRequest(QUrl(webUrl)));
}

void Networkcpp::slot_replayFinished(QNetworkReply * reply)
{
    //使用utf-8编码，可显示中文
    QTextCodec* codec = QTextCodec::codecForName("utf8");
    m_context = codec->toUnicode(reply->readAll());
    //qDebug() << "The web context is = " << m_context;
    reply->deleteLater();//最后要释放replay对象
}

QString Networkcpp::speakWord()
{
    //解析字符串
    int seat = m_context.indexOf("\"ph_en_mp3\":");
    QString tar = m_context.mid(seat + 1);
    QStringList list = tar.split(",");
    if(list.size() < 1) return "1";
    QStringList tmp = list[0].split('\"');
    if(tmp.size() < 3) return "2";
    qDebug() << "The voice real path is = " << tmp[2];
    QString url = tmp[2];

    return url;

}

QString Networkcpp::getMean()
{
    //增加事件循环，避免实现过快
    QEventLoop loop;
    QTimer::singleShot(600,&loop,SLOT(quit()));
    loop.exec();

    //解析字符串
    qDebug() << "The context is = " << m_context;
    int way2 = 0;
    int seat = m_context.indexOf("\"translate_result\"");
    QString tar = m_context.mid(seat + 1);
    QStringList list = tar.split(",");
    if(seat == -1)
    {
        seat = m_context.indexOf("\"means\"");
        tar = m_context.mid(seat + 1);
        qDebug() << "The tar is = " << tar;
        list = tar.split(",");
        if(list.size() < 1)
        {
            qDebug() << "empty";
            return "";
        }
        way2 = 1;
    }
    qDebug() << "The split of string is = " << list[0];
    QStringList tmp = list[0].split(':');
    if(tmp.size() < 2)
    {
        qDebug() << "empty1";
        return "";
    }
    if(way2)
    {
        QStringList rest = tmp[1].split('"');
        if(rest.size() < 2)
        {
            qDebug() << "empty2";
            return "";
        }
        qDebug() << "The result string is = " << rest[1];
        return rest[1];
    }
    qDebug() << "chinese mean is = " << tmp[1];
    return tmp[1];
}


void Networkcpp::reciveWebMess(QString word)
{
    qDebug() << "STAT TO VOICE";
    QString tmpWord = word.trimmed();
    tmpWord.replace(' ',"%20");
    tmpWord.replace("'","%27");
    qDebug() << "The string is = " << tmpWord;
    QString targetPath = "http://www.iciba.com/word?w=" + word;
    qDebug() << "The web path is = " << targetPath;
    setTargetWebUrl(targetPath);
}
