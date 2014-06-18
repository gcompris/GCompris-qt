import QtQuick 2.2
import GCompris 1.0

Text {
    width: 140
    opacity: 0
    anchors.horizontalCenter: muncherLife.Center
    anchors.top: muncherLife.bottom
    anchors.topMargin: 20

    text: qsTr("Be careful, a troggle !")
    font.pointSize: ApplicationInfo.ratio * 20
    wrapMode: Text.WordWrap
    horizontalAlignment: Text.AlignHCenter
    color: "red"

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
