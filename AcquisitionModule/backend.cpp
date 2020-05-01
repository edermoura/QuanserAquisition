#include "backend.h"

BackEnd::BackEnd(QObject *parent) : QObject(parent)
{


}



void BackEnd::startRecord()
{
    setNewLogEvent("Starting ...");

    try
    {
        mutex.lock();
        this->m_isRunning = true;
        mutex.unlock();

        this->m_taskRecord = QtConcurrent::run(this,&BackEnd::recordManager);
    }
    catch(int e)
    {
        mutex.lock();
        this->m_isRunning = false;
        mutex.unlock();

        setNewLogEvent("*** Error when starting");
        emit systemStoppedSignal();

        return;
    }
}


void BackEnd::stopRecord()
{
    mutex.lock();
    this->m_isRunning = false;
    mutex.unlock();

    setNewLogEvent("Stopping ...");
}


void BackEnd::recordManager()
{
    int countThreads = 0;

    setNewLogEvent("+ Initializing all sensors");

    try
    {
        // Convert the state to start the sensors functions
        mutex.lock();
        this->m_stateToRecord = false;

        // Reset the state of each thread
        this->m_stateCameraReady = false;
        this->m_stateEncoderReady = false;
        this->m_stateSensorReady = false;
        mutex.unlock();

        // Evaluates which treads need to be started

        // Camera
        if (this->m_toRecordCamera == true)
        {
            this->m_taskCamera = QtConcurrent::run(this,&BackEnd::recordCamera);
            countThreads++;
        }
        // Sensors
        if (this->m_toRecordSensors == true)
        {
            this->m_taskSensor = QtConcurrent::run(this,&BackEnd::recordSensors);
            countThreads++;
        }

        // Encoders
        if (this->m_toRecordEncoders == true)
        {
            this->m_taskEncoder = QtConcurrent::run(this,&BackEnd::recordEncoders);
            countThreads++;
        }

    }
    catch(int e)
    {
        mutex.lock();
        this->m_isRunning = false;
        this->m_stateToRecord = false;
        mutex.unlock();

        setNewLogEvent("*** Error when initializing the sensors");
        emit systemStoppedSignal();

        return;
    }


    // Wait for all threads be ready to start to record
    do{
        int localCount = 0;

        QThread::usleep(100);

        if((this->m_stateCameraReady == true) &&
           (this->m_toRecordCamera == true))
        {
            localCount++;
        }

        if((this->m_stateSensorReady == true) &&
           (this->m_toRecordSensors == true))
        {
            localCount++;
        }

        if((this->m_stateEncoderReady == true) &&
           (this->m_toRecordEncoders == true))
        {
            localCount++;
        }

         if (countThreads == localCount)
            break;

    }while (true);

    // Make all threads start to record
    mutex.lock();
    this->m_stateToRecord = true;
    mutex.unlock();

    setNewLogEvent("--> Recording");



    // Wait until the command to stop
    while (this->m_isRunning)
        QThread::msleep(200);

    setNewLogEvent("+ Stopping the system");

    // Stops all threads
    mutex.lock();
    this->m_stateToRecord = false;
    mutex.unlock();



    // Wait for all threads be ready to stop
    do{
        int localCount = 0;

        QThread::usleep(100);

        if((this->m_stateCameraReady == false) &&
           (this->m_toRecordCamera == true))
        {
            localCount++;
        }

        if((this->m_stateSensorReady == false) &&
           (this->m_toRecordSensors == true))
        {
            localCount++;
        }

        if((this->m_stateEncoderReady == false) &&
           (this->m_toRecordEncoders == true))
        {
            localCount++;
        }

         if (countThreads == localCount)
            break;

        //QThread::usleep(100);
        //if((this->m_stateCameraReady == false) &&
        //   (this->m_stateSensorReady == false))
        //    break;

    }while (true);

    emit systemStoppedSignal();
    setNewLogEvent("System stopped!!!");
}


