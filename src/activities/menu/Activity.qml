import QtQuick 2.1
import "qrc:/gcompris/src/core"
import GCompris 1.0

ActivityBase {
    id: menuActivity
    focus: true

    onHome: { pageView.pop() }
    onDisplayDialog: {
        pageView.push(dialog)
    }

    pageComponent: Item {

        Loader { id: activityLoader }

        Rectangle {
            color: "#ececec"
            anchors.fill: parent

            GridView {
                x: 10
                y: 10
                width: main.width
                height: main.height - 200
                cellWidth: 210
                cellHeight: 210
                focus: true
                model: ActivityInfoTree.menuTree
                delegate: Item {
                    width: 200
                    height: 200
                    Rectangle {
                        id: background
                        anchors.fill: parent
                        opacity: 0.2
                        border.width: 2
                        border.color: "black"
                    }
                    Image {
                        source: "qrc:/gcompris/src/activities/" + icon;
                        anchors.top: background.top
                        anchors.horizontalCenter: parent.horizontalCenter
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
                        Text {
                            anchors.top: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            width: background.width
                            fontSizeMode: Text.Fit
                            minimumPointSize: 7
                            font.pointSize: 14
                            elide: Text.ElideRight
                            maximumLineCount: 2
                            wrapMode: Text.WordWrap
                            text: ActivityInfoTree.menuTree[index].title
                        }
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
    }

}
