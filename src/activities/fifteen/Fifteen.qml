/* GCompris - fifteen.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Effects

import "../../core"
import "fifteen.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    property string mode: "fifteen"

    onActivityNextLevel: {
         Activity.nextLevel()
    }

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => {
            if(activity.mode == "fifteen") {
                Activity.processPressedKey(event);
            } else { // for sixteen mode
                Activity.sixteenPressedKey(event);
            }

        }

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
            onCurrentLevelChanged: activity.currentLevel = currentLevel
            property int numberOfLevel: 14
            onNumberOfLevelChanged: activity.numberOfLevel = numberOfLevel
            property alias bonus: bonus
            property string mode: activity.mode
            property alias model: fifteenModel
            property string scene: bar.level < 5 ? Activity.url + "Fishing_Boat_Scene.svg" :
                                                   Activity.url + "Coastal_Path.svg"
            property bool buttonsBlocked: false

            property alias topArrowsRepeater: topArrowsRepeater
            property alias bottomArrowsRepeater: bottomArrowsRepeater
            property alias leftArrowsRepeater: leftArrowsRepeater
            property alias rightArrowsRepeater: rightArrowsRepeater
            property SlideButton selectedButton: null
            property Repeater selectedRepeater: null
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }
        
        property int pieceSize: Math.round(blueFrame.width * 0.222)

        property int buttonSize: pieceSize

        GCSoundEffect {
            id: flipSound
            source: "qrc:/gcompris/src/core/resource/sounds/flip.wav"
        }

        Row {
            id: topArrowsRow
            anchors.top: parent.top
            anchors.horizontalCenter: blueFrame.horizontalCenter
            width: puzzleArea.width
            visible: activity.mode == "sixteen"
            Repeater {
                id: topArrowsRepeater
                model: 4
                SlideButton {
                    id: topButton
                    rotation: -90
                    direction: topButton.topDir
                }
            }
        }

        Row {
            id: bottomArrowsRow
            anchors.top: blueFrame.bottom
            anchors.horizontalCenter: blueFrame.horizontalCenter
            width: puzzleArea.width
            visible: activity.mode == "sixteen"
            Repeater {
                id: bottomArrowsRepeater
                model: 4
                SlideButton {
                    id: bottomButton
                    rotation: 90
                    direction: bottomButton.bottomDir
                }
            }
        }

        Column {
            id: leftArrowsRow
            anchors.right: blueFrame.left
            anchors.verticalCenter: blueFrame.verticalCenter
            height: puzzleArea.height
            visible: activity.mode == "sixteen"
            Repeater {
                id: leftArrowsRepeater
                model: 4
                SlideButton {
                    id: leftButton
                    rotation: 180
                    direction: leftButton.leftDir
                }
            }
        }

        Column {
            id: rightArrowsRow
            anchors.left: blueFrame.right
            anchors.verticalCenter: blueFrame.verticalCenter
            height: puzzleArea.height
            visible: activity.mode == "sixteen"
            Repeater {
                id: rightArrowsRepeater
                model: 4
                SlideButton {
                    id: rightButton
                    rotation: 0
                    direction: rightButton.rightDir
                }
            }
        }

        Image {
            id: blueFrame
            source: Activity.url + "blueframe.svg"
            sourceSize.width: Math.min(activityBackground.width,
                                       activityBackground.height - bar.height) * (mode == "sixteen" ? 0.69 : 0.95)
            anchors.top: mode == "sixteen" ? topArrowsRow.bottom : undefined
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: mode == "fifteen" ? parent.verticalCenter : undefined
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
            enabled: !items.buttonsBlocked && activity.mode == "fifteen"

            onPressed: (touchPoints) => checkTouchPoint(touchPoints)

            function checkTouchPoint(touchPoints) {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    var block = puzzleArea.childAt(touch.x, touch.y)
                    if(block.val === 0)
                        return
                    else if(!puzzleArea.trans.running && block) {
                        Activity.onClick(block.val)
                        if(Activity.isCorrectAnswer()) {
                            items.buttonsBlocked = true
                            bonus.good('flower')
                        }
                        else {
                            flipSound.play()
                        }
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
            Component.onCompleted: win.connect(activity.nextLevel)
        }
    }

}
