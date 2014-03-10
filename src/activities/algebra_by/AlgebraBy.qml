/* GCompris - AlgebraBy.qml
 *
 * Copyright (C) 2014 Aruna Sankaranarayanan and Bruno Coudoin
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

import QtQuick 2.1
import GCompris 1.0

import "qrc:/gcompris/src/core"
import "algebra_by.js" as Activity

ActivityBase {
    id: activity
    focus: true

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/algebra_by/resource/background.svgz"
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop
        focus: true

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart: Activity.start(main, background, bar, bonus, score, balloon,
                                iAmReady, firstOp, secondOp, timer, numpad)
        onStop: Activity.stop()

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Timer {
            id: timer
            interval: 1000
            onTriggered: Activity.run()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: {
                Activity.previousLevel()
            }
            onNextLevelClicked: {
                Activity.nextLevel()

            }
            onHomeClicked: home()
        }

        ReadyButton {
            id: iAmReady

            onClicked: Activity.run()
        }

        Balloon {
            id: balloon
            onTimeout: bonus.bad("smiley")
            onReady: console.log("ready")
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                loose.connect(Activity.run)
                win.connect(Activity.nextLevel)
            }
        }

        NumPad {
            id: numpad
            onAnswerChanged: Activity.questionsLeft()
        }

        Flow {
            x: 90 * ApplicationInfo.ratio
            y: 80
            width: parent.width / 2
            height: 100
            anchors.margins: 4
            spacing: 10

            Text {
                id: firstOp
                visible: !iAmReady.visible
                font.pointSize: 32
                font.bold: true
            }

            Text{
                id: multiply
                visible: firstOp.visible
                font.pointSize: 32
                text: "x"
                font.bold: true
            }

            Text{
                id: secondOp
                visible: !iAmReady.visible
                font.pointSize: 32
                font.bold: true
            }

            Text {
                id: equals
                visible: firstOp.visible
                font.pointSize: 32
                font.bold: true
                text: "="
            }

            Text {
                id: result
                visible: !iAmReady.visible
                font.pointSize: 32
                font.bold: true
                text: numpad.answer
            }
        }

        Score {
            id: score
            x: parent.width * 0.2
            y: parent.height * 0.65
            currentSubLevel: 0
            numberOfSubLevels: 10
        }
    }
}

