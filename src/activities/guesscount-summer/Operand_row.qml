import QtQuick 2.1
import "../../core"
import "guesscount-summer.js" as Activity

Row {
    id: operand_row
    property alias repeater: repeater
    property int row_sum
    spacing: 40
    Rectangle{
        id: operands
        width: 350;
        height: 100
        radius: 20.0;
        color: "green"
        GCText{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: qsTr("Numbers")
        }
    }

    Repeater {
        id: repeater
        delegate: DragTile{
            id: root
            type: "operands"
            width: 100
            height: 100
        }
    }
}
