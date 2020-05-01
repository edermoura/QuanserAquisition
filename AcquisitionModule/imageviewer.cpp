#include "imageviewer.h"

ImageViewer::ImageViewer(QQuickItem *parent):QQuickPaintedItem(parent)
{

}


void ImageViewer::setImage(const QImage &img)
{
    currentImage = img.copy();
    update();
}


QImage ImageViewer::image()
{
    return currentImage.copy();
}


void ImageViewer::paint(QPainter *painter)
{
    QSizeF scaled = QSizeF(currentImage.width(),
                           currentImage.height()).scaled(boundingRect().size(),
                                                         Qt::KeepAspectRatio);

    QRect centerRect(qAbs(scaled.width() - width())/2.0f,
                     qAbs(scaled.height() - height())/2.0f,
                     scaled.width(),
                     scaled.height());

    painter->drawImage(centerRect,currentImage);
}

