/* GCompris - Scalesboard.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   miguel DE IZARRA <miguel2i@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "scalesboard.js" as Activity
import "."

ActivityBase {
    id: activity

    property var dataset

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop

        property int scaleHeight: items.masseAreaLeft.weight == items.masseAreaRight.weight ? 0 :
                                 items.masseAreaLeft.weight > items.masseAreaRight.weight ? 20 : -20

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property int numberOfSubLevels
            property int currentSubLevel
            property int giftWeight
            property var dataset: activity.dataset
            property alias masseAreaCenter: masseAreaCenter
            property alias masseAreaLeft: masseAreaLeft
            property alias masseAreaRight: masseAreaRight
            property alias masseCenterModel: masseAreaCenter.masseModel
            property alias masseRightModel: masseAreaRight.masseModel
            property alias question: question
            property alias numpad: numpad
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool vert: background.width > background.height

        onScaleHeightChanged: Activity.initCompleted && scaleHeight == 0 && question.hasText == "" ?
                                  bonus.good("flower") :
                                  activity.audioEffects.play('qrc:/gcompris/src/activities/erase/resource/eraser2.wav')

        Image {
            id: scale
            source: Activity.url + "scale.svg"
            sourceSize.width: Math.min(parent.width - 10 * ApplicationInfo.ratio,
                                       (parent.height - bar.height - 10 * ApplicationInfo.ratio) * 2)
            anchors.centerIn: parent
        }

        Image {
            id: needle
            parent: scale
            source: Activity.url + "needle.svg"
            sourceSize.width: parent.width * 0.75
            z: -10
            property int angle: - background.scaleHeight * 0.35
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.15
            }
            transform: Rotation {
                origin.x: needle.width / 2
                origin.y: needle.height * 0.9
                angle: needle.angle
            }
            Behavior on angle {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // === The Left plate ===
        Image {
            id: plateLeft
            parent: scale
            source: Activity.url + "plate.svg"
            sourceSize.width: parent.width * 0.35
            z: -1

            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: - parent.paintedWidth * 0.3
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.03 + background.scaleHeight
            }
            Behavior on anchors.verticalCenterOffset {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            // The Left Drop Area
            MasseArea {
                id: masseAreaLeft
                parent: scale
                width: plateLeft.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: - parent.paintedWidth * 0.3
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: - parent.paintedHeight * 0.44 + background.scaleHeight
                }
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                nbColumns: 3
                audioEffects: activity.audioEffects

                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // === The Right plate ===
        Image {
            id: plateRight
            parent: scale
            source: Activity.url + "plate.svg"
            sourceSize.width: parent.width * 0.35
            z: -1
            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: parent.paintedWidth * 0.3
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.03 - background.scaleHeight
            }
            Behavior on anchors.verticalCenterOffset {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            // The Right Drop Area
            MasseArea {
                id: masseAreaRight
                parent: scale
                width: plateRight.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.paintedWidth * 0.3
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: - parent.paintedHeight * 0.44 - background.scaleHeight
                }
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                nbColumns: 3
                dropEnabledForThisLevel: items.dataset[bar.level - 1].rightDrop
                audioEffects: activity.audioEffects

                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // === The Initial Masses List ===
        MasseArea {
            id: masseAreaCenter
            parent: scale
            x: parent.width * 0.05
            y: parent.height * 0.84 - height
            width: parent.width
            masseAreaCenter: masseAreaCenter
            masseAreaLeft: masseAreaLeft
            masseAreaRight: masseAreaRight
            nbColumns: masseModel.count
            audioEffects: activity.audioEffects
        }


        Message {
            id: message
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 10
                left: parent.left
                leftMargin: 10
            }
        }

        Question {
            id: question
            parent: scale
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.45
            z: 1000
            width: parent.width - y
            text: items.dataset[bar.level - 1].question && background.scaleHeight == 0 ?
                      items.dataset[bar.level - 1].question : ""
            answer: items.giftWeight

            property bool hasText: items.dataset[bar.level - 1].question ? true : false
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()

            onLevelChanged: message.text = items.dataset[bar.level - 1].message ? items.dataset[bar.level - 1].message : ""
        }

        Score {
            id: score
            anchors {
                bottom: background.vert ? background.bottom : bar.top
                right: parent.right
                bottomMargin: 10 * ApplicationInfo.ratio
            }

            numberOfSubLevels: items.numberOfSubLevels
            currentSubLevel: items.currentSubLevel
            opacity: question.displayed ? 0 : 1
        }

        NumPad {
            id: numpad
            onAnswerChanged: question.userEntry = answer
            maxDigit: ('' + items.giftWeight).length + 1
            opacity: question.displayed ? 1 : 0
            columnWidth: 60 * ApplicationInfo.ratio
        }

        Keys.onPressed: {
            if(question.displayed) {
                numpad.updateAnswer(event.key, true);
            }
        }

        Keys.onReleased: {
            if(question.displayed) {
                numpad.updateAnswer(event.key, false);
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }

}
