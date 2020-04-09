import QtQuick 2.6
import "../../../core"
import QtQuick.Controls 2.12

Button {
    property bool buttonHovered: false

    contentItem: Text {
        text: parent.text
        opacity: parent.hovered ? 1.0 : 0.7
        color: Style.colourNavigationBarBackground
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        opacity: parent.hovered ? 0.1 : 1
        radius: 2
        color: parent.hovered ? Style.colourNavigationBarBackground : Style.colourBackground
    }
}

