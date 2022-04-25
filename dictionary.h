#ifndef DICTIONARY_H
#define DICTIONARY_H

#include<QObject>
#include<QVariantList>
class Dictionary : public QObject
{
    Q_OBJECT
public:
    explicit Dictionary(QObject* parent = nullptr);

    Q_INVOKABLE QVariantList searchWord(QString wordName,QString prefiex);

    Q_INVOKABLE QVariantList searchTargetWord(QString wordName, QString word);

    Q_INVOKABLE QVariant getSentence(QString str);

    //�����Լ��ı�
    Q_INVOKABLE void createAllWordTable(QString sno);

    //����༭����ĵ��ʵ��Լ��ĵ��ʱ�
    Q_INVOKABLE bool saveWordToBook(QString bookname,QString word,QString accent,QString mean_cn,
                                    QString tenses,QString origin);

    //�ղ�Ӣ�ﵥ��
    Q_INVOKABLE bool collectWord(QString bookname,QString word);
    //ȡ���ղ�Ӣ�ﵥ��
    Q_INVOKABLE bool cancelCollect(QString bookname,QString word);

    //�Ƿ��ղ�
    Q_INVOKABLE bool isCollect(QString bookname,QString word);

    //���뵥��
    Q_INVOKABLE bool importWord(QString sno,QString word,QString mean);

    //ѡȡ��Ҫ���еĵ���
    Q_INVOKABLE QVariantList rememberWord(QString tablename,int num);

    //��ȡ���е�����Ӣ��
    Q_INVOKABLE QVariantList getAllWords(QString tablename);
private:
    bool connectDB();

    //�ղ�Ӣ�ﵥ��
    bool createCollectTable(int sno);

    //����ĵ���
    bool createImportTable(int sno);
};

#endif // DICTIONARY_H
