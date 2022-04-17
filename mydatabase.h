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
    //��ѯ�û����
    Q_INVOKABLE QString findType(QString id);
    //��ȡ�绰
    Q_INVOKABLE QString getPhone(QString id);
    //�����û���Ϣ
    Q_INVOKABLE bool insertRecord(QString phoneNum,QString userType,QString userID,QString pwd);
    //�鿴�����Ƿ�ע��
    Q_INVOKABLE bool findPhone(QString phone);
    //ɾ����¼
    Q_INVOKABLE bool delRecord(QString context);

    //��������
    Q_INVOKABLE bool upGradePwd(QString id,QString pwd);
    //���ĵ绰
    Q_INVOKABLE bool upGradePhone(QString id,QString phone);
    //�����û����
    Q_INVOKABLE bool upGradeType(QString id,QString uType);
    //�����û���
    Q_INVOKABLE bool upGradeName(QString oldId,QString newId);
    //---------------�û���Ϣ----------------
};

#endif // MYDATABASE_H
