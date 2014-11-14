/* GCompris - drawnumber.qml
 *
 * Copyright (C) 2014 Emmanuel Charruau
 *
 * Authors:
 *   Olivier Ponchaut <opvg@mailoo.org> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
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
import "drawnumber.js" as Activity
import GCompris 1.0


ActivityBase {
    id: activity

    property bool clickanddrawflag: false
    property real pointImageOpacity: 1.0

    onStart: focus = true
    onStop: {}

    pageComponent: Item {
        id: background
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

            property alias pointImageRepeater: pointImageRepeater
            property alias segmentsRepeater: segmentsRepeater
            property alias imageBack: imageBack
        }


        onStart: { Activity.start(items, clickanddrawflag) }
        onStop: { Activity.stop() }

        Image {
            id: imageBack

            anchors.top: parent.top
            width: background.width
            height: background.height
        }


        Repeater {
            id: segmentsRepeater

            Rectangle {
                id: line

                opacity: 0
                color: "black"
                transformOrigin: Item.TopLeft
                x: modelData[0] * background.width / 800
                y: modelData[1] * background.height / 520
                property var x2: modelData[2] * background.width / 800
                property var y2: modelData[3] * background.height / 520
                width: Math.sqrt(Math.pow(x - x2, 2) + Math.pow(y- y2, 2))
                height: 3 * ApplicationInfo.ratio
                rotation: (Math.atan((y2 - y)/(x2-x)) * 180 / Math.PI) + (((y2-y) < 0 && (x2-x) < 0) * 180) + (((y2-y) >= 0 && (x2-x) < 0) * 180)

            }
        }



       Repeater {
            id: pointImageRepeater

            Image {
                id: pointImage

                source: Activity.url + "bluepoint.svg"
                sourceSize.height: background.height / 15
                x: modelData[0] * background.width / 801 - sourceSize.height/2
                y: modelData[1] * background.height / 521 - sourceSize.height/2
                z: pointImageRepeater.count - index

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        Activity.drawSegment(index)
                    }
                }

                GCText {
                    id: pointNumberText

                    opacity: pointImageOpacity
                    text: index
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 20
                    font.weight: Font.DemiBold
                    style: Text.Outline
                    styleColor: "black"
                    color: "white"
                }
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

    }

}
