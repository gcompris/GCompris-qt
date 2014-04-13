import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import GCompris 1.0

Rectangle {
    id: dialogConfig
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 1000
    property bool isDialog: true
    property string title
    property string subtitle
    property string content
    signal close
    signal start
    signal pause
    signal play
    signal stop

    visible: false
    title: "Configuration"
    property QtObject activityInfo: ActivityInfoTree.currentActivity
    //subtitle: activityInfo.section

    Row {
        spacing: 2
        Item { width: 10; height: 1 }

        Column {
            spacing: 10
            anchors.top: parent.top
            Item { width: 1; height: 10 }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogConfig.width - 30
                height: 52
                border.color: "black"
                border.width: 2

                Item {
                    id: title
                    width: parent.width
                    height: 32
                    Text {
                        text: dialogConfig.title
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Helvetica"
                        color: "black"
                        fontSizeMode: Text.Fit
                        minimumPointSize: 8
                        font.pointSize: 24
                        font.weight: Font.DemiBold
                    }
                }
                Item {
                    width: parent.width
                    height: 18
                    anchors.top: title.bottom
                    Text {
                        text: dialogConfig.subtitle
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Helvetica"
                        color: "black"
                        fontSizeMode: Text.Fit
                        minimumPointSize: 7
                        font.pointSize: 20
                    }
                }
            }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogConfig.width - 30
                height: dialogConfig.height - 100
                border.color: "black"
                border.width: 2
                anchors.margins: 100

                Flickable {
                    id: flick
                    anchors.margins: 8
                    anchors.fill: parent
                    // contentWidth: textContent.contentWidth
                    // contentHeight: textContent.contentHeight
                    flickableDirection: Flickable.VerticalFlick
                    clip: true

                    Column {
                        spacing: 10
                        // Put configuration here
                        CheckBox {
                            text: "Enable audio"
                            checked: ApplicationInfo.isAudioEnabled
                            style: CheckBoxStyle {
                                indicator: Image {
                                    sourceSize.height: 50 * ApplicationInfo.ratio
                                    source: control.checked ? "qrc:/gcompris/src/core/resource/apply.svgz" : "qrc:/gcompris/src/core/resource/cancel.svgz"
                                }
                            }
                            onCheckedChanged: {
                                ApplicationInfo.isAudioEnabled = checked;
                                print("audio enabled:" + ApplicationInfo.isAudioEnabled)
                            }
                        }
                        Switch {
                            style: SwitchStyle {
                                groove: Rectangle {
                                    color: control.checked ? "green" : "red"
                                    implicitWidth: 100
                                    implicitHeight: 20
                                    radius: 9
                                    border.color: control.activeFocus ? "darkblue" : "gray"
                                    border.width: 1
                                }
                            }
                        }
                        ComboBox {
                            currentIndex: 2
                            style: GCComboBoxStyle {}
                            model: ListModel {
                                id: cbItems
                                ListElement { text: "Banana"; color: "Yellow" }
                                ListElement { text: "Apple"; color: "Green" }
                                ListElement { text: "Coconut"; color: "Brown" }
                            }
                            width: 200
                            onCurrentIndexChanged:
                                console.debug(cbItems.get(currentIndex).text +
                                              ", " + cbItems.get(currentIndex).color)
                        }
                    }
                }
            }
            Item { width: 1; height: 10 }
        }
    }

    // The cancel button
    Image {
        id: cancel
        source: "qrc:/gcompris/src/core/resource/cancel.svgz";
        fillMode: Image.PreserveAspectFit
        anchors.right: parent.right
        anchors.top: parent.top
        smooth: true
        sourceSize.width: 60 * ApplicationInfo.ratio
        anchors.margins: 10
        SequentialAnimation {
            id: anim
            running: true
            loops: Animation.Infinite
            NumberAnimation {
                target: cancel
                property: "rotation"
                from: -10; to: 10
                duration: 500
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: cancel
                property: "rotation"
                from: 10; to: -10
                duration: 500
                easing.type: Easing.InOutQuad }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: close()
        }
    }

}
