import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import Qt.labs.folderlistmodel 2.1
import QtQuick.Dialogs 1.2
import BackEnd 1.0



Rectangle{
    id: rectangle

    signal sair()
    width: 800
    height: 500
    anchors.fill: parent


    BackEnd {
        id:bckEnd



        onNewLogEventSignal: {
            var msg = bckEnd.newLogEvent
            logText.text = msg + "\n" + logText.text
            /*

            // Get all messages from the list
            var i = 0;
            do{
                i++;
                console.log(msg);
                if (i == 30)
                    break;
            }while(msg != "noMessage")
            */
        }

        onSystemStoppedSignal: {

            if (btnStarStop.text === "Stop")
            {
                btnStarStop.enabled = true;
                btnStarStop.text = "Start";
            }
        }
    }


    ListModel {
        id: modelPortNames
    }



    ListModel {
        id: modelBaudRates
    }

    function loadAvailablePorts()
    {
        modelPortNames.clear()
        modelBaudRates.clear()
        var portas = bckEnd.serialPortAvailables

        for(var i = 0; i < portas.length; i++)
        {
            modelPortNames.append({text:portas[i]})
        }
    }

    function loadListBaudRates()
    {
        modelBaudRates.clear()
        var portas = bckEnd.serialPortAvailables

        if ( portas.length === 0 )
            return;

        bckEnd.serialPort = comboPort.currentIndex

        var vel = bckEnd.serialBaudRateList

        for (var i = 0; i < vel.length; i++)
        {
            modelBaudRates.append({text:vel[i]})
            //console.log("Velocidade: " + vel[i])
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
            id: abaCamera
            width: 0
            height: 0

            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true

            SwitchDelegate {
                id: selectCamera
                text: qsTr("Record Camera")
                font.pointSize: 12
                antialiasing: true
                checked: false
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                transformOrigin: Item.Center

                onCheckedChanged: {
                    bckEnd.toRecordCamera = selectCamera.checked
                    bckEnd.cameraNumber = camNumber.value
                    bckEnd.cameraSampleTime = camTs.value
                }
            }

            GridLayout {
                id: propCamera
                width: 0
                height: 0
                Layout.minimumWidth: 150
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                columns: 2
                Layout.fillWidth: false
                enabled: selectCamera.checked

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
                    to: 100
                    font.pointSize: 12
                    Layout.minimumWidth: 150
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                    onValueChanged: {
                        bckEnd.cameraNumber = camNumber.value;
                        //console.log(camTs.value)
                        //console.log(bckEnd.cameraNumber)
                    }
                }

                Label {
                    id: label2
                    text: qsTr("Camera Sampling Time")
                    font.pointSize: 12
                }

                SpinBox {
                    id: camTs
                    height: 20
                    font.pointSize: 12
                    from: 10
                    to: 10000
                    editable: true
                    //suffix: " [ms]"
                    //maximumValue: 1000
                    //minimumValue: 10
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    value: 100

                    onValueChanged: {
                        bckEnd.cameraSampleTime = camTs.value;
                    }
                }
            }
        }

        ColumnLayout {
            id: abaSensors
            width: 0
            height: 0
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillHeight: true
            Layout.fillWidth: true

            SwitchDelegate {
                id: selectSensors
                text: qsTr("Record Sensors")
                font.pointSize: 12
                checked: false
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.fillWidth: false

                onCheckedChanged: {
                    bckEnd.toRecordSensors = selectSensors.checked
                    bckEnd.sensorSampleTime = sensorTs.value
                }
            }

            GridLayout {
                id: propSensors
                width: 300
                height: 0
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: false
                columns: 2
                enabled: selectSensors.checked


                Label {
                    id: label1
                    text: qsTr("Port:")
                    font.pointSize: 12
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.fillWidth: false
                    Layout.minimumWidth: 0
                }

                Row {
                    id: row
                    width: 200
                    height: 400
                    Layout.fillWidth: true
                    spacing: 5

                    Image {
                        id: refreshImage
                        width: comboPort.height
                        height: comboPort.height
                        source: "imgs/refresh.svg"
                        antialiasing: true

                        MouseArea {
                            id: refreshClicked
                            hoverEnabled: true
                            antialiasing: true
                            anchors.fill: parent

                            onClicked: {
                                loadAvailablePorts();
                            }
                        }
                    }

                    ComboBox {
                        id: comboPort
                        font.pointSize: 12
                        Layout.minimumWidth: 150

                        model: modelPortNames

                        onCurrentIndexChanged: {
                            //loadListBaudRates()
                            //console.log("Port Choosed: " + comboPort.currentIndex)
                        }

                        onActivated:
                        {
                            loadListBaudRates()
                            //console.log("Port Choosed: " + comboPort.currentIndex)
                        }
                    }
                }

                Label {
                    id: label4
                    text: qsTr("Baund Rate")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    font.pointSize: 12
                }

                ComboBox {
                    id: comboBaudRate
                    font.pointSize: 12
                    Layout.fillWidth: true
                    model: modelBaudRates

                    onCurrentIndexChanged:
                    {
                        bckEnd.serialBaudRate = comboBaudRate.currentIndex
                        //console.log(bckEnd.baudRate)
                    }
                }

                Label {
                    id: label6
                    text: qsTr("Sensor Sampling Time")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    font.pointSize: 12
                }

                SpinBox {
                    id: sensorTs
                    font.pointSize: 12
                    from: 5
                    to: 10000
                    value: 20
                    Layout.fillWidth: true
                    editable: true

                    onValueChanged: {
                        bckEnd.sensorSampleTime = sensorTs.value;
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
                    bckEnd.path = pathChoosed.text;
                    folderDialog.folder = "file:///" + pathChoosed.text;
                    //console.log(bckEnd.path);
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
                text: "Start"
                font.pointSize: 12

                onClicked:
                {
                    if ((selectCamera.checked == false ) && (selectSensors.checked == false))
                    {
                        logText.text = "Choose a option to record.\n" + logText.text;
                        return;
                    }


                    if (pathChoosed.text === "")
                    {
                        logText.text = "Choose a valid path. \n" + logText.text;
                        //dialogGeral.open()
                        return;
                    }

                    if (btnStarStop.text === "Start")
                    {
                        bckEnd.startRecord();
                        logText.text = "";
                        btnStarStop.text = "Stop";
                    }
                    else
                    {
                        bckEnd.stopRecord();
                        btnStarStop.enabled = false;
                        //btnStarStop.text = "Start";
                    }
                }
            }

            FileDialog{
                id: folderDialog
                folder: shortcuts.documents
                selectFolder: true

                onAccepted: {
                    pathChoosed.text = folderDialog.folder;
                    bckEnd.path = pathChoosed.text;
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

            Label{
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
                    antialiasing: true
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick
                    focus: false


                    TextArea.flickable: TextArea {
                        id: logText
                        enabled: true
                        wrapMode: TextArea.Wrap
                        activeFocusOnTab: false

                    }

                    ScrollBar.vertical: ScrollBar {}
                }
            }
        }
    }
}
