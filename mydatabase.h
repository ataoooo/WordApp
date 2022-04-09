#ifndef MYDATABASE_H
#define MYDATABASE_H

#include <QObject>
class myDataBase : public QObject
{
    //声明该宏之后才能在qml中调用
    Q_OBJECT
public:
    explicit myDataBase(QObject* parent = nullptr);
    ~myDataBase(){}
    //连接数据库
    bool checkConnectDB(QString dbName);

    //---------------用户信息----------------
    //查询用户密码
    Q_INVOKABLE QString findPwd(QString id);
    //插入用户信息
    Q_INVOKABLE bool insertRecord(QString& phoneNum,QString& userType,QString& userID,QString& pwd);
    //---------------用户信息----------------

};

#endif // MYDATABASE_H
