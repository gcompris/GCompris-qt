/* GCompris - lightsoff.qml
*
* SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (Layout and visual refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "lightsoff.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {

    }

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/family/resource/background.svg"
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        property bool keyNavigationVisible: false

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property bool isPortrait: (background.height >= background.width - tux.width)
            property alias nightSky: nightSky.opacity
            property alias modelTable: modelTable
            readonly property var levels: activity.datasetLoader.data
            property bool blockClicks: false
            property int nbCell: 5
            property int cellSize: isPortrait ? Math.min((parent.height - bar.height * 2.5) / items.nbCell,
                                                         (parent.width - 40) / items.nbCell) :
                                                (parent.height - bar.height * 1.5) / items.nbCell
            property int nbCelToWin: 0
            property var lightRatio: items.nbCelToWin / (items.nbCell * items.nbCell)
        }

        onStart: {
            Activity.start(items)
        }
        onStop: {
            Activity.stop()
        }

        Keys.enabled: !items.blockClicks
        Keys.onPressed: {
            background.keyNavigationVisible = true
            if (event.key === Qt.Key_Left)
                grid.moveCurrentIndexLeft()
            if (event.key === Qt.Key_Right)
                grid.moveCurrentIndexRight()
            if (event.key === Qt.Key_Down)
                grid.moveCurrentIndexDown()
            if (event.key === Qt.Key_Up)
                grid.moveCurrentIndexUp()
            if (event.key === Qt.Key_Space || event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                Activity.windowPressed(grid.currentIndex)
        }

        states: [
            State {
                id: verticalState
                when: items.isPortrait
                AnchorChanges {
                    target: building
                    anchors.bottom: tux.verticalCenter
                }
            },
            State {
                id: horizontalState
                when: !items.isPortrait
                AnchorChanges {
                    target: building
                    anchors.bottom: tux.bottom
                }
            }
        ]

        Rectangle {
            id: nightSky
            color: "#052e3c"
            opacity: items.lightRatio
            anchors.fill: background
        }

        Image {
            id: sun
            source: "qrc:/gcompris/src/activities/menu/resource/all.svg"
            sourceSize.height: items.cellSize * 2 * items.nbCell / 5
            anchors {
                left: parent.left
                top: parent.top
                topMargin: (parent.height - land.height) * items.lightRatio
            }
            Behavior on anchors.topMargin {
                PropertyAnimation {
                    duration: 1000
                }
            }
        }

        Image {
            id: land
            source: Activity.url + "back.svg"
            anchors.bottom: parent.bottom
            anchors.top: tux.top
            anchors.left: parent.left
            anchors.right: parent.right
            fillMode: Image.PreserveAspectCrop
            sourceSize.height: height
        }
        Rectangle {
            id: buildingBorders
            color: "#808080"
            width: building.width + 5 * ApplicationInfo.ratio
            height: building.height + 2.5 * ApplicationInfo.ratio
            anchors.horizontalCenter: building.horizontalCenter
            anchors.bottom: building.bottom
        }
        Rectangle {
            id: building
            color: "#c8c8c8"
            width: gridarea.width
            anchors.top: grid.top
            anchors.bottom: tux.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: items.cellSize * -0.5
        }

        Rectangle {
            id: gridarea
            visible: false
            width: items.cellSize * items.nbCell
            anchors.top: parent.top
            anchors.bottom: tux.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        GridView {
            id: grid
            anchors.verticalCenter: gridarea.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: items.nbCell * items.cellSize
            height: width
            cellWidth: items.cellSize
            cellHeight: items.cellSize

            ListModel {
                id: modelTable
            }

            model: modelTable

            delegate: Rectangle {
                color: soluce === 1 ? "#20df543d" : "transparent"
                height: items.cellSize
                width: items.cellSize
                border {
                    color: soluce === 1 ? "#df543d" : "transparent"
                    width: items.cellSize * 0.025
                }
                radius: items.cellSize * 0.1

                BarButton {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: lighton === 1 ? Activity.url + "on.svg" : Activity.url + "off.svg"
                    sourceSize.height: items.cellSize
                    mouseArea.hoverEnabled: !items.blockClicks
                    mouseArea.enabled: !items.blockClicks
                    onClicked: Activity.windowPressed(index)
                    visible: true
                }
            }

            interactive: false
            keyNavigationWraps: true
            highlightFollowsCurrentItem: true
            highlight: Rectangle {
                width: items.cellSize
                height: items.cellSize
                color: "#EEEEEE"
                radius: items.cellSize * 0.1
                visible: background.keyNavigationVisible
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        Image {
            source: Activity.url + "grass.svg"
            anchors.verticalCenter: building.bottom
            anchors.horizontalCenter: building.horizontalCenter
            width: buildingBorders.width
            sourceSize.height: height
            fillMode: Image.TileHorizontally
        }

        BarButton {
            id: tux
            fillMode: Image.PreserveAspectFit
            source: "qrc:/gcompris/src/activities/ballcatch/resource/tux.svg"
            height: bar.height
            sourceSize.height: height
            visible: true
            anchors {
                right: parent.right
                rightMargin: 20
                bottom: bar.top
                bottomMargin: 20
            }
            onClicked: Activity.solve()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onClose: {
                home()
            }
            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent {
                value: help | home | level | reload | activityConfig
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            onStop: items.blockClicks = false
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
