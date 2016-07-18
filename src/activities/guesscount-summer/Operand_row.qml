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
        width: parent.width*0.328;
        height: parent.height
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
            width: parent.width*0.1
            height: parent.height
        }
    }
}
