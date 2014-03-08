/* GCompris - Colors.qml
 *
 * Original activity in the Gtk+ version of GCompris by
 * Pascal Georges (pascal.georges1@free.fr)
 *
 * Copyright (C) 2014 Bruno Coudoin
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
import "findit.js" as Activity

ActivityBase {
    id: activity
    focus: true

    property variant dataset
    property string backgroundImg
    property int itemWidth
    property int itemHeight

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: background
        signal start
        signal stop
        focus: true
        fillMode: Image.PreserveAspectCrop
        source: backgroundImg

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(main, background, bar, bonus,
                                  containerModel, questionItem,
                                  dataset) }
        onStop: { Activity.stop() }

        ListModel {
              id: containerModel
        }

        GridView {
            id: container
            model: containerModel
            x: main.width * 0.2
            y: main.height * 0.2
            width: main.width * 0.7
            height: main.height * 0.6
            interactive: false
            cellWidth: itemHeight + 10
            cellHeight: itemWidth + 10
            delegate: ColorItem {
                source: image
                audioSrc: audio
                question: text
                sourceSize.height: itemHeight
                sourceSize.width: itemWidth
            }
        }

        Audio {
            id: audioQuestion
        }

        Text {
            id: questionItem
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            font.pointSize: 24
            color: "white"
            style: Text.Raised
            styleColor: "gray"
            font.weight: Font.DemiBold

            function initQuestion() {
                text = Activity.getCurrentTextQuestion()
                if(Activity.getCurrentAudioQuestion()) {
                    audioQuestion.source = Activity.getCurrentAudioQuestion()
                    audioQuestion.play()
                }
                opacity = 1.0
            }

            onOpacityChanged: opacity == 0 ? initQuestion() : ""
            Behavior on opacity { PropertyAnimation { duration: 500 } }
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
