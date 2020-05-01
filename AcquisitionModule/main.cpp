#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include "backend.h"
#include "arucodetect.h"
#include "imageviewer.h"
#include "camcalibration.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Registering
    qmlRegisterType<BackEnd>("BackEnd",1,0,"BackEnd");
    qmlRegisterType<ArucoDetect>("ArucoDetect",1,0,"ArucoDetect");
    qmlRegisterType<ImageViewer>("ImageViewer",1,0,"ImageViewer");
    qmlRegisterType<CamCalibration>("CamCalibration",1,0,"CamCalibration");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

