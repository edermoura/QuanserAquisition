#ifndef IMAGEVIEWER_H
#define IMAGEVIEWER_H

#include <QObject>
#include <QQuickPaintedItem>
#include <QImage>
#include <QPainter>

class ImageViewer : public QQuickPaintedItem
{
    Q_OBJECT

    //Q_INVOKABLE void setImage(const QImage &img);

    //Q_PROPERTY(QImage actualFrame READ actualFrame WRITE setActualFrame)
    Q_PROPERTY(QImage image READ image WRITE setImage)

public:
    explicit ImageViewer(QQuickItem *parent = Q_NULLPTR);

    QImage image();

    void setImage(const QImage &img);


private:

    QImage currentImage;

    void paint(QPainter *painter);

signals:

public slots:
};

#endif // IMAGEVIEWER_H
