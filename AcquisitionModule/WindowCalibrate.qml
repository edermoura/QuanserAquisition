import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import Qt.labs.folderlistmodel 2.1
import QtQuick.Dialogs 1.2
import CamCalibration 1.0


Rectangle {
    id: rectangle

    signal sair()
    width: 800
    height: 500
    anchors.fill: parent

    property int total: 0

    Component.onDestruction: {
        camCalib.stopCam();
    }

    CamCalibration {
        id: camCalib

        onNewImage: {
            selectedImages.append({"number" : total})
            total = total + 1;

            lImages.text = "Images (" + camCalib.countNumImages() + ")";
        }

        onRemovedImage: {
            listOfImages.model = selectedImages

            lImages.text = "Images (" + camCalib.countNumImages() + ")";
        }

        onStopped: {
            btnStarStop.text = "Start";
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
                camCalib.stopCam()
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

        GridLayout {
            id: propCalibratoin
            width: 300
            height: 0
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            Layout.fillHeight: true
            Layout.fillWidth: false
            columns: 2
            //enabled: selectSensors.checked


            Label {
                id: label
                width: 0
                height: 0
                text: qsTr("Camera Number")
                font.pointSize: 12
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.fillWidth: false
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                Layout.minimumWidth: 0
            }

            SpinBox {
                id: camNumber
                height: 20
                Layout.fillWidth: true
                to: 100
                font.pointSize: 12
                Layout.minimumWidth: 150
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                onValueChanged: {
                    camCalib.camNumber= camNumber.value;
                }
            }



            Label{
                id: lcalibrationFile
                text: qsTr(" Calibration File")
                font.pointSize: 12
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.fillWidth: false
                Layout.minimumWidth: 0
            }

            TextField {
                id: calibrationFile
                width: 200
                text: qsTr("CameraCalibration")
                font.pointSize: 12

                onTextChanged: {
                }
            }

            Label {
                id: lboardSquareSize
                text: qsTr("Square Size [m]")
                font.pointSize: 12
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.fillWidth: false
                Layout.minimumWidth: 0
            }

            TextField {
                id: boardSquareSize
                text: qsTr("0.025")
                font.pointSize: 12

                onTextChanged: {
                    camCalib.squareSideSize = boardSquareSize.text
                }
            }

            Label {
                id: lboardWidth
                text: qsTr("Board Width:")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 12
            }

            SpinBox {
                id: boardWidth
                font.pointSize: 12
                value: 5
                from: 3
                Layout.fillWidth: true
                editable: true

                onValueChanged: {
                    camCalib.numSquaresX = boardWidth.value
                }
            }

            Label {
                id: lboardHeigth
                text: qsTr("Board Height:")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 12
            }

            SpinBox {
                id: boardHeight
                font.pointSize: 12
                value: 5
                from: 3
                Layout.fillWidth: true
                editable: true

                onValueChanged: {
                    camCalib.numSquaresY = boardHeight.value
                }
            }

            Label {
                id: limgWidth
                text: qsTr("Image Width")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 12
            }

            SpinBox {
                id: imgWidth
                stepSize: 1
                to: 10000
                font.pointSize: 12
                value: 800
                from: 10
                //to: 10000
                Layout.fillWidth: true
                editable: true

                onValueChanged: {
                    camCalib.imageWidth = imgWidth.value
                }
            }


            Label {
                id: limgHeight
                text: qsTr("Image Height")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 12
            }

            SpinBox {
                id: imgHeight
                to: 10000
                font.pointSize: 12
                value: 600
                from: 10
                //to: 10000
                Layout.fillWidth: true
                editable: true

                onValueChanged: {
                    camCalib.imageHeight = imgHeight.value
                }
            }


        }


        ColumnLayout {
            id: abaImages
            width: 300
            height: 0
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillHeight: true
            Layout.fillWidth: true

            Label {
                id: lImages
                text: "Images (0)"
                font.pointSize: 11
            }

            Component {
                id: imagesList

                ImageBox {
                    id: imgBox
                    color: (listOfImages.currentIndex == index) ? "black":"lightgray"
                    image: camCalib.getImage(index)

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            listOfImages.currentIndex = index
                        }
                    }
                }
            }

            ListModel {
                id:selectedImages
            }

            Rectangle {
                id: rectImages
                width: 200
                height: 200
                color: "#ffffff"
                Layout.fillWidth: true
                border.color: "#b4b4b4"
                border.width: 1
                Layout.fillHeight: true
                //Layout.fillWidth: true

                ListView {
                    id:listOfImages
                    anchors.margins: 5
                    anchors.fill: parent

                    spacing: 20
                    clip: true

                    model: selectedImages

                    delegate: imagesList

                    focus: true
                }
            }

            Button {
                id: btnRemoveImg

                width: 200

                text: "Remove Image"
                Layout.preferredWidth: 200
                Layout.fillWidth: true

                onClicked: {

                    if (listOfImages.currentIndex >=0 )
                    {
                        camCalib.removeImageAt(listOfImages.currentIndex)
                        selectedImages.remove(listOfImages.currentIndex)
                    }
                }
            }
        }

        ColumnLayout {
            id: abaResult
            width: 200
            height: 100
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillHeight: true

            Label {
                id:lConfig
                text: "Camera Calibration Parameters"
                font.pointSize: 11
            }

            Rectangle {
                id: rectParam
                width: 200
                height: 200
                color: "#ffffff"
                border.width: 1
                Layout.fillHeight: true

                Flickable {
                    id: flick
                    anchors.fill: parent
                    anchors.margins: 5

                     contentWidth: edit.paintedWidth
                     contentHeight: edit.paintedHeight
                     clip: true

                     function ensureVisible(r)
                     {
                         if (contentX >= r.x)
                             contentX = r.x;
                         else if (contentX+width <= r.x+r.width)
                             contentX = r.x+r.width-width;
                         if (contentY >= r.y)
                             contentY = r.y;
                         else if (contentY+height <= r.y+r.height)
                             contentY = r.y+r.height-height;
                     }

                     TextEdit {
                         id: camParameters
                         width: flick.width
                         height: flick.height
                         font.pointSize: 10
                         //clip: true
                         focus: true
                         wrapMode: TextEdit.Wrap
                         onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                     }
                 }

                /*

                TextEdit {
                    id: camParameters
                    text: qsTr("")
                    font.family: "Courier"
                    anchors.fill: parent
                    anchors.margins: 5
                    font.pixelSize: 14
                    clip: true
                }
                */
            }

            Button {
                id: btnCalibrate

                width: 200

                text: "Calculate Parameters"
                Layout.preferredWidth: 200
                Layout.fillWidth: false

                onClicked: {

                    if(camCalib.camCalibrate())
                    {
                        camParameters.text = camCalib.returnCamParameters();
                        btnSave.enabled = true;
                    }
                }
            }

            Button {
                id: btnSave

                width: 200

                text: "Save Calibration Parameters"
                enabled: false
                Layout.preferredWidth: 200
                Layout.fillWidth: false

                onClicked: {

                    if(pathChoosed.text != "" && calibrationFile.text != "")
                    {
                        camCalib.saveCamParameters(pathChoosed.text + "/" + calibrationFile.text);
                    }
                }
            }
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
                text: qsTr("")
                font.pointSize: 12
                Layout.fillWidth: true

                onTextChanged: {
                    //tagDetect.path = pathChoosed.text;
                    //folderDialog.folder = pathChoosed.text;
                    //folderModel.folder = "file:///" + pathChoosed.text;
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
                text: "Start Camera"
                font.pointSize: 12

                onClicked:
                {
                    if(btnStarStop.text == "Start Camera")
                    {
                        camCalib.startCam();
                        btnStarStop.text = "Stop Camera";
                    }
                    else
                    {
                        camCalib.stopCam();
                        btnStarStop.text = "Start";
                    }


                }
            }

            FileDialog {
                id: folderDialog
                folder: shortcuts.documents
                selectFolder: true

                onAccepted: {
                    pathChoosed.text = folderDialog.folder;
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
