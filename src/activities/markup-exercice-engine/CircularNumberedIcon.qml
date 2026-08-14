import QtQuick 2.12
import QtQuick.Controls


Item {
    id: circularNumberedIconItem
    width: 40
    height: 30

    property string text: ""

    Rectangle {
        width: 30
        height: 30
        radius: 20
        color: "#7CB342"
        //x: parent.x

        Text {
            anchors.centerIn: parent
            text: circularNumberedIconItem.text
            color: "white"
            font.bold: true
            font.pointSize: 12
        }
    }
}
