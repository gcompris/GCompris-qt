import QtQuick 2.0
import "core.js" as Core

Item {
    id: container
    width: parent.width
    height: parent.height

    ListModel {
        id: activities

        function add(activityName) {
            var qmlActivityInfo = Qt.createComponent("../" + activityName + "/ActivityInfo.qml")
            if (qmlActivityInfo.status == Component.Ready) {
                var currentActivityInfo = qmlActivityInfo.createObject(main);
                if (currentActivityInfo == null) {
                    console.log("error creating activityInfo" + activityName);
                    console.log(component.errorString());
                    return false;
                }
                activities.append( currentActivityInfo )
            }
        }
    }

    Component.onCompleted: {
        activities.add("leftright-activity")
        activities.add("leftright-activity")
        activities.add("leftright-activity")
        activities.add("leftright-activity")
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

            model: activities
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
