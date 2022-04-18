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
private:
    bool connectDB();


};

#endif // DICTIONARY_H
