#include "ArucoDetect.h"


ArucoDetect::ArucoDetect()
{
    m_tagSize  = -1;
    m_numTags  = -1;
    m_dictionary << "";
}



void ArucoDetect::setNewLogEvent(QString message)
{
    this->m_logEvents.append(message);

    emit newLogEventSignal();
}


void ArucoDetect::startConversion(QString path, QString fileExtension,
                                  int numTags, int dictionary,
                                  QString calibrateFile)
{
    qDebug() <<"Entrou";

    m_path = path;
    m_fileExtension = fileExtension;
    m_numTags = numTags;
    m_cameraFile = calibrateFile;

    // Start the thread to compute the
    m_taskDecode = QtConcurrent::run(this,&ArucoDetect::imagesDecode);
}

void ArucoDetect::imagesDecode()
{

}


