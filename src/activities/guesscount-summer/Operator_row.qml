import QtQuick 2.1
import "../../core"
import "guesscount-summer.js" as Activity

Row {
    id: operator_row
    spacing: 40
    Rectangle{
        id: operator
        width: parent.width*0.328
        height: parent.height
        radius: 20.0;
        color: "red"
        GCText{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: qsTr("Operators")
        }
    }
    Repeater {
        model: Activity.signs
        delegate: DragTile{
            id: root
            type: "operators"
            width: parent.width*0.1
            height: parent.height
        }
    }
}
