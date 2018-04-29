/* GCompris - BinaryBulb.qml
 *
 * Copyright (C) 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * Authors:
 *   RAJAT ASTHANA <rajatasthana4@gmail.com>
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
import "binary_bulb.js" as Activity
import "numbers.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property var dataset: Dataset

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "resource/background.svg"
        signal start
        signal stop

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
            property alias bulbs: bulbs
            property int numberSoFar: 0
            property int numberToConvert: 0
            property int numberOfBulbs: 0
            property int currentLevel: 0
            property alias score: score
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }

        IntroMessage {
            id: message
            onIntroDone: {
                Activity.initLevel()
            }
            intro: [
                qsTr("Computers use Binary number system, where there are two symbols, 0 and 1."),
                qsTr("In decimal number system 123 is represented as 1 x 100 + 2 x 10 + 3 x 1"),
                qsTr("Binary represents numbers in the same pattern, but using powers of 2 instead of powers of 10 that decimal uses"),
                qsTr("So, 1 in binary is represented by 001, 4 by 100, 7 by 111 and so on.."),
                qsTr("Our computer has many many switches (called transistors) that can be turned on or off given electricity, and a switch that is on will represent a 1 and a switch that is off will represent a 0."),
                qsTr("In this activity, you are given a number, you have to find its binary representation by turning on the bulbs. An on bulb representes 1 and an off bulb represents 0")
            ]
            z: 20
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
        }

        Keys.onPressed: {
            if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                Activity.equalityCheck()
            }
        }

        Rectangle {
            id: questionItemBackground
            opacity: 0.00
            z: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 10
            }
            width: parent.width - 20
            height: parent.height * 0.30
        }

        GCText {
            id: questionItem
            anchors.fill: questionItemBackground
            anchors.bottom: questionItemBackground.bottom
            fontSizeMode: Text.Fit
            fontSize: largeSize
            wrapMode: Text.Wrap
            z: 10
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("What is the binary representation of %1?").arg(items.numberToConvert)
        }

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 10 * ApplicationInfo.ratio
            Repeater {
                id: bulbs
                model: items.numberOfBulbs
                LightBulb {
                    height: background.height / 5
                    width: (background.width > background.height) ? (background.width / 20) : ((background.width - (16 * row.spacing)) / 8)
                }
            }
        }

        GCText {
            id: reachedSoFar
            anchors.horizontalCenter: row.horizontalCenter
            anchors.top: row.bottom
            anchors.topMargin: 25
            color: "white"
            fontSize: largeSize
            text: items.numberSoFar
            visible: Dataset.get()[items.currentLevel].enableHelp
        }

        BarButton {
            id: okButton
            anchors {
                bottom: bar.top
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                bottomMargin: 10 * ApplicationInfo.ratio
            }
            source: "/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 60 * ApplicationInfo.ratio
            onClicked: Activity.equalityCheck()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Score {
            id: score
            anchors.bottom: bar.top
            anchors.right: bar.right
            anchors.left: parent.left
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.rightMargin: 0
        }        

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
