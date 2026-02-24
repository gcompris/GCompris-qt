/* GCompris - PegSolitaire.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../../core"
import "peg_solitaire.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property int numberOfLevel: 1
            property alias bonus: bonus
            property var gameGrid: Activity.englishBoard
            property bool useDefaultHole: true
            property alias boardRepeater: boardRepeater
            property alias smudgeSound: smudgeSound
            property bool initPieceRemoved: false
            property bool inputBlocked: true
            property bool alreadyWon: false
            // each undo item is an object with {"initialSlot": initialSlot, "destinationSlot": destinationSlot, "eatenSlot": eatenSlot}
            property list<var> undoList: []
            property list<var> redoList: []
            property int pegsToEat: 0
            property int pegsWhichCanMove: 0
            property alias boardDescription: descriptionPanel.textItem.text
            property alias descriptionVisible: descriptionPanel.visible
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.5
            anchors.topMargin: GCStyle.baseMargins * 2

            Row {
                spacing: boardArea.slotSize
                width: childrenRect.width
                height: childrenRect.height
                anchors.top: parent.top
                anchors.topMargin: -GCStyle.baseMargins
                anchors.horizontalCenter: parent.horizontalCenter

                GCButton {
                    id: undo
                    height: boardArea.slotSize
                    width: boardArea.slotSize
                    text: "";
                    theme: "noStyle"
                    onClicked: Activity.doUndo()
                    enabled: !items.inputBlocked && hasUndo
                    opacity: hasUndo ? 1 : 0
                    property bool hasUndo: (items.undoList && items.undoList.length > 0)
                    Image {
                        source: 'qrc:/gcompris/src/activities/chess/resource/undo.svg'
                        sourceSize.width: boardArea.slotSize
                        sourceSize.height: boardArea.slotSize
                        fillMode: Image.PreserveAspectFit
                    }
                    Behavior on opacity {
                        PropertyAnimation {
                            easing.type: Easing.InQuad
                            duration: 200
                        }
                    }
                }

                GCButton {
                    id: redo
                    height: boardArea.slotSize
                    width: boardArea.slotSize
                    text: "";
                    theme: "noStyle"
                    onClicked: Activity.doRedo()
                    enabled: !items.inputBlocked && hasRedo
                    opacity:  hasRedo ? 1 : 0
                    property bool hasRedo: (items.redoList && items.redoList.length > 0)
                    Image {
                        source: 'qrc:/gcompris/src/activities/chess/resource/redo.svg'
                        sourceSize.width: boardArea.slotSize
                        sourceSize.height: boardArea.slotSize
                        fillMode: Image.PreserveAspectFit
                    }
                    Behavior on opacity {
                        PropertyAnimation {
                            easing.type: Easing.InQuad
                            duration: 200
                        }
                    }
                }
            }

            GCTextPanel {
                id: descriptionPanel
                anchors.top: parent.top
                anchors.topMargin: -GCStyle.baseMargins
                anchors.horizontalCenter: parent.horizontalCenter
                fixedHeight: true
                panelHeight: boardArea.slotSize
                panelWidth: parent.width
                textItem.text: items.boardDescription
            }

            Rectangle {
                id: boardBorder
                width: boardArea.width + GCStyle.baseMargins
                height: boardArea.height + GCStyle.baseMargins
                radius: GCStyle.baseMargins
                color: "#452501"
                anchors.centerIn: boardArea
            }

            Item {
                id: boardArea
                width: childrenRect.width
                height: childrenRect.height
                x: Math.round((layoutArea.width - width)* 0.5)
                y: Math.round((layoutArea.height - height + slotSize + GCStyle.baseMargins)* 0.5)

                readonly property int slotSize: Math.min(layoutArea.width, layoutArea.height) / (items.gameGrid.gridDivider + 1) // add 1 for undo/redo buttons on top

                Repeater {
                    id: boardRepeater
                    model: 0 //items.gameGrid.gridCoordinates
                    delegate: GridSlot {
                        width: boardArea.slotSize
                        height: boardArea.slotSize
                        initPieceRemoved: items.initPieceRemoved
                        inputBlocked: items.inputBlocked
                    }

                    function resetBoard() {
                        for(var i = 0; i < boardRepeater.count; i++) {
                            boardRepeater.itemAt(i).resetSlot();
                        }
                    }
                }
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                activity.home()
            }
            onLoadData: {
                if(activityData && activityData["useDefaultHole"]) {
                    items.useDefaultHole = activityData["useDefaultHole"] === "true" ? true : false;
                }
            }
            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | reload | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel();
            onActivityConfigClicked: {
                activity.displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(unlockInput);
                loose.connect(unlockInput);
            }

            function unlockInput() {
               items.inputBlocked = false;
            }
        }
    }

}