void BackEnd::recordCamera()
{
    mutex.lock();
    this->m_stateCameraReady = true;
    mutex.unlock();

    /******************************/
    // Starting the system
    VideoCapture cam;

    if(!cam.open(this->m_cameraNumber))
    {
        mutex.lock();
        this->m_stateCameraReady = false;
        mutex.unlock();
        setNewLogEvent("*** Camera not oppend!!!");

        return;
    }


    // Auxiliar variables
    QString fileName;
    Mat imgTemp;
    QVector<Mat> frames;
    int cont = 0;
    qint64 deltaT, Ts = this->m_cameraSampleTime*1000000;
    // Create a local timer to maintain the Time Sample
    QElapsedTimer localTimer, localTimer2;

    // Wait for the camera to start
    for(int i = 0; i < 10; i++)
    {
        cam >> imgTemp;
        QThread::msleep(30);
    }

    // Remove previous data
    this->m_cameraTimes.clear();

    setNewLogEvent("- Camera ready");

    mutex.lock();
    this->m_stateCameraReady = true;
    mutex.unlock();


    // Wait to syncronize the start of record
    while (this->m_stateToRecord == false)
        QThread::usleep(10);


    /********************/
    // Record Images
    localTimer.start();
    while(this->m_stateToRecord)
    {
        m_cameraTimes.append(this->m_generalTimer.nsecsElapsed());
        Mat frame;

        localTimer2.start();
        cam >> frame;
        deltaT = localTimer2.nsecsElapsed()/1000;
        this->m_deltaTCam.append(deltaT);


        frames.append(frame);
        cont++;


        deltaT = (cont*Ts - localTimer.nsecsElapsed())/1000;

        //qDebug() << deltaT;
        if (deltaT > 0 )
            QThread::usleep(deltaT);
    }

    /********************/
    // Record images on the disc
    setNewLogEvent("- Recording images on the disc");



    Ts = this->m_cameraSampleTime;
    //qint64 t0 = this->m_cameraTimes.at(0);
    // Record all data on the disc
    for(int i = 0; i < frames.count(); i++)
    {
        //qint64 val = (this->m_cameraTimes.at(i) - t0 )/ 1000000;

        fileName.sprintf("/%020d.jpg",Ts*i);
        fileName = this->m_path + fileName;
        imgTemp = frames.at(i);

        imwrite(fileName.toStdString(), imgTemp);
    }

    // Close all possible windows of OpenCV
    destroyAllWindows();

    setNewLogEvent("- Camera finished");

    mutex.lock();
    this->m_stateCameraReady = false;
    mutex.unlock();
}


void BackEnd::recordEncoders()
{

    // Return the state to the recordAll()
    mutex.lock();
    this->m_stateEncoderReady = false;
    mutex.unlock();



    mutex.lock();
    this->m_stateEncoderReady = true;
    mutex.unlock();


    // Wait to syncronize the start of record
    while (this->m_stateToRecord == false);

    while (this->m_stateToRecord)
    {
        QThread::msleep(5);
    }

    mutex.lock();
    this->m_stateEncoderReady = false;
    mutex.unlock();
}


void BackEnd::recordSensors()
{

    // Return the state to the recordAll()
    mutex.lock();
    this->m_stateSensorReady = false;
    mutex.unlock();

    QSerialPort serialComm;

    // Configure the Serial Port Parameters
    serialComm.setPortName(m_serialPortList.at(m_serialPortChoosed).portName());
    serialComm.setBaudRate((qint32) m_serialBaudList.at(m_serialBaudRate));
    serialComm.setDataBits(QSerialPort::Data8);
    serialComm.setParity(QSerialPort::NoParity);
    serialComm.setStopBits(QSerialPort::OneStop);
    serialComm.setFlowControl(QSerialPort::NoFlowControl);


    if(!serialComm.open(QIODevice::ReadWrite))
    {
        setNewLogEvent("*** Serial port was not oppend!!!");
        return;
    }

    // Create auxiliar variables
    char buffer[500] = "";
    QString line;
    QStringList sensorData;
    QString fileName;

    fileName = this->m_path + "/data_sensors.txt";

    QFile sensorFile(fileName);

    if(!sensorFile.open(QIODevice::ReadWrite | QIODevice::Text))
    {
        setNewLogEvent("*** Sensor datalog file was not oppend!!!");
        return;
    }

    QTextStream txtStream(&sensorFile);

    //qDebug() << "Sensor Time Sample: " << this->m_sensorSampleTime;
    //qDebug() << "Sensor File Name: " << fileName;
    //qDebug() << "Serial baudrate: " << serial.baudRate();
    //qDebug() << "Serial name: " << serial.portName();

    // Auxiliar variables for the timer
    int cont = 0;
    qint64 deltaT, Ts = this->m_sensorSampleTime*1000000;
    QElapsedTimer localTimer;


    // Clear and synchronize the serial buffer
    for (int i = 0; i < 100; i++)
    {
        serialComm.write("r");
        serialComm.waitForReadyRead(100);
        serialComm.readLine(buffer,500);
        QThread::msleep(20);
    }

    // Remove previous data
    m_sensorTimes.clear();

    setNewLogEvent("- Sensors ready");
    //qDebug() << "Sensor ok";

    mutex.lock();
    this->m_stateSensorReady = true;
    mutex.unlock();

    // Wait to syncronize the start of record
    while (this->m_stateToRecord == false)
        QThread::usleep(10);

    // Record all data from sensors
    localTimer.start();
    while (this->m_stateToRecord)
    {
        m_sensorTimes.append(this->m_generalTimer.nsecsElapsed());
        serialComm.write("r");
        serialComm.waitForReadyRead(1000);
        serialComm.readLine(buffer,500);

        line = QString::fromUtf8(buffer,-1);
        sensorData.append(line);

        cont++;
        deltaT = (cont*Ts - localTimer.nsecsElapsed())/1000;
        //qDebug() << deltaT;
        if (deltaT > 0 )
            QThread::usleep(deltaT);
    }

    //qDebug() << "Gravando dados dos sensores ...";
    setNewLogEvent("- Recording sensor data on the disc ...");

    Ts = this->m_sensorSampleTime;
    //qint64 t0 = this->m_sensorTimes.at(0);
    for(int i = 0; i < sensorData.count(); i++)
    {
        //qint64 val = (this->m_sensorTimes.at(i) - t0 )/ 1000 ;
        txtStream << Ts*i << "; " << sensorData.at(i);
        //qDebug() << sensorData.at(i);
    }

    sensorFile.close();

    setNewLogEvent("- Sensor finished");
    mutex.lock();
    this->m_stateSensorReady = false;
    mutex.unlock();
}


