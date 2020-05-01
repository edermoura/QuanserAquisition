TEMPLATE = app

QT += qml quick concurrent serialport
CONFIG += c++11

SOURCES += main.cpp \
           backend.cpp \
           arucodetect.cpp \
           tagdata.cpp \
    imageviewer.cpp \
    camcalibration.cpp

RESOURCES += qml.qrc


# OPENCV Directives
include(D:/Programas/QT/opencv.pri)

# ARUCO
INCLUDEPATH += D:/libs/aruco_304/include
LIBS += -LD:/libs/aruco_304/lib -laruco304.lib

# Note
#INCLUDEPATH += D:\libs\opencv_3.3.1\include
#LIBS += D:\libs\opencv_3.3.1\x64\vc14\lib\*.lib
#LIBS += -LD:\libs\opencv_3.3.1\x64\vc14\lib
# INCLUDEPATH += D:/libs/opencv/opencv-3.2.0-contrib/include
# LIBS += D:/libs/opencv/opencv-3.2.0-contrib/x64/vc14/lib/*.lib
# LIBS += -LD:/libs/opencv/opencv-3.2.0-contrib/x64/vc14/lib
# Quanser PC
#INCLUDEPATH += D:/libs/opencv-3.2.0-contrib/include
#LIBS += D:/libs/opencv-3.2.0-contrib/x64/vc14/lib/*.lib
#LIBS += -LD:/libs/opencv-3.2.0-contrib/x64/vc14/lib
# LIBS += -lopencv_world331


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    backend.h \
    arucodetect.h \
    tagdata.h \
    imageviewer.h \
    camcalibration.h
