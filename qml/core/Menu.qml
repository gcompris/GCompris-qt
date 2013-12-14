import QtQuick 2.0
import "core.js" as Core
import GCompris 1.0

Item {
    id: container
    width: parent.width
    height: parent.height

    Component.onCompleted: {
    }

    Rectangle {
        color: "#ececec"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
    }

    Rectangle {
        color: "#f8d600"
        x: 10
        width: 100
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        border.color: "#696da3"
        border.width: 1

        ListView {
            anchors.fill: parent

            model: ActivityInfoTree.menuTree
            delegate: Image {
                source: "../" + dir + "/" + icon;
                MouseArea {
                    anchors.fill: parent
                    onClicked: Core.startActivity(dir);
                }
            }
        }
    }

    Rectangle {
        color: "#f8d600"
        x: 120
        y: -10
        width: parent.width
        height: 75
        border.color: "#696da3"
        border.width: 1
        radius: 10
    }
}
