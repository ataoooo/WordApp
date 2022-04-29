#ifndef CONFIG_H
#define CONFIG_H
#include <QObject>
#include<QSettings>
#include<QDebug>
class Config : public QObject
{
    Q_OBJECT
public:
    explicit Config(QObject* parent = nullptr);
    ~Config();
    Q_INVOKABLE void setConfigString(QString path,QString value);
    Q_INVOKABLE void setConfigBool(QString path,bool value);
    Q_INVOKABLE bool getConfigBool(QString path,bool res);
    Q_INVOKABLE QString getConfigString(QString path);
private:
    static QSettings* setting;

};

#endif // CONFIG_H
