import QtQuick 2.1
import "../../core"
import "guesscount-summer.js" as Activity

Row {
    id: operator_row
    spacing: 40
    Rectangle{
        id: operator
        width: 350
        height: 100
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
            width: 100
            height: 100
        }
    }
}
