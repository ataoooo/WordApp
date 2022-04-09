#ifndef KEYFILTER_H
#define KEYFILTER_H

#include <QObject>

class KeyFilter : public QObject
{
    Q_OBJECT
public:
    static KeyFilter* getInstance();
    explicit KeyFilter(QObject* parent = 0);
    void setFilter(QObject* obj);
protected:
    bool eventFilter(QObject* watched,QEvent* event);
signals:
    void sig_KeyBackPress();
    void sig_AppExit();
};

#endif // KEYFILTER_H
