/* GCompris - Algebra.qml
 *
 * Copyright (C) 2014 Aruna Sankaranarayanan <aruna.evam@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "algebra.js" as Activity

ActivityBase {
    id: activity

    property alias operand: operand

    onStart: {
        focus = true;
    }

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/algebra_by/resource/background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: Math.max(parent.width, parent.height)
        signal start
        signal stop

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
            property alias timer: timer
            property GCSfx audioEffects: activity.audioEffects
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

        Item {
            width: background.width - 60 * ApplicationInfo.ratio
            height: background.height
            Bar {
                id: bar

                content: BarEnumContent { value: help | home | level }
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
        }

        Balloon {
            id: balloon
            onTimeout: bonus.bad("smiley")
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
            x: parent.width * 0.25
            y: parent.height * 0.65
            anchors.right: undefined
            anchors.bottom: undefined
            currentSubLevel: 0
            numberOfSubLevels: 10
        }
    }

    Item {
        id: otherItems
        property alias iAmReady: iAmReady
        property alias firstOp: firstOp
        property alias secondOp: secondOp
        property alias numpad: numpad
        property int result
    }

    NumPad {
        id: numpad
        onAnswerChanged: Activity.questionsLeft()
        maxDigit: ('' + otherItems.result).length + 1
    }

    ReadyButton {
        id: iAmReady
        onClicked: Activity.run()
    }

    Flow {
        id: textFlow
        x: parent.width / 2 - width / 2
        y: 80
        width: parent.width / 2
        height: 100
        anchors.margins: 4
        spacing: 10

        AlgebraText {
            id: firstOp
            visible: !iAmReady.visible
        }

        AlgebraText {
            id: operand
            visible: firstOp.visible
        }

        AlgebraText {
            id: secondOp
            visible: !iAmReady.visible
        }

        AlgebraText {
            id: equals
            visible: firstOp.visible
            text: "="
        }

        AlgebraText {
            id: result
            visible: !iAmReady.visible
            text: numpad.answer
        }
    }
    Keys.onPressed: {
        numpad.updateAnswer(event.key, true);
    }

    Keys.onReleased: {
        numpad.updateAnswer(event.key, false);
    }
}
