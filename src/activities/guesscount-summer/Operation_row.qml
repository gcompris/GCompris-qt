import QtQuick 2.1
import "../../core"
import "guesscount-summer.js" as Activity

Row{
    id: operation_row
    spacing: 40
    property int row_sum
    property int row_no
    Loader {
        id: operand1
        property int data_operand1
        width: 100
        height: 100
        source: row_no ? "Result.qml" : "DropTile.qml"
    }
     DropTile {
            id: operator
            type : "operators"
            width: 100
            height: 100
            property bool dropped: false
            property int data_operator
            onDropped: {
                dragTarget.dropped = True
            }
            onChildrenChanged: {
            }
        }
     DropTile {
            id: operand2
            type : "operands"
            width: 100
            height: 100
            property bool dropped: false
            property var data_operand2
            onDropped: {
                dragTarget.dropped = True
            }
            onChildrenChanged: {
            }
        }

    Rectangle {
        width: 100
        height: 100
        color: "transparent"
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: Activity.url+"equal.svg"
        }
        radius: 20.0
    }
    Rectangle {
        id: result
        width: 100
        height: 100
        border.color: "black"
        GCText{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: " "
        }
        radius: 20.0
    }
}
