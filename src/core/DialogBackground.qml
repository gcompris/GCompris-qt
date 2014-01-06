import QtQuick 2.1

Rectangle {
    id: dialogBackground
    color: "#696da3"
    radius: 6.0
    anchors.horizontalCenter: main.horizontalCenter
    anchors.verticalCenter: main.verticalCenter
    width: main.width > 800 ? 800 : main.width
    height: main.height > 500 ? 500 : main.height
    border.color: "black"
    border.width: 1
    z: 1000
    property string title
    property string subtitle
    property Component content

    MouseArea {
        anchors.fill: parent
        onClicked: dialogBackground.visible = false
    }

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
                width: dialogBackground.width - 30
                height: 52
                border.color: "black"
                border.width: 2

                Item {
                    id: title
                    width: parent.width
                    height: 32
                    Text {
                        text: dialogBackground.title
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
                        text: dialogBackground.subtitle
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
                width: dialogBackground.width - 30
                height: dialogBackground.height - 100
                border.color: "black"
                border.width: 2
                anchors.margins: 100

                Loader {
                    anchors.fill: parent
                    anchors.margins: 8
                    sourceComponent: content
                }
            }
            Item { width: 1; height: 10 }
        }
    }
}
