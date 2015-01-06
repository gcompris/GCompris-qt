/* GCompris - Enumerate.qml
*
* Copyright (C) 2014 Thib ROMAIN <thibrom@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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
import "enumerate.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        signal start
        signal stop
        fillMode: Image.PreserveAspectCrop
        source: Activity.url + "background.svgz"
        sourceSize.width: parent.width

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias answerColumnModel: answerColumn.model
            property alias itemListModel: itemList.model
        }

        DropArea {
            id: dropableArea
            anchors.left: background.left
            anchors.bottom: background.bottom
            width: background.width
            height: background.height
        }

        Column {
            anchors {
                right: parent.right
                bottom: keyboard.top
                margins: 10
            }
            spacing: 5

            Repeater
            {
                id: answerColumn
                AnswerArea {
                    imgPath: modelData
                    focus: true
                    backspaceCode: keyboard.backspace
                }
            }
        }

        Repeater
        {
            id: itemList

            ItemToEnumerate {
                source: modelData
                main: background
            }
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            keyHeight: 35 * ApplicationInfo.ratio
            equalKeyWidth: true
            layout: [ [
                    { label: "0" },
                    { label: "1" },
                    { label: "2" },
                    { label: "3" },
                    { label: "4" },
                    { label: "5" },
                    { label: "6" },
                    { label: "7" },
                    { label: "8" },
                    { label: "9" },
                    { label: keyboard.backspace }
                ] ]
            onKeypress: Activity.currentAnswerItem.appendText(text)

            onError: console.log("VirtualKeyboard error: " + msg);
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            anchors.bottom: keyboard.top
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
            onWin: {
                activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/bonus.wav")
            }
        }
    }
}
