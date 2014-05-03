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
import QtMultimedia 5.0

import "qrc:/gcompris/src/core"
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
                bottom: parent.bottom
                margins: 10
            }
            spacing: 5

            Repeater
            {
                id: answerColumn
                AnswerArea {
                    imgPath: modelData
                    focus: true
                }
            }
        }

        Repeater
        {
            id: itemList

            ItemToEnumerate {
                imgPath: modelData
                main: background
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Audio {
            id: winAudio
            source: "qrc:/gcompris/src/core/resource/sounds/bonus.wav"
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
            onWin: {
                winAudio.play()
            }
        }
    }
}
