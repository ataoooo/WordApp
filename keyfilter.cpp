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
    //��ȡ�¼�����
    if(event->type() == QEvent::KeyPress)
    {
        //ת���ɼ����¼�
        QKeyEvent *keyEvent = static_cast<QKeyEvent*>(event);
        //�ж��Ƿ���back�¼�
        if(keyEvent->key() == Qt::Key_Back)
        {
            //����back�����µ��ź�
            emit sig_KeyBackPress();
            return true;
        }
    }
    return false;//
}

void KeyFilter::setFilter(QObject *obj)
{
    //��������ע�ᵽ��Ӧ����
    obj->installEventFilter(this);
}
