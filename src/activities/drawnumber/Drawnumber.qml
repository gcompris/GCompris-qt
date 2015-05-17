/* GCompris - drawnumber.qml
 *
 * Copyright (C) 2014 Emmanuel Charruau <echarruau@gmail.com>
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
            property GCAudio audioEffects: activity.audioEffects

            property alias pointImageRepeater: pointImageRepeater
            property alias segmentsRepeater: segmentsRepeater
            property alias imageBack: imageBack
            property int pointIndexToClick
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

        Item {
            id: playArea
            anchors.fill: parent

            Repeater {
                id: pointImageRepeater

                Image {
                    id: pointImage

                    source: Activity.url + (highlight ?
                                                (pointImageOpacity ? "bluepoint.svg" : "bluepointHighlight.svg") :
                                                "greenpoint.svg")
                    sourceSize.height: background.height / 15
                    x: modelData[0] * background.width / 801 - sourceSize.height/2
                    y: modelData[1] * background.height / 521 - sourceSize.height/2
                    z: items.pointIndexToClick == index ? 1000 : index
                    visible: index == pointImageRepeater.count - 1 &&
                             items.pointIndexToClick == 0 ? false : true

                    function drawSegment() {
                        Activity.drawSegment(index)
                    }
                    property bool highlight: false

                    GCText {
                        id: pointNumberText

                        opacity: pointImageOpacity
                        text: index + 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        fontSize: 18
                        font.weight: Font.DemiBold
                        style: Text.Outline
                        styleColor: "black"
                        color: "white"
                    }

                    ParallelAnimation {
                        id: anim
                        running: pointImageOpacity == 0 && items.pointIndexToClick == index
                        loops: Animation.Infinite
                        SequentialAnimation {
                            NumberAnimation {
                                target: pointImage
                                property: "rotation"
                                from: -150; to: 150
                                duration: 3000
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                target: pointImage
                                property: "rotation"
                                from: 150; to: -150
                                duration: 3000
                                easing.type: Easing.InOutQuad
                            }
                        }
                        SequentialAnimation {
                            NumberAnimation {
                                target: pointImage
                                property: "scale"
                                from: 1; to: 1.5
                                duration: 1500
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                target: pointImage
                                property: "scale"
                                from: 1.5; to: 1
                                duration: 1500
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                target: pointImage
                                property: "scale"
                                from: 1; to: 1.5
                                duration: 1500
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                target: pointImage
                                property: "scale"
                                from: 1.5; to: 1
                                duration: 1500
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            }
        }

        MultiPointTouchArea {
            anchors.fill: parent
            minimumTouchPoints: 1
            maximumTouchPoints: 1
            z: 100

            function checkPoints(touchPoints) {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    for(var p = 0; p < pointImageRepeater.count; p++) {
                        var part = pointImageRepeater.itemAt(p)
                        // Could not make it work with the item.contains() api
                        if(touch.x > part.x && touch.x < part.x + part.width &&
                           touch.y > part.y && touch.y < part.y + part.height) {
                            part.drawSegment()
                        }
                    }
                }

            }

            onPressed: {
                checkPoints(touchPoints)
            }
            onTouchUpdated: {
                checkPoints(touchPoints)
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
