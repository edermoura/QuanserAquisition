#ifndef CAMCALIBRATION_H
#define CAMCALIBRATION_H

#include <QObject>

#include <QFuture>
#include <QtConcurrent/QtConcurrent>
#include <QMutex>

#include <QImage>
#include <QPixmap>
#include <QSize>

#include <QVector>
#include <iostream>
#include <sstream>
#include "opencv2/opencv.hpp"

using namespace cv;


class CamCalibration : public QObject
{
    Q_OBJECT

private:

    QFuture<void> future;

    // List of images to camera calibration calculation OpenCV Mat format
    QVector<Mat> imagesToCalibrate;

    // List of images from imagesToCalibrate converted to QImage to show in the QML UI
    QVector<QImage> imagesToShow;

    // Mat Camera Calibration Parameters
    Mat cameraMatrix, distCoeffs;

    // Informations to squareboard calibration algorithm
    int m_numSquaresX, m_numSquaresY;
    double m_squareSideSize;

    // Define the image resolution of the camera
    int m_imageWidth, m_imageHeight;

    // Define the camera number
    int m_camNumber;

    // Represents the if the thread of opencv opencam to acquire images is running
    bool threadRunning;

    // Used to safety condense the images
    QMutex mut;

    // Process to start the camera image aquisition
    void camCapture();

    Q_PROPERTY(int imageWidth READ imageWidth WRITE setImageWidth)
    Q_PROPERTY(int imageHeight READ imageHeight WRITE setImageHeight)
    Q_PROPERTY(int camNumber READ camNumber WRITE setCamNumber)

    Q_PROPERTY(int numSquaresX READ numSquaresX WRITE setNumSquaresX)
    Q_PROPERTY(int numSquaresY READ numSquaresY WRITE setNumSquaresY)
    Q_PROPERTY(float squareSideSize READ squareSideSize WRITE setSquareSideSize)

public:
    explicit CamCalibration(QObject *parent = nullptr);


    int imageWidth();
    void setImageWidth(int imWidth);

    int imageHeight();
    void setImageHeight(int imHeight);

    int camNumber();
    void setCamNumber(int cameraID);

    int numSquaresX();
    void setNumSquaresX(int numX);

    int numSquaresY();
    void setNumSquaresY(int numY);

    double squareSideSize();
    void setSquareSideSize(double squareSize);

    Q_INVOKABLE bool startCam();

    Q_INVOKABLE bool stopCam();

    Q_INVOKABLE bool isCamRunning();

    Q_INVOKABLE int countNumImages();

    Q_INVOKABLE void removeImageAt(int pos);

    Q_INVOKABLE QImage getImage(int pos);

    Q_INVOKABLE bool camCalibrate();

    Q_INVOKABLE QString returnCamParameters();

    Q_INVOKABLE bool saveCamParameters(QString file);



signals:

    void newImage(const QImage &frame);

    void removedImage();

    void stopped();

public slots:
};

#endif // CAMCALIBRATION_H
