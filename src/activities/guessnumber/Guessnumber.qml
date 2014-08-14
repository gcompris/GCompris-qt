/* GCompris - guessnumber.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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

import "../../core"
import "guessnumber.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
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
            property alias textzone: textarea
            property alias infoText: userInfo
            property alias answerArea: answer
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
            id: back
            anchors.fill: parent
            fillMode : Image.PreserveAspectCrop
            source: "resource/cave.svg"
        }

        Helico{
            id: helico
        }

        AnswerArea{
            anchors.right: back.right
            anchors.top: back.top
            id: answer
        }

        Text{
            id: textarea
            anchors.top: back.top
            anchors.topMargin: 10
            anchors.horizontalCenter: back.horizontalCenter
            text: "Entrez un nombre"
            color: "blue"
            font.bold: true
            font.pixelSize: 24
        }

        Text{
            id: userInfo
            anchors.top: back.top
            anchors.topMargin: 40
            anchors.horizontalCenter: back.horizontalCenter
            text: ""
            color: "red"
            font.bold: true
            font.pixelSize: 20
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

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
