#include "camcalibration.h"

CamCalibration::CamCalibration(QObject *parent) : QObject(parent)
{
    m_camNumber = 0;
    m_imageWidth = 800;
    m_imageHeight = 600;
    m_numSquaresX = 5;
    m_numSquaresY = 5;
    m_squareSideSize = (double)0.025;
    threadRunning = false;
    cameraMatrix = Mat(3, 3, CV_64F);
    distCoeffs = Mat(8,1,CV_64F);
}

bool CamCalibration::startCam()
{
    if (this->threadRunning == true)
        return false;

    this->threadRunning = true;

    this->future = QtConcurrent::run(this,&CamCalibration::camCapture);
    return true;
}

bool CamCalibration::stopCam()
{
    this->mut.lock();

    if (this->threadRunning == false)
    {
        this->mut.unlock();
        return this->threadRunning;
    }
    else
        this->threadRunning = false;

    this->mut.unlock();

    return this->threadRunning;
}


bool CamCalibration::isCamRunning()
{
    return this->threadRunning;
}



void CamCalibration::removeImageAt(int pos)
{
    if(pos >=0 && pos < imagesToShow.count())
    {
        imagesToCalibrate.removeAt(pos);
        imagesToShow.removeAt(pos);

        emit removedImage();
    }
}



int CamCalibration::countNumImages()
{
    return this->imagesToShow.count();
}




QImage CamCalibration::getImage(int pos)
{
    if (pos >=0 && pos < imagesToShow.count())
        return this->imagesToShow.at(pos);
    else
        return QImage(QSize(150,100),
                          QImage::Format_RGB888);
}



void CamCalibration::camCapture()
{
    VideoCapture cam;

    if(!cam.open(m_camNumber))
    {
        mut.lock();
        this->threadRunning = false;
        mut.unlock();

        emit stopped();
        return;
    }

    cam.set(CV_CAP_PROP_AUTOFOCUS, false);
    cam.set(CV_CAP_PROP_FRAME_WIDTH,m_imageWidth);
    cam.set(CV_CAP_PROP_FRAME_HEIGHT,m_imageHeight);

    cvNamedWindow("Camera",CV_WINDOW_AUTOSIZE);

    Mat imgCam;
    bool found;
    Size boardSize = Size(m_numSquaresX,m_numSquaresY);
    std::vector<Point2f> corners;

    while(true)
    {
        Mat imgCopy;

        cam >> imgCam;
        imgCam.copyTo(imgCopy);

        found = findChessboardCorners( imgCam, boardSize, corners,
                                       CALIB_CB_ADAPTIVE_THRESH | CALIB_CB_FAST_CHECK |
                                       CALIB_CB_NORMALIZE_IMAGE);

        if (found)
            drawChessboardCorners(imgCam, boardSize, corners, found);


        imshow("Camera", imgCam);



        char op = waitKey(50);

        if (op == ' ' && found)
        {
            this->imagesToCalibrate.append(imgCopy);

            QImage imgShow = QImage((uchar*) imgCopy.data,
                                    imgCopy.cols, imgCopy.rows,
                                    imgCopy.step1(),
                                    QImage::Format_RGB888).rgbSwapped();

            this->imagesToShow.append(imgShow);

            emit newImage(imgShow);
        }

        this->mut.lock();

        if (op == 27)
        {
            this->threadRunning = false;
            this->mut.unlock();

            emit stopped();

            break;
        }

        if (this->threadRunning == false)
            break;

        this->mut.unlock();
    }

    destroyAllWindows();
    cam.release();
}


int CamCalibration::imageWidth()
{
    return m_imageWidth;
}


void CamCalibration::setImageWidth(int width)
{
    m_imageWidth = width;
}


int CamCalibration::imageHeight()
{
    return m_imageHeight;
}


void CamCalibration::setImageHeight(int height)
{
    m_imageHeight = height;
}


int CamCalibration::camNumber()
{
    return m_camNumber;
}


void CamCalibration::setCamNumber(int cameraID)
{
    m_camNumber = cameraID;
}


