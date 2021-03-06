#QT += quick sql charts
QT += quick sql charts multimedia network androidextras
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        config.cpp \
        datemanager.cpp \
        dictionary.cpp \
        keyfilter.cpp \
        main.cpp \
        mydatabase.cpp \
        networkcpp.cpp

RESOURCES += \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    config.h \
    datemanager.h \
    dictionary.h \
    keyfilter.h \
    mydatabase.h \
    networkcpp.h

android{
    data.files += android/userTable.db
    data.files += android/lookup.db
    data.files += android/config.ini
    data.path = /assets/dbfile
    INSTALLS += data
}

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

DISTFILES += \
    androidsource/AndroidManifest.xml \
    androidsource/ico/rabbit.png \
    androidsource/ico/rabitbig.png \
    androidsource/ico/rabitmid.png
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/androidsource
