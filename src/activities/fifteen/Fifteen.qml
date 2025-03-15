/* GCompris - fifteen.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import core 1.0

import "../../core"
import "fifteen.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: activity.resourceUrl + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => { Activity.processPressedKey(event) }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias flipSound: flipSound
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias model: fifteenModel
            property string scene: bar.level < 5 ? activity.resourceUrl + "Fishing_Boat_Scene.svg" :
                                                   activity.resourceUrl + "Coastal_Path.svg"
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }
        
        property int pieceSize: Math.round(blueFrame.width * 0.222)


        GCSoundEffect {
            id: flipSound
            source: "qrc:/gcompris/src/core/resource/sounds/flip.wav"
        }

        Image {
            id: blueFrame
            source: activity.resourceUrl + "blueframe.svg"
            sourceSize.width: Math.min(activityBackground.width,
                                       activityBackground.height - bar.height) * 0.95
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -bar.height * 0.55
        }

        Grid {
            id: puzzleArea
            anchors.horizontalCenter: blueFrame.horizontalCenter
            anchors.verticalCenter: blueFrame.verticalCenter
            columns: 4
            spacing: 0

            property alias trans: trans

            ListModel {
                id: fifteenModel
            }


            move: Transition {
                id: trans
                NumberAnimation {
                    properties: "x, y"
                    easing.type: Easing.InOutQuad
                }
            }

            Repeater {
                id: repeater
                model: fifteenModel
                delegate: Item {
                    id: blockItem
                    width: activityBackground.pieceSize
                    height: activityBackground.pieceSize
                    clip: true
                    required property int value

                    Image {
                        id: image
                        source: blockItem.value ? items.scene : ""
                        sourceSize.width: activityBackground.pieceSize * 4
                        fillMode: Image.Pad
                        transform: Translate {
                            x: - activityBackground.pieceSize * ((blockItem.value - 1) % 4)
                            y: - activityBackground.pieceSize * Math.floor((blockItem.value - 1) / 4)
                        }
                    }

                    GCText {
                        id: text
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        text: blockItem.value && bar.level % 2 == 1 ? blockItem.value : ""
                        fontSize: mediumSize
                        color: "#ffe9f0fb"
                        style: Text.Outline
                        styleColor: "#ff1c4788"
                    }

                    MultiEffect {
                        anchors.fill: text
                        source: text
                        shadowEnabled: true
                        shadowBlur: 1.0
                        blurMax: 2
                        shadowHorizontalOffset: 3
                        shadowVerticalOffset: 3
                        shadowOpacity: 0.5
                    }
                }
            }
        }

        MultiPointTouchArea {
            x: puzzleArea.x
            y: puzzleArea.y
            width: puzzleArea.width
            height: puzzleArea.height
            enabled: !items.buttonsBlocked

            onPressed: (touchPoints) => checkTouchPoint(touchPoints)

            function checkTouchPoint(touchPoints: var) {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    var block = puzzleArea.childAt(touch.x, touch.y)
                    if(block.value === 0)
                        return
                    else if(!puzzleArea.trans.running && block) {
                        Activity.onClick(block.value)
                        if(Activity.checkAnswer()) {
                            items.buttonsBlocked = true
                            bonus.good('flower')
                        }
                        else
                            flipSound.play()
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
