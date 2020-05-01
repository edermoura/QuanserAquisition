#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#include <QVector>

#include <QThread>
#include <QFuture>
#include <QtConcurrent/QtConcurrent>
#include <QMutex>

#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>

#include <opencv2/opencv.hpp>
#include <QDebug>


using namespace cv;


class BackEnd : public QObject
{
    Q_OBJECT

private:

    // Conditions do record threads run
    bool m_isRunning = false;
    //bool m_isThreadRunning = false;

    // Specfy if each sensor need to be recorded
    bool m_toRecordCamera = false;
    bool m_toRecordSensors = false;
    bool m_toRecordEncoders = false;

    bool  m_stateCameraReady,
          m_stateSensorReady,
          m_stateEncoderReady,
          m_stateToRecord;

    /******************/
    // Thread parameters

    // Threads pointers
    QFuture <void>  m_taskCamera,
                    m_taskSensor,
                    m_taskEncoder,
                    m_taskRecord;

    // Control the access of variables
    QMutex mutex;


    // A General Timer that controls the time when data is recorded
    QElapsedTimer m_generalTimer;


    // Define the moment when data was recorded
    QVector<qint64> m_cameraTimes,
                    m_sensorTimes,
                    m_encoderTimes,
                    m_deltaTCam;


    /*******************/
    // Camera Parameters
    int m_cameraSampleTime = 100;
    int m_cameraNumber = 0;
    bool m_showCamera = false;


    /*******************/
    // Sensor Parameters
    QList<QSerialPortInfo> m_serialPortList;
    QVector<int> m_serialBaudList;
    int m_serialPortChoosed;
    int m_serialBaudRate;
    int m_sensorSampleTime;


    /******************/
    // General Functions and Variables

    // Path to the record system
    QString m_path = "";


    /******************/
    // Management of record system

    // Functions to specfic record data
    void recordCamera();
    void recordSensors();
    void recordEncoders();

    // Manage all the system record
    void recordManager();

    /********************/
    QStringList m_logList;

public:

    explicit BackEnd(QObject *parent = 0);

    Q_INVOKABLE void startRecord();
    Q_INVOKABLE void stopRecord();

    // Path to data record
    Q_PROPERTY(QString path READ path WRITE setPath)
    QString path();
    void setPath(QString path);



    /****************************************/
    // Properties of the camera
    Q_PROPERTY(int cameraSampleTime READ cameraSampleTime WRITE setCameraSampleTime)
    Q_PROPERTY(int cameraNumber READ cameraNumber WRITE setCameraNumber)
    Q_PROPERTY(bool showCam READ showCam WRITE setShowCam)
    //Q_PROPERTY(bool toCameraRecord READ toCameraRecord WRITE setToCameraRecord)
    Q_PROPERTY(bool toRecordCamera READ toRecordCamera WRITE setToRecordCamera)
    Q_PROPERTY(bool toRecordSensors READ toRecordSensors WRITE setToRecordSensors)
    Q_PROPERTY(bool toRecordEncoders READ toRecordEncoders WRITE setToRecordEncoders)

    // Return the Q_PROPERTY values
    int cameraSampleTime();
    int cameraNumber();
    bool showCam();
    bool toRecordCamera();
    bool toRecordSensors();
    bool toRecordEncoders();

    // Set the Q_PROPERTIY values
    void setCameraSampleTime(int value);
    void setCameraNumber(int value);
    void setShowCam(bool cond);
    void setToRecordCamera(bool value);
    void setToRecordSensors(bool value);
    void setToRecordEncoders(bool value);


    /****************************************/
    // Properties of the sensors and Serial Port
    //Q_INVOKABLE void connectSerial();
    Q_PROPERTY(QStringList serialPortAvailables READ serialPortAvailables)
    Q_PROPERTY(QVector<int> serialBaudRateList READ serialBaudRateList)
    Q_PROPERTY(int serialPort READ serialPort WRITE setSerialPort)
    Q_PROPERTY(int serialBaudRate READ serialBaudRate WRITE setSerialBaudRate )
    Q_PROPERTY(int sensorSampleTime READ sensorSampleTime WRITE setSensorSampleTime)


    // Read Properties
    QStringList serialPortAvailables();
    QVector<int> serialBaudRateList();
    int serialPort();
    int serialBaudRate();
    int sensorSampleTime();

    // Set Properties
    void setSerialPort(int value);
    void setSerialBaudRate(int value);
    void setSensorSampleTime(int value);



    /*********************************************/
    // Send a message to the program with new status of the program
    Q_PROPERTY(QString newLogEvent READ newLogEvent WRITE setNewLogEvent NOTIFY newLogEventSignal)

    QString newLogEvent();

    void setNewLogEvent(QString message);

signals:

    void newLogEventSignal();
    void systemStoppedSignal();

public slots:


};

#endif // BACKEND_H
