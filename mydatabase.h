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
    //查询用户类别
    Q_INVOKABLE QString findType(QString id);
    //获取电话
    Q_INVOKABLE QString getPhone(QString id);
    //获取唯一序列号
    Q_INVOKABLE int getUserSno(QString id);
    //插入用户信息
    Q_INVOKABLE bool insertRecord(QString phoneNum,QString userType,QString userID,QString pwd);
    //查看号码是否被注册
    Q_INVOKABLE bool findPhone(QString phone);
    //删除记录
    Q_INVOKABLE bool delRecord(QString context);

    //更改密码
    Q_INVOKABLE bool upGradePwd(QString id,QString pwd);
    //更改电话
    Q_INVOKABLE bool upGradePhone(QString id,QString phone);
    //更改用户类别
    Q_INVOKABLE bool upGradeType(QString id,QString uType);
    //更改用户名
    Q_INVOKABLE bool upGradeName(QString oldId,QString newId);

    //根据电话号码返回用户id
    Q_INVOKABLE QString getUserID(QString phone);

    //根据电话获取密码
    Q_INVOKABLE QString getMM(QString phone);
    //---------------用户信息----------------

    Q_INVOKABLE void test();
};

#endif // MYDATABASE_H
