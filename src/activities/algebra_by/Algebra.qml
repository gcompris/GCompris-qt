/* GCompris - Algebra.qml
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
import "algebra.js" as Activity

ActivityBase {
    id: activity
    focus: true

    property alias operand: operand

    onStart: {
        focus = true;
    }

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

        Item {
            id: coreItems
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias balloon: balloon
            property alias timer:timer
        }

        onStart: Activity.start(coreItems, otherItems, operand)
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

        Score {
            id: score
            x: parent.width * 0.2
            y: parent.height * 0.65
            currentSubLevel: 0
            numberOfSubLevels: 10
        }
    }

    Item{
        id: otherItems
        property alias iAmReady: iAmReady
        property alias firstOp:firstOp
        property alias secondOp:secondOp
        property alias numpad:numpad
    }

    NumPad {
        id: numpad
        onAnswerChanged: Activity.questionsLeft()
    }

    ReadyButton {
        id: iAmReady
        onClicked: Activity.run()
    }

    Flow {
        id:textFlow
        x: 200 * ApplicationInfo.ratio
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
            id: operand
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
    Keys.onPressed: {
        Activity.keyEvent(event.key, true)
    }

    Keys.onReleased: {
        Activity.keyEvent(event.key, false)
    }
}
