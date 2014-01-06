import QtQuick 2.1
import "core.js" as Core
import GCompris 1.0

Item {
    id: container
    anchors.fill: parent

    Rectangle {
        color: "#f8d600"
        x: 10
        width: 100
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        border.color: "#696da3"
        border.width: 1

        ListView {
            id: sectionList
            anchors.fill: parent
            anchors.centerIn: parent.center
            model: ActivityInfoTree.menuTree
            delegate: Image {
                source: "qrc:/gcompris/src/activities/" + icon;
                MouseArea {
                    anchors.fill: parent
                    onClicked: Core.selectActivity(ActivityInfoTree.menuTree[index]);
                }
            }
        }
    }

}
