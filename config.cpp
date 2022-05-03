#include "config.h"
#include <QFile>
QSettings* Config::setting = nullptr;
Config::Config(QObject* parent) : QObject (parent)
{
    //----------------复制文件至手机文件夹------------------
    QFile file("/storage/emulated/0/data/config.ini");
    if(!file.exists() || file.size() == 0)
    {
        QFile::copy("assets:/dbfile/config.ini","/storage/emulated/0/data/config.ini");
        file.setPermissions(QFile::ReadUser  | QFile::WriteUser);
    }
    //----------------复制文件至手机文件夹------------------
    QString filename = "/storage/emulated/0/data/config.ini";
//    QString filename = "./config.ini";
    setting = new QSettings("filename",QSettings::IniFormat);
}

void Config::setConfigString(QString path,QString value)
{
    setting->setValue(path,value);
}

void Config::setConfigBool(QString path,bool value)
{
    setting->setValue(path,value);
}

void Config::setConfigInt(QString path,int value)
{
    setting->setValue(path,value);
}

bool Config::getConfigBool(QString path,bool res)
{
    return setting->value(path,res).toBool();
}

QString Config::getConfigString(QString path)
{
    return setting->value(path,"").toString();
}

int Config::getConfigInt(QString path)
{
    return setting->value(path,-1).toInt();
}

Config::~Config()
{
    if(setting!=nullptr)
    {
        delete setting;
        setting = nullptr;
    }
}

