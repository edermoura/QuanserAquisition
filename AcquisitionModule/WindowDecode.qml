import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import Qt.labs.folderlistmodel 2.1
import QtQuick.Dialogs 1.2
import ArucoDetect 1.0


Rectangle {
    id: rectangle

    signal sair()
    width: 800
    height: 500
    anchors.fill: parent


    ArucoDetect {
        id: tagDetect
        //tagSize: tagSideSize.text
        //path: pathChoosed.text

        onNewLogEventSignal: {
            var msg = tagDetect.newLogEvent
            logText.text = msg + "\n" + logText.text
        }
    }



    RowLayout {
        id: barTop
        height: 50

        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 15

        RoundButton {
            id: btnBack
            text: "<"
            font.family: "Verdana"
            font.letterSpacing: -1
            font.weight: Font.Normal
            highlighted: true
            font.bold: true
            spacing: 0
            font.pointSize: 14

            onClicked: {
                sair()
            }
        }
    }



    RowLayout {
        id: barContent
        anchors.bottom: barDirectory.top
        anchors.bottomMargin: 15
        anchors.rightMargin: 15
        anchors.leftMargin: 15
        anchors.top: barTop.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.right: parent.right
        antialiasing: false
        transformOrigin: Item.Center
        Layout.fillHeight: false
        Layout.fillWidth: true

        spacing: 10

        ColumnLayout {
            id: abaFiles
            width: 0
            height: 0

            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                id: rectangle2
                width: 210
                height: 200
                color: "#ffffff"
                border.width: 1
                Layout.fillHeight: true
                Layout.fillWidth: false


                ListView {
                    id: listFiles
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    anchors.bottomMargin: 15
                    anchors.topMargin: 10
                    anchors.fill: parent
                    Layout.fillHeight: true

                    clip: true

                    //highlight: destaque
                    //highlightFollowsCurrentItem: false
                    //focus: true

                    FolderListModel {
                        id: folderModel
                        folder: "file:///" + pathChoosed.text
                        nameFilters: [imagesExtension.currentText]
                        showDirs: false
                    }

                    Component {
                        id: fileDelegate
                        Text {
                            text: fileName
                            font.pointSize: 10
                        }
                    }

                    Component {
                        id: destaque
                        Rectangle {
                            width: 180
                            height: 40
                            color: "lightsteelblue"
                            radius: 5
                            y: list.currentItem.y
                            Behavior on y {
                                SpringAnimation {
                                    spring: 100
                                    damping: 10
                                }
                            }
                        }
                    }

                    model: folderModel
                    delegate: fileDelegate
                }
            }
        }

        ColumnLayout {
            id: abaConfig
            width: 0
            height: 0
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillHeight: true
            Layout.fillWidth: true

            GridLayout {
                id: propSensors
                width: 300
                height: 0
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: false
                columns: 2
                enabled: selectSensors.checked

                FileDialog{
                    id: fileDialog
                    folder: shortcuts.documents
                    nameFilters: ["YML (*.yml)"];

                    onAccepted: {
                        configPath.text = fileDialog.fileUrl;
                        configPath.text = configPath.text.replace("file:///","");
                    }
                }


                Button {
                    id: btnCamCalibration
                    text: qsTr("Open Camera Calibration File")
                    font.pointSize: 12
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.rowSpan: 1

                    onClicked: {
                        fileDialog.open();
                    }
                }

                TextField {
                    id: configPath
                    enabled: false
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.rowSpan: 1
                    font.pointSize: 12
                }

                Label {
                    id: label1
                    text: qsTr("Tag Side [m]:")
                    font.pointSize: 12
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.fillWidth: false
                    Layout.minimumWidth: 0
                }


                TextField {
                    id: tagSideSize
                    text: qsTr("0.16")
                    font.pointSize: 12

                    onTextChanged: {
                        tagSideSize.text =  tagSideSize.text.replace(",",".");
                    }
                }

                Label {
                    id: label4
                    text: qsTr("Number of Tags:")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pointSize: 12
                }

                SpinBox {
                    id: numTags
                    font.pointSize: 12
                    value: 11
                    to: 50
                    Layout.fillWidth: true
                    editable: true
                }

                Label {
                    id: label
                    text: qsTr("Sampling Time [ms]")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    font.pointSize: 12
                }

                SpinBox {
                    id: cameraTs
                    to: 10000
                    value: 100
                    Layout.fillWidth: true
                    font.pointSize: 12
                    editable: true
                }

                Label {
                    id: label2
                    text: qsTr("Class of Tags")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pointSize: 12
                }


                ComboBox {
                    id: tagClasses
                    Layout.fillWidth: true
                    font.pointSize: 12
                    Layout.minimumWidth: 150

                    model: modelPortNames

                    onCurrentIndexChanged: {

                    }

                    onActivated:
                    {

                    }
                }



            }
        }

        ColumnLayout {
            id: abaPositions
            width: 100
            height: 100
        }
    }



    ColumnLayout {
        id: barDirectory
        spacing: 10
        anchors.bottomMargin: 15
        anchors.rightMargin: 15
        anchors.leftMargin: 15
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        RowLayout {
            id: barPathRun
            width: 0
            height: 50
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            Layout.fillWidth: true

            Label {
                id: label5
                text: qsTr("Path: ")
                font.pointSize: 12
            }

            TextField {
                id: pathChoosed
                text: qsTr("C:/")
                font.pointSize: 12
                Layout.fillWidth: true

                onTextChanged: {
                    tagDetect.path = pathChoosed.text;
                    //folderDialog.folder = pathChoosed.text;
                    folderModel.folder = "file:///" + pathChoosed.text;
                }
            }

            ComboBox {
                id: imagesExtension
                width: 100
                font.pointSize: 12
                model: ["*.jpg", "*.bmp", "*.png"]

                onCurrentIndexChanged: {
                    //folderModel.nameFilters = [imagesExtension.currentText]
                }
            }

            Button {
                id: btnChoosePath
                text: qsTr("Choose a Path")
                font.pointSize: 12
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                onClicked: {
                    folderDialog.open()
                }
            }

            Button {
                id: btnStarStop
                text: "Decode"
                font.pointSize: 12

                onClicked:
                {

                    /*ArucoDetect.startConversion(pathChoosed.text,
                                                imagesExtension.currentText,
                                                numTags.value,
                                                0,
                                                configPath.text);
                                                */

                    tagDetect.startConversion("a","b",1,2,"c");
                }
            }

            FileDialog{
                id: folderDialog
                folder: shortcuts.documents
                selectFolder: true

                onAccepted: {
                    pathChoosed.text = folderDialog.folder;
                    //tagDetect.path = pathChoosed.text;
                    pathChoosed.text = pathChoosed.text.replace("file:///","")
                }
            }
        }

        RowLayout {
            id: barLog
            width: 0
            height: 0
            Layout.fillHeight: false
            Layout.fillWidth: true

            Label {
                id:label3
                width: 50
                text: "Log of Activities:"
                font.pointSize: 12
            }

            Rectangle {
                id: rectangle1
                width: 200
                height: 40
                color: "#ffffff"
                border.width: 1
                Layout.fillHeight: false
                Layout.fillWidth: true

                Flickable {
                    id: flickable
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick

                    TextArea.flickable: TextArea {
                        id: logText
                        enabled: false
                        wrapMode: TextArea.Wrap
                        activeFocusOnTab: false
                    }

                    ScrollBar.vertical: ScrollBar {}
                }
            }
        }
    }
}