QString BackEnd::path()
{
    return this->m_path;
}


void BackEnd::setPath(QString path)
{
    this->m_path = path;
}


int BackEnd::cameraSampleTime()
{
    return this->m_cameraSampleTime;
}


void BackEnd::setCameraSampleTime(int value)
{
    if (value == this->m_cameraSampleTime)
        return;
    else if (value <= 0)
        return;

    this->m_cameraSampleTime = value;
}


void BackEnd::setCameraNumber(int value)
{
    this->m_cameraNumber = value;
}


int BackEnd::cameraNumber()
{
    return this->m_cameraNumber;
}


bool BackEnd::showCam()
{
   return this->m_showCamera;
}


void BackEnd::setShowCam(bool cond)
{
   this->m_showCamera = cond;
}


bool BackEnd::toRecordCamera()
{
    return m_toRecordCamera;
}


void BackEnd::setToRecordCamera(bool value)
{
    this->m_toRecordCamera = value;
}


bool BackEnd::toRecordSensors()
{
    return m_toRecordSensors;
}


void BackEnd::setToRecordSensors(bool value)
{
    this->m_toRecordSensors = value;
}


bool BackEnd::toRecordEncoders()
{
    return m_toRecordEncoders;
}


void BackEnd::setToRecordEncoders(bool value)
{
    this->m_toRecordEncoders = value;
}


QStringList BackEnd::serialPortAvailables()
{
    // Remove previous data
    m_serialPortList.clear();

    // Get the list of available serial Ports
    m_serialPortList = QSerialPortInfo::availablePorts();

    QStringList list;

    //qDebug() << "* Number of available ports: " << m_lista.count();

    for(int i = 0; i < m_serialPortList.count(); i++)
    {
        list.append(m_serialPortList.at(i).portName());
    }

    return list;
}


QVector<int> BackEnd::serialBaudRateList()
{
    return m_serialBaudList;
}


int BackEnd::serialPort()
{
    return m_serialPortChoosed;
}


void BackEnd::setSerialPort(int value)
{
    m_serialPortChoosed = value;

    // Get the list of available velocities for serial port
    QList<qint32> list = m_serialPortList.at(value).standardBaudRates();

    m_serialBaudList.clear();

    // Append all available velocities
    for(int i = 0; i < list.count(); i++)
    {
        m_serialBaudList.append(list.at(i));
    }
}


void BackEnd::setSerialBaudRate(int value)
{
    m_serialBaudRate = value;
}


int BackEnd::serialBaudRate()
{
    return m_serialBaudRate;
}


void BackEnd::setSensorSampleTime(int value)
{
    this->m_sensorSampleTime = value;
}


int BackEnd::sensorSampleTime()
{
    return this->m_sensorSampleTime;
}



QString BackEnd::newLogEvent()
{
    QString temp = "---";

    if (this->m_logList.count() > 0)
    {
        temp = this->m_logList.at(0);
        this->m_logList.removeFirst();
        return temp;
    }
    else
    {
        return temp;
    }

}



void BackEnd::setNewLogEvent(QString message)
{
    this->m_logList.append(message);
    emit newLogEventSignal();
}


