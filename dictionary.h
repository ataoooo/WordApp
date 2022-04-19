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

    //保存编辑过后的单词到自己的单词本
    Q_INVOKABLE bool saveWordToBook(QString bookname,QString word,QString accent,QString mean_cn,int freq,
                                    int wordlength,int exID,QString tenses,QString voice);

    //收藏英语单词
    Q_INVOKABLE bool collectWord(QString bookname,QString word,QString accent,QString mean_cn,int freq,
                                 int wordlength,int exID,QString tenses,QString voice);
    //取消收藏英语单词
    Q_INVOKABLE bool cancelCollect(QString bookname,QString word);

    Q_INVOKABLE bool isCollect(QString bookname,QString word);
private:
    bool connectDB();

    //自己的单词本(笔记本，编辑之后就到这里面来了)
    bool createEditBook(int sno);

    //收藏英语单词
    bool createCollectTable(int sno);
};

#endif // DICTIONARY_H
