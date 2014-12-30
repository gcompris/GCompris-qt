/* GCompris - guessnumber.qml
 *
 * Copyright (C) 2014 Thib ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   Clement Coudoin <clement.coudoin@free.fr> (GTK+ version)
 *   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
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

import "../../core"
import "guessnumber.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        fillMode : Image.PreserveAspectCrop
        source: "resource/cave.svg"
        anchors.fill: parent

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
            property alias helico: helico
            property alias textArea: textArea
            property alias infoText: userInfo
            property alias answerArea: answerArea
            property alias numpad: numpad
            property int currentMax: 0
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Helico {
            id: helico
        }

        GCText {
            id: textArea
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: numpad.columnWidth + 10
            anchors.right: answerArea.left
            horizontalAlignment: Text.AlignHCenter
            width: parent.width - answerArea.width - 10
            wrapMode: TextEdit.WordWrap
            color: "white"
            font.bold: true
            fontSize: 20
        }

        AnswerArea {
            id: answerArea
            anchors.right: parent.right
            anchors.rightMargin: numpad.columnWidth + 10
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        GCText {
            id: userInfo
            anchors.top: textArea.top
            anchors.topMargin: 15 + textArea.contentHeight
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.bold: true
            fontSize: mediumSize
        }

        NumPad {
            id: numpad
            onAnswerChanged: {
                if(answer && answerArea.userEntry != answer)
                    activity.audioEffects.play('qrc:/gcompris/src/activities/guessnumber/resource/helicopter.wav')
                answerArea.userEntry = answer
            }
            maxDigit: ("" + items.currentMax).length
            columnWidth: 60 * ApplicationInfo.ratio
        }

        Keys.onPressed: {
            numpad.updateAnswer(event.key, true);
        }

        Keys.onReleased: {
            numpad.updateAnswer(event.key, false);
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
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
