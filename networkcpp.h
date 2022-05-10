#ifndef NETWORKCPP_H
#define NETWORKCPP_H
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QtWidgets/QWidget>
#include <QTextCodec>
#include <QString>
#include <QUrl>
#include <QObject>
#include <QDebug>
class Networkcpp : public QObject
{
    Q_OBJECT
public:
    explicit Networkcpp(QObject* parent = nullptr);
    Q_INVOKABLE void reciveWebMess(QString word);
    Q_INVOKABLE QString speakWord();
    Q_INVOKABLE QString getMean();
private Q_SLOTS:
    void slot_replayFinished(QNetworkReply *reply);
private:
    void setTargetWebUrl(QString webUrl);
    QNetworkAccessManager* m_manager = nullptr;
    QString m_context;  //获取的网页源代码信息
};

#endif // NETWORKCPP_H
