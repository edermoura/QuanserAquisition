#ifndef ArucoDetect_H
#define ArucoDetect_H
#include <QDebug>
#include <QObject>

#include <QString>
#include <QStringList>
#include <QDir>
#include <vector>

#include <QFuture>
#include <QtConcurrent/QtConcurrent>
#include <QMutex>

#include "tagdata.h"
#include "opencv2/opencv.hpp"
#include "aruco/aruco.h"
//#include "opencv2/aruco.hpp"



using namespace  cv;
using namespace  std;


class ArucoDetect: public QObject
{
    Q_OBJECT

private:

    int     m_numTags;   // Determine, from 0, how many tags to look for
    int     m_count;     // Number of detected tags on last image
    double  m_tagSize;   // Tag side length in meters of square black frame
    QStringList m_dictionary;

    QString m_cameraFile;
    Mat     m_cameraMatrix;
    Mat     m_distanceCoeff;

    // Dados de posicionamento e orientação de cada tag
    vector<tagData> m_infoTags;

    // Directory information
    QString m_path;
    QString m_fileExtension;
    QStringList m_logEvents;

    // Thread task
    QFuture <void> m_taskDecode;

    void setNewLogEvent(QString message);

    void imagesDecode();

public:

    ArucoDetect();

    /*********************************************/

    Q_INVOKABLE void startConversion(QString path, QString fileExtension,
                                     int numTags, int dictionary,
                                     QString calibrateFile);

signals:

    void newLogEventSignal();


public slots:

};

#endif // ArucoDetect_H
