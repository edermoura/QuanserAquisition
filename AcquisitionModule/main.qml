import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1

ApplicationWindow {
    id: rootWindow
    visible: true
    width: 950
    height: 600
    title: qsTr("Quanser Experiment")


    property Component mainWindow: FirstWindow {
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 100

        onDecode: {
            stack.push(decodeWindow)
            stack.currentItem.forceActiveFocus();
        }

        onRecord: {
            stack.push(recordWindow)
            stack.currentItem.forceActiveFocus();
        }

        onCalibrate: {
            stack.push(calibrateWindow)
            stack.currentItem.forceActiveFocus();
        }
    }


    property Component decodeWindow: WindowDecode {
        onSair: { stack.pop() }
    }

    property Component recordWindow: WindowRecord{
        onSair: { stack.pop() }
    }

    property Component calibrateWindow: WindowCalibrate {
        onSair: { stack.pop() }
    }



    Column {
        id: column
        anchors.fill: parent

        Rectangle {
            id: rectangle
            height: 100
            color: "#000000"
            anchors.left: parent.left
            anchors.leftMargin: 0
            //anchors.top: parent.top
            //anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            border.width: 0
            border.color: "#00000000"
            //Layout.fillWidth: true


            Label {
                id: label
                y: 26
                width: 400
                text: qsTr("Quanser Experiment")
                anchors.verticalCenterOffset: 0
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                textFormat: Text.AutoText
                font.letterSpacing: 0
                font.wordSpacing: 0
                font.strikeout: false
                font.underline: false
                font.italic: false
                font.bold: false
                renderType: Text.QtRendering
                font.pointSize: 30
                font.family: "Calibri"
                color: "#FFFFFF"
            }
        }

        StackView {
            id: stack
            anchors.topMargin: 100
            anchors.fill: parent

            //Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillHeight: true
            Layout.fillWidth: true

            initialItem: mainWindow
        }
    }
}
