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

    //建立自己的表
    Q_INVOKABLE void createAllWordTable(QString sno);

    //保存编辑过后的单词到自己的单词本
    Q_INVOKABLE bool saveWordToBook(QString bookname,QString word,QString accent,QString mean_cn,
                                    QString tenses,QString origin);

    //收藏英语单词
    Q_INVOKABLE bool collectWord(QString bookname,QString word);
    //取消收藏英语单词
    Q_INVOKABLE bool cancelCollect(QString bookname,QString word);

    //是否收藏
    Q_INVOKABLE bool isCollect(QString bookname,QString word);

    //选取所有被收藏的单词
    Q_INVOKABLE QVariantList collectWords(QString bookname);

    //导入单词
    Q_INVOKABLE bool importWord(QString sno,QString word,QString mean);

    //选取需要背诵的单词(单词本名，共个数，各等级个数)
    Q_INVOKABLE QVariantList rememberWord(QString sno,int num,float lev1,float lev2,
                                          float lev3,float lev4);
    //上一次背错的单词
    Q_INVOKABLE QVariantList lastErrorWord(QString sno);

    //获取所有单词中英文
    Q_INVOKABLE QVariantList getAllWords(QString tablename);

    //获取所有句子
    Q_INVOKABLE QVariantList getAllSentence();

    Q_INVOKABLE void insertToRemember(int sno);

    Q_INVOKABLE void setDiffer(int sno,int wordNum,int diff);

    Q_INVOKABLE QVariantList getDiffer(int sno);

    //设置准确度
    Q_INVOKABLE void setAccuracy(QString sno,QString word,int isTrue);

    //设置此次正确度
    Q_INVOKABLE void setLastMistake(QString sno,QString word,int notTrue);

    Q_INVOKABLE QVariantList calculateWord(QString sno);


private:
    bool connectDB();

    //收藏英语单词
    bool createCollectTable(int sno);

    //导入的单词
    bool createImportTable(int sno);
};

#endif // DICTIONARY_H
