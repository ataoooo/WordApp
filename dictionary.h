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

    //导入单词
    Q_INVOKABLE bool importWord(QString sno,QString word,QString mean);

    //选取需要背诵的单词
    Q_INVOKABLE QVariantList rememberWord(QString tablename,int num);

    //获取所有单词中英文
    Q_INVOKABLE QVariantList getAllWords(QString tablename);
private:
    bool connectDB();

    //收藏英语单词
    bool createCollectTable(int sno);

    //导入的单词
    bool createImportTable(int sno);
};

#endif // DICTIONARY_H
