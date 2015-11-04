/* GCompris - Explore.qml
*
* Copyright (C) 2015 Djalil MESLI <djalilmesli@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
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
import QtGraphicalEffects 1.0

import "../../core"
import "explore.js" as Activity

ActivityBase {
    id: activity

    property string backgroundImage
    property var dataset
    property bool hasAudioQuestions

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: backgroundImage

        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 0
        }

        focus: true

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items

            property GCAudio audioEffects: activity.audioEffects
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias dataModel: dataModel
            property alias question: question
            property alias questionText: questionText
            property alias instructionText: instructionText
            property bool hasAudioQuestions: activity.hasAudioQuestions
            property int currentLevel
            property string currentAudio
        }

        Repeater {
            id: dataModel
            model: dataset.tab.length
            Animals {
                animalSource: dataset.tab[index].image
                xA: activity.width * dataset.tab[index].x
                yA: activity.height * dataset.tab[index].y
                animalWidth: activity.width * dataset.tab[index].width
                animalHeight: activity.height * dataset.tab[index].height
                title: dataset.tab[index].title
                description: dataset.tab[index].text
                imageSource: dataset.tab[index].image2
                question: dataset.tab[index].text2
                audio: dataset.tab[index].audio
            }
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            sourceSize.width: 80 * ApplicationInfo.ratio
            z: bar.z + 1

            visible: items.currentLevel == 1 && activity.hasAudioQuestions //&& ApplicationSettings.isAudioVoicesEnabled
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: 10 * ApplicationInfo.ratio
            }
            onClicked: Activity.repeat();
        }


        Rectangle {
            id: question
            width: questionText.width + 5
            height: questionText.height + 5
            color: "lightgray"
            radius: 10
            border.width: 3
            border.color: "black"
            opacity: 0
            anchors.bottom: instruction.top
            GCText {
                id: questionText
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "black"
                width: activity.width / 2
                wrapMode: Text.Wrap
            }
        }
        Rectangle {
            id: instruction
            width: instructionText.width + 5
            height: instructionText.height + 5
            color: "lightgray"
            radius: 10
            border.width: 3
            border.color: "black"
            anchors {
                left: parent.left
                margins: 20 * ApplicationInfo.ratio
            }
            y: parent.height / 4

            GCText {
                id: instructionText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.centerIn: parent.Center
                color: "black"
                width: activity.width / 6
                wrapMode: Text.Wrap
            }
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
        }
    }
}
