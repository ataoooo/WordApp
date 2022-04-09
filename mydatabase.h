#ifndef MYDATABASE_H
#define MYDATABASE_H

#include <QObject>
class myDataBase : public QObject
{
    //�����ú�֮�������qml�е���
    Q_OBJECT
public:
    explicit myDataBase(QObject* parent = nullptr);
    ~myDataBase(){}
    //�������ݿ�
    bool checkConnectDB(QString dbName);

    //---------------�û���Ϣ----------------
    //��ѯ�û�����
    Q_INVOKABLE QString findPwd(QString id);
    //�����û���Ϣ
    Q_INVOKABLE bool insertRecord(QString& phoneNum,QString& userType,QString& userID,QString& pwd);
    //---------------�û���Ϣ----------------

};

#endif // MYDATABASE_H
