import QtQuick 2.1
import "qrc:/gcompris/src/core"
import GCompris 1.0

ActivityBase {
    id: menuActivity
    focus: true

    onHome: { pageView.pop() }
    onDisplayDialog: {
        console.log("on display dialog")
        pageView.push(dialog)
    }

    Rectangle {
        color: "#ececec"
        anchors.fill: parent
    }

    Loader { id: activityLoader }

    ListView {
        id: sectionList
        anchors.fill: parent
        anchors.centerIn: parent.center
        model: ActivityInfoTree.menuTree
        delegate: Image {
            source: "qrc:/gcompris/src/activities/" + icon;
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    activityLoader.source = "qrc:/gcompris/src/activities/" +
                            ActivityInfoTree.menuTree[index].name + "/Activity.qml"
                    activityLoader.item.activityInfo = ActivityInfoTree.menuTree[index]
                    pageView.push(activityLoader.item)
                    activityLoader.item.home.connect(home)
                    activityLoader.item.displayDialog.connect(displayDialog)
                }
            }
        }
    }


    DialogAbout {
        id: dialogAbout
        onClose: home()
    }
    DialogHelp {
        id: dialogHelp
        onClose: home()
        activityInfo: ActivityInfoTree.rootMenu
    }

    Bar {
        id: bar
        content: BarEnumContent { value: help | exit | about }
        onAboutClicked: {
            displayDialog(dialogAbout)
        }

        onHelpClicked: {
            displayDialog(dialogHelp)
        }
    }

    Keys.onPressed: {
        if (event.modifiers === Qt.ControlModifier &&
            event.key === Qt.Key_Q) {
            Qt.quit()
        }
    }

}
