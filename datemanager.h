#ifndef DATEMANAGER_H
#define DATEMANAGER_H

#include <QObject>
#include<QDateTime>

class DateManager : public QObject
{
    Q_OBJECT
public:
    explicit DateManager(QObject* parent = nullptr);
    Q_INVOKABLE QDateTime getTime(int i);
    Q_INVOKABLE void insetRecord(int uson,QString date,int sum,int yesw);
    Q_INVOKABLE QString getCurrenTime(int i = 0);
    Q_INVOKABLE int getNum(int sno,int time,bool isSum);
private:
    QDateTime stringToDate(QString);
    QString DateToString(QDateTime);
    bool connectDB();
};

#endif // DATEMANAGER_H
