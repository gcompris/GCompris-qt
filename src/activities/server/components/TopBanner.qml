import QtQuick 2.9
import "../../../core"

Item {

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }
    width: parent.width
    height: parent.height/13

    Rectangle {
        anchors.fill: parent
        color: Style.colourNavigationBarBackground

        Text {
            id: textIcon
            width: Style.widthNavigationButtonIcon
            height: Style.heightNavigationButtonIcon
            leftPadding: 20
            font {
                pixelSize: Style.pixelSizeTopBannerText
            }
            color: Style.colourNavigationBarFont
            text: "Groups and pupils management"
            verticalAlignment: Text.AlignVCenter
        }
    }
}
