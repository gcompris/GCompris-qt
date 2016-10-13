import QtQuick 2.1

import "../../core"

Rectangle {
    id: buttonRoot
    width: 100
    height: 50
    property alias text: buttonText.text
    signal clicked
    color: (buttonMouseArea.pressed)
           ? "grey"
           : "transparent"
    border.width: 2
    border.color: Qt.darker("grey", 1.1)
    GCText {
        id: buttonText
        anchors.centerIn: parent
        fontSize: regularSize
    }
    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        onClicked: {
            buttonRoot.clicked()
        }
    }
}
