import QtQuick 2.2
import QtQuick.Controls 1.2
import "qrc:/gcompris/src/core"
import GCompris 1.0

ActivityBase {
    id: menuActivity
    focus: true

    onHome: pageView.depth === 1 ? Qt.quit() : pageView.pop()

    onDisplayDialog: pageView.push(dialog)

    pageComponent: Image {
        source: "qrc:/gcompris/src/activities/menu/resource/background.svgz"
        fillMode: Image.PreserveAspectCrop

        function loadActivity() {
            activityLoader.item.menu = menuActivity
            pageView.push(activityLoader.item)
        }

        Loader {
            id: activityLoader
            asynchronous: true
            onStatusChanged: if (status == Loader.Ready) loadActivity()
        }

        property int iconWidth: 190 * ApplicationInfo.ratio
        property int iconHeight: 190 * ApplicationInfo.ratio
        property int cellWidth2: iconWidth+(main.width%iconWidth)/Math.round(main.width/iconWidth)
        property int cellHeight2: iconHeight * 1.35

        GridView {
            x: 0
            y: 10
            width: main.width
            height: main.height - 50
            cellWidth: cellWidth2
            cellHeight: cellHeight2
            focus: true
            clip: true
            model: ActivityInfoTree.menuTree
            delegate: Item {
                width: iconWidth+(main.width%iconWidth)/Math.round(main.width/iconWidth)
                height: iconHeight
                Rectangle {
                    id: background
                    width: cellWidth2 - 10
                    height: cellHeight2 - 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: 0.6
                    border.width: 2
                    border.color: "black"
                }
                Image {
                    source: "qrc:/gcompris/src/activities/" + icon;
                    anchors.top: background.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    sourceSize.height: iconHeight
                    anchors.margins: 5
                    Image {
                        source: "qrc:/gcompris/src/core/resource/difficulty" +
                                ActivityInfoTree.menuTree[index].difficulty + ".svgz";
                        anchors.top: parent.top
                        sourceSize.width: iconWidth * 0.15
                        x: 5
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
                ParticleSystemStar {
                    id: particles
                    anchors.fill: background
                }
                MouseArea {
                    anchors.fill: background
                    onClicked: {
                        particles.emitter.burst(50)
                        ActivityInfoTree.currentActivity = ActivityInfoTree.menuTree[index]
                        activityLoader.source = "qrc:/gcompris/src/activities/" +
                                ActivityInfoTree.menuTree[index].name
                        if (activityLoader.status == Loader.Ready) loadActivity()
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