int CamCalibration::numSquaresX()
{
    return m_numSquaresX;
}


void CamCalibration::setNumSquaresX(int numX)
{
    m_numSquaresX = numX;
}


int CamCalibration::numSquaresY()
{
    return m_numSquaresY;
}


void CamCalibration::setNumSquaresY(int numY)
{
    m_numSquaresY = numY;
}


double CamCalibration::squareSideSize()
{
    return m_squareSideSize;
}


void CamCalibration::setSquareSideSize(double squareSize)
{
    m_squareSideSize = squareSize;
}


bool CamCalibration::camCalibrate()
{
    int num = imagesToCalibrate.count();

    if (num < 0)
        return false;

    std::vector<Mat> rvecs; // Rotational Vectors
    std::vector<Mat> tvecs; // Translation Vectors

    std::vector<std::vector<Point3f>> object_points;
    std::vector<std::vector<Point2f>> image_points;

    bool found;
    Size boardSize = Size(m_numSquaresX,m_numSquaresY);
    // Create the standard chessboard calibration
    std::vector< Point3f > chessPattern;

    for (int i = 0; i < m_numSquaresX; i++)
        for (int j = 0; j < m_numSquaresY; j++)
            chessPattern.push_back(Point3f((float)j * m_squareSideSize,
                                           (float)i * m_squareSideSize,
                                           0));

    for (int i = 0; i< num; i++)
    {
        Mat img, drawn;
        std::vector<Point2f> corners;

        img = imagesToCalibrate.at(i);

        cvtColor(img, drawn, COLOR_BGR2GRAY);

        //detect
        found = findChessboardCorners( drawn, boardSize, corners,
                                       CALIB_CB_ADAPTIVE_THRESH | CALIB_CB_FAST_CHECK |
                                       CALIB_CB_NORMALIZE_IMAGE);

        if(found)
        {
            cornerSubPix(drawn, corners,
                         Size(11, 11), Size(-1, -1),
                         TermCriteria( CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 50, 0.1));

            //drawChessboardCorners(img, m_squareSideSize, corners, found);

            image_points.push_back(corners);
            object_points.push_back(chessPattern);

            //rms = calibrateCamera( object_points, image_points, drawn.size(), cameraMatrix, distCoeffs, rvecs, tvecs);
        }
    }


}



QString CamCalibration::returnCamParameters()
{
    QString calibrate;

    // Information with calibrated parameters
    std::ostringstream fs;

    fs << "num_images: " << imagesToCalibrate.count() << std::endl;
    fs << "image_width: " << m_imageWidth << std::endl;
    fs << "image_height: " << m_imageHeight << std::endl;
    fs << "board_width: " << m_numSquaresX << std::endl;
    fs << "board_height: " << m_numSquaresY << std::endl;
    fs << "square_size: " << m_squareSideSize << std::endl;
    fs << "square_unit: " << "m" << std::endl  << std::endl;
    fs << "camera_matrix"  << std::endl << cameraMatrix << std::endl << std::endl;
    fs << "distortion_coefficients"  << std::endl << distCoeffs << std::endl;

    calibrate = QString::fromStdString(fs.str().c_str());

    return calibrate;
}


bool CamCalibration::saveCamParameters(QString file)
{
    qDebug() << "Entrou: " << file;

    FileStorage fs;

    fs.open(file.toUtf8().constData(),
            FileStorage::WRITE | FileStorage::FORMAT_YAML );

    if (!fs.isOpened())
        return false;


    fs << "num_images" << imagesToCalibrate.count();
    fs << "image_width" << m_imageWidth ;
    fs << "image_height" << m_imageHeight;
    fs << "board_width" << m_numSquaresX;
    fs << "board_height" << m_numSquaresY;
    fs << "square_size" << m_squareSideSize ;
    fs << "square_unit" << "m";
    fs << "camera_matrix" << cameraMatrix ;
    fs << "distortion_coefficients" << distCoeffs;

    fs.release();

    return true;
}
