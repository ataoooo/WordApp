#include "keyfilter.h"
#include <QMutex>
#include <QKeyEvent>
KeyFilter::KeyFilter(QObject* parent) : QObject(parent){}

KeyFilter* KeyFilter::getInstance()
{
    static QMutex mutex;
    static QScopedPointer<KeyFilter> instance;
    if(Q_UNLIKELY(!instance))
    {
        mutex.lock();
        if(!instance)
        {
            instance.reset(new KeyFilter);
        }
        mutex.unlock();
    }
    return instance.data();
}


bool KeyFilter::eventFilter(QObject *watched, QEvent *event)
{
    //获取事件类型
    if(event->type() == QEvent::KeyPress)
    {
        //转换成键盘事件
        QKeyEvent *keyEvent = static_cast<QKeyEvent*>(event);
        //判断是否是back事件
        if(keyEvent->key() == Qt::Key_Back)
        {
            //发送back键按下的信号
            emit sig_KeyBackPress();
            return true;
        }
    }
    return false;//
}

void KeyFilter::setFilter(QObject *obj)
{
    //将过滤器注册到对应的类
    obj->installEventFilter(this);
}
