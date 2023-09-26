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
import QtQuick 2.12
import QtGraphicalEffects 1.0

import "../../core"
import "fifteen.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Keys.onPressed: Activity.processPressedKey(event)

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property GCSfx audioEffects: activity.audioEffects
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias model: fifteenModel
            property string scene: bar.level < 5 ? Activity.url + "Fishing_Boat_Scene.svg" :
                                                   Activity.url + "Coastal_Path.svg"
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }
        
        property int pieceSize: Math.round(blueFrame.width * 0.222)

        Image {
            id: blueFrame
            source: Activity.url + "blueframe.svg"
            sourceSize.width: Math.min(background.width,
                                       background.height - bar.height) * 0.95
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
                    width: pieceSize
                    height: pieceSize
                    clip: true
                    property int val: value

                    Image {
                        id: image
                        source: value ? items.scene : ""
                        sourceSize.width: pieceSize * 4
                        fillMode: Image.Pad
                        transform: Translate {
                            x: - pieceSize * ((value - 1) % 4)
                            y: - pieceSize * Math.floor((value - 1) / 4)
                        }
                    }

                    GCText {
                        id: text
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        text: value && bar.level % 2 == 1 ? value : ""
                        fontSize: mediumSize
                        color: "#ffe9f0fb"
                        style: Text.Outline
                        styleColor: "#ff1c4788"
                    }

                    DropShadow {
                        anchors.fill: text
                        cached: false
                        horizontalOffset: 3
                        verticalOffset: 3
                        radius: 1
                        samples: 16
                        color: "#ff1c4788"
                        source: text
                    }
                }
            }
        }

        MultiPointTouchArea {
            x: puzzleArea.x
            y: puzzleArea.y
            width: puzzleArea.width
            height: puzzleArea.height
            onPressed: checkTouchPoint(touchPoints)

            function checkTouchPoint(touchPoints) {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    var block = puzzleArea.childAt(touch.x, touch.y)
                    if(block.val === 0)
                        return
                    else if(!puzzleArea.trans.running && block) {
                        Activity.onClick(block.val)
                        if(Activity.checkAnswer())
                            bonus.good('flower')
                        else
                            activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/flip.wav")
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
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
