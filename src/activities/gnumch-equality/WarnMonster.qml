import QtQuick 2.2
import GCompris 1.0

Rectangle {
    property var text : warningText

    width: warningText.contentWidth * 1.1
    height: warningText.height * 1.1
    opacity: 0
    border.width: 2
    radius: 5

    anchors.horizontalCenter: topPanel.horizontalCenter
    anchors.verticalCenter: topPanel.verticalCenter

    Text {
        id: warningText
        text: qsTr("Be careful, a troggle !")
        font.pointSize: ApplicationInfo.ratio * 25
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: "red"
    }

    onOpacityChanged: timerWarn.start()

    Timer {
        id: timerWarn
        interval: 2500

        onTriggered: parent.opacity = 0
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 500
        }
    }
}
