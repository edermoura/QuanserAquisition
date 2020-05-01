import QtQuick 2.0
import ImageViewer 1.0

Rectangle {
    id: root

    width: parent.width
    height: 0.75*parent.width
    color: "white"

    property alias color: root.color
    property alias image: img.image

    radius: 1
    border.color: "lightgray"
    border.width: 1

    ImageViewer {
        id:img

        anchors.fill: parent
        anchors.margins: 5
    }
}
