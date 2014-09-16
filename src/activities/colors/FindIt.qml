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
import GCompris 1.0

import "../../core"
import "findit.js" as Activity

ActivityBase {
    id: activity
    focus: true

    property var dataset
    property string backgroundImg
    property int itemWidth
    property int itemHeight
    
    property string mode: ""

    pageComponent: Image {
        id: background
        signal start
        signal stop
        focus: true
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        source: backgroundImg

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias containerModel: containerModel
            property alias questionItem: questionItem
        }
        onStart: { Activity.start(items, dataset, mode) }
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
                audioVoices: activity.audioVoices
                source: image
                audioSrc: audio
                question: text
                sourceSize.height: itemHeight
                sourceSize.width: itemWidth
            }
        }

        GCText {
            id: questionItem
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            font.pointSize: 24
            font.weight: Font.DemiBold
            style: Text.Outline
            styleColor: "white"
            color: "black"

            function initQuestion() {
                text = Activity.getCurrentTextQuestion()
                if(Activity.getCurrentAudioQuestion()) {
                    activity.audioVoices.append(Activity.getCurrentAudioQuestion())
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
            content: BarEnumContent { value: help | home | previous | next | repeat }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onRepeatClicked: if (ApplicationSettings.isAudioVoicesEnabled)
                                 questionItem.initQuestion()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

    }

}
