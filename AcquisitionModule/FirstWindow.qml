import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1


Rectangle {
    id: rectangle
    color: "#464646"
    //anchors.fill: parent

    signal record()
    signal decode()
    signal calibrate()

    Column {
        id: rootColumn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 50


        Rectangle{
            id: btnRecord
            width: 400
            height: 100
            color: "#767676"
            radius: 0
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    record()
                    //console.log("record")
                }
            }

            Text {
                id: text2
                color: "#ffffff"
                text: qsTr("Record Data")
                anchors.left: parent.left
                anchors.leftMargin: 50
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 25
            }

            Image {
                id: image2
                width: 80
                height: 80
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: "imgs/ForwardArrow.svg"
            }
        }


        Rectangle {
            id: btnDecode
            width: 400
            height: 100
            color: "#767676"
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    decode()
                    //console.log("decode")
                }
            }

            Text {
                id: text1
                color: "#ffffff"
                text: qsTr("Decode Images")
                anchors.left: parent.left
                anchors.leftMargin: 50
                font.bold: false
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 25
            }

            Image {
                id: image1
                width: 80
                height: 80
                smooth: true
                antialiasing: true
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: "imgs/ForwardArrow.svg"
            }
        }




        Rectangle {
            id: btnCalibrate
            width: 400
            height: 100
            color: "#767676"
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    calibrate()
                    //console.log("decode")
                }
            }

            Text {
                id: text3
                color: "#ffffff"
                text: qsTr("Camera Calibrate")
                anchors.left: parent.left
                anchors.leftMargin: 50
                font.bold: false
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 25
            }

            Image {
                id: image3
                width: 80
                height: 80
                smooth: true
                antialiasing: true
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: "imgs/ForwardArrow.svg"
            }
        }

    }


}
