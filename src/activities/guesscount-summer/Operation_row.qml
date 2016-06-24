import QtQuick 2.1
import "../../core"
import "guesscount-summer.js" as Activity

Row{
    id: operation_row
    spacing: 40
    Repeater{
        id: repeat
        model: 3
        delegate: DropTile {
            id: dragTarget
            property int count: 0
            width: 100
            height: 100
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
