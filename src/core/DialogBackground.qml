import QtQuick 2.2

Rectangle {
    id: dialogBackground
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 1000
    property bool isDialog: true
    property string title
    property string subtitle
    property Component content
    signal close

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

    // The cancel button
    Image {
        id: logo
        source: "qrc:/gcompris/src/core/resource/cancel.svgz";
        width: 70
        fillMode: Image.PreserveAspectFit
        anchors.right: parent.right
        visible: parent.width > 700
        smooth: true
        SequentialAnimation {
              id: anim
              running: true
              loops: Animation.Infinite
              NumberAnimation {
                  target: logo
                  property: "rotation"
                  from: -10; to: 10
                  duration: 500
                  easing.type: Easing.InOutQuad
              }
              NumberAnimation {
                  target: logo
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
