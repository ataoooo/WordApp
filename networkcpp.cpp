#include "networkcpp.h"
#include <QMediaPlayer>

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
    qDebug() << m_context;
    reply->deleteLater();//最后要释放replay对象
}

void Networkcpp::speakWord()
{
    //解析字符串
    int seat = m_context.indexOf("\"ph_en_mp3\":");
    QString tar = m_context.mid(seat + 1);
    QStringList list = tar.split(",");
    if(list.size() < 1) return;
    QStringList tmp = list[0].split('\"');
    if(tmp.size() < 3) return;
    qDebug() << "The voice real path is = " << tmp[2];
    QString url = tmp[2];

    //发音
    QMediaPlayer* player = new QMediaPlayer;
    player->setMedia(QUrl::fromLocalFile(url));
    player->setVolume(50);
    player->play();

}


void Networkcpp::reciveWebMess(QString word)
{
    qDebug() << "STAT TO VOICE";
    QString targetPath = "http://www.iciba.com/word?w=" + word;
    setTargetWebUrl(targetPath);
}
