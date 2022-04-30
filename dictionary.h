#ifndef DICTIONARY_H
#define DICTIONARY_H

#include<QObject>
#include<QVariantList>
#include <QDateTime>
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

    //ѡȡ���б��ղصĵ���
    Q_INVOKABLE QVariantList collectWords(QString bookname);

    //���뵥��
    Q_INVOKABLE bool importWord(QString sno,QString word,QString mean);

    //ѡȡ��Ҫ���еĵ���(���ʱ����������������ȼ�����)
    Q_INVOKABLE QVariantList rememberWord(QString sno,int num,float lev1,float lev2,
                                          float lev3,float lev4);
    //��һ�α���ĵ���
    Q_INVOKABLE QVariantList lastErrorWord(QString sno);

    //��ȡ���е�����Ӣ��
    Q_INVOKABLE QVariantList getAllWords(QString tablename);

    //��ȡ���о���
    Q_INVOKABLE QVariantList getAllSentence();

    Q_INVOKABLE void insertToRemember(int sno);

    Q_INVOKABLE void setDiffer(int sno,int wordNum,int diff);

    Q_INVOKABLE QVariantList getDiffer(int sno);

    //����׼ȷ��
    Q_INVOKABLE void setAccuracy(QString sno,QString word,int isTrue);

    //���ô˴���ȷ��
    Q_INVOKABLE void setLastMistake(QString sno,QString word,int notTrue);

    Q_INVOKABLE QVariantList calculateWord(QString sno);


private:
    bool connectDB();

    //�ղ�Ӣ�ﵥ��
    bool createCollectTable(int sno);

    //����ĵ���
    bool createImportTable(int sno);
};

#endif // DICTIONARY_H
