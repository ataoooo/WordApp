#ifndef DICTIONARY_H
#define DICTIONARY_H

#include<QObject>
#include<QVariantList>
class Dictionary : public QObject
{
    Q_OBJECT
public:
    explicit Dictionary(QObject* parent = nullptr);

    Q_INVOKABLE QVariantList searchWord(QString prefiex);

    Q_INVOKABLE QVariantList searchTargetWord(QString word);

    Q_INVOKABLE QVariant getSentence(QString str);

    //����༭����ĵ��ʵ��Լ��ĵ��ʱ�
    Q_INVOKABLE bool saveWordToBook(QString bookname,QString word,QString accent,QString mean_cn,int freq,
                                    int wordlength,int exID,QString tenses,QString voice);

    //�ղ�Ӣ�ﵥ��
    Q_INVOKABLE bool collectWord(QString bookname,QString word,QString accent,QString mean_cn,int freq,
                                 int wordlength,int exID,QString tenses,QString voice);
    //ȡ���ղ�Ӣ�ﵥ��
    Q_INVOKABLE bool cancelCollect(QString bookname,QString word);

    Q_INVOKABLE bool isCollect(QString bookname,QString word);
private:
    bool connectDB();

    //�Լ��ĵ��ʱ�(�ʼǱ����༭֮��͵�����������)
    bool createEditBook(int sno);

    //�ղ�Ӣ�ﵥ��
    bool createCollectTable(int sno);
};

#endif // DICTIONARY_H
