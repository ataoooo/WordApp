#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include "keyfilter.h"
#include "mydatabase.h"
#include "dictionary.h"
#include<fstream>
#include <QMutex>
#include <QDir>
#include <QDateTime>
#include <QDebug>
#include <QIcon>
#include "config.h"
#include "datemanager.h"
#include "networkcpp.h"
#include <QtAndroid>

//检查安装程序是否授权读写权限
bool checkPermission() {
    QtAndroid::PermissionResult r = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
    if(r == QtAndroid::PermissionResult::Denied) {
        QtAndroid::requestPermissionsSync( QStringList() << "android.permission.WRITE_EXTERNAL_STORAGE" );
        r = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
        if(r == QtAndroid::PermissionResult::Denied) {
             return false;
        }
   }
   return true;
}
//日志
std::ofstream g_OutputDebug;
void outputMessage(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    // 加锁
    static QMutex mutex;
    mutex.lock();
    QString text;
    switch(type) {
    case QtDebugMsg:
        text = QString("Debug: ");
        break;
    case QtWarningMsg:
        text = QString("Warning: ");
        break;
    case QtCriticalMsg:
        text = QString("Critical:");
        break;
    case QtFatalMsg:
        text = QString("Fatal: ");
        break;
    default:
        text = QString("Debug: ");
    }
    QString context_info = QString("F:(%1) L:(%2)").arg(QString(context.file)).arg(context.line); //
    QString current_date_time = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
    QString current_date = QString("(%1)").arg(current_date_time);
    std::string message = qPrintable(QString("%1 %2 \t%3 \t%4").arg(text).arg(context_info).arg(current_date).arg(msg));
    g_OutputDebug << message << "\r\n"; // std::ofstream
    // 解锁
    mutex.unlock();
}

int main(int argc, char *argv[])
{
    checkPermission();
    //日志输出
    QString logPath = "/storage/emulated/0/data/TRlog";
    QDir dir;
    if(!dir.exists(logPath))
        dir.mkdir(logPath);
    qInstallMessageHandler(outputMessage);
    g_OutputDebug.open(qPrintable(logPath + "/" + QString(QString(QDateTime::currentDateTime().toString("yyyy-MM-dd-hh-mm-ss").append("-log.txt")))), std::ios::out | std::ios::trunc);

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qDebug() << "App begin";

    QApplication app(argc, argv);

    //更换图标
    app.setWindowIcon(QIcon(":/assets/mdpi/rabbitword.ico"));

//    //注册数据库交互类(一定要注意大写啊啊啊啊！！！)
//    qmlRegisterType<myDataBase>("myDB", 1, 0, "MyDataBase");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("keyFilter", KeyFilter::getInstance());

    //导出属性
    engine.rootContext()->setContextProperty("myDB", new myDataBase);
    engine.rootContext()->setContextProperty("wordDB",new Dictionary);
    engine.rootContext()->setContextProperty("config",new Config);
    engine.rootContext()->setContextProperty("dateManager",new DateManager);
    engine.rootContext()->setContextProperty("network",new Networkcpp);

    QQmlComponent component(&engine,QUrl("qrc:/main.qml"));
    QObject* object = component.create();
    KeyFilter::getInstance()->setFilter(object);
    return app.exec();
}
