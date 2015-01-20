import QtQuick 2.2
import QtQuick.Controls 1.1
import GCompris 1.0

Image {
    id: cancel
    source: "qrc:/gcompris/src/core/resource/cancel.svgz";
    fillMode: Image.PreserveAspectFit
    anchors.right: parent.right
    anchors.top: parent.top
    smooth: true
    sourceSize.width: 60 * ApplicationInfo.ratio
    anchors.margins: 10

    signal close

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
