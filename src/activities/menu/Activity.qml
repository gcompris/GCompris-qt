import QtQuick 2.1
import "qrc:/gcompris/src/core"
import "qrc:/gcompris/src/core/core.js" as Core
import GCompris 1.0

Item {
    id: container
    focus: true
    signal nextPage
    signal previousPage

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


    DialogAbout { id: dialogAbout  }
    DialogHelp { id: dialogHelp }

    Bar {
        id: bar
        content: BarEnumContent { value: help | exit | about }
        onAboutClicked: {
            pageView.push(dialogAbout)
        }

        onHelpClicked: {
            dialogHelp.fill(ActivityInfoTree.rootMenu)
            pageView.push(dialogHelp)
        }
    }

    Keys.onPressed: {
        if (event.modifiers === Qt.ControlModifier &&
            event.key === Qt.Key_Q) {
            Qt.quit()
        }
    }

}
