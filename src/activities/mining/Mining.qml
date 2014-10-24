/* GCompris - mining.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Peter Albrecht <pa-dev@gmx.de> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import "mining.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Item {
        id: background
        anchors.fill: parent

        signal start
        signal stop

        property bool gotIt: false

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias miningBg: miningBg
            property alias bar: bar
            property alias bonus: bonus
            property alias mineModel: mineObjects.model
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
                id: miningBg
                source: Activity.url + "rockwall.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                sourceSize.width: parent.width * 3
                width: parent.width
                height: parent.height
                scale: miningBg._MIN_SCALE

                property int subLevel
                property int maxSubLevel
                property real _MAX_SCALE: 3
                property real _MIN_SCALE: 1

                Image {
                    source: Activity.url + "vertical_border.svg"
                    sourceSize.height: parent.height * 3
                    width: parent.width * 0.05
                    anchors {
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                    }
                }

                Image {
                    source: Activity.url + "vertical_border.svg"
                    sourceSize.height: parent.height * 3
                    width: parent.width * 0.05
                    anchors {
                        top: parent.top
                        right: parent.right
                        bottom: parent.bottom
                    }
                }

                Image {
                    source: Activity.url + "horizontal_border.svg"
                    sourceSize.width: parent.width * 3
                    height: parent.height * 0.05
                    anchors {
                        top: parent.top
                        right: parent.right
                        left: parent.left
                    }
                }

                GridView {
                    id: mineObjects
                    anchors.fill: parent
                    cellWidth: parent.width / 4
                    cellHeight: parent.height / 4

                    delegate: Item {
                        width: mineObjects.cellWidth
                        height: mineObjects.cellHeight
                        Image {
                            source: Activity.url + "gold_nugget.svg"
                            sourceSize.width: mineObjects.cellWidth * 0.2
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: modelData.isTarget &&
                                     miningBg.scale === miningBg._MAX_SCALE &&
                                     !background.gotIt ? 1 : 0
                            MouseArea {
                                anchors.fill: parent
                                enabled: modelData.isTarget &&
                                         miningBg.scale === miningBg._MAX_SCALE
                                onClicked: {
                                    activity.audioEffects.play(Activity.url + "pickaxe.ogg")
                                    background.gotIt = true
                                }
                            }

                            Behavior on opacity { PropertyAnimation { duration: 1000 } }
                        }
                        Image {
                            id: cell
                            source: modelData.source
                            sourceSize.width: mineObjects.cellWidth * 3
                            width: mineObjects.cellWidth * modelData.widthFactor
                            height: mineObjects.cellHeight * modelData.widthFactor
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            rotation: modelData.rotation
                            opacity: !modelData.isTarget ? 1 : (background.gotIt ? 0 : 1)

                            Component.onCompleted: {
                                activity.audioEffects.play(Activity.url + "realrainbow.ogg")
                            }

                            ParallelAnimation {
                                running: modelData.isTarget && !background.gotIt
                                loops: Animation.Infinite
                                SequentialAnimation {
                                    loops: Animation.Infinite
                                    NumberAnimation {
                                        target: cell; property: "rotation"; from: 0; to: 360; duration: 5000;
                                        easing.type: Easing.InOutQuad
                                    }
                                    NumberAnimation {
                                        target: cell; property: "rotation"; from: 360; to: 0; duration: 5000;
                                        easing.type: Easing.InOutQuad
                                    }
                                }
                                SequentialAnimation {
                                    loops: Animation.Infinite
                                    NumberAnimation {
                                        target: cell; property: "scale"; from: 0; to: 1; duration: 3000;
                                        easing.type: Easing.InOutQuad
                                    }
                                    PauseAnimation { duration: 300 + Math.random() * 300 }
                                    NumberAnimation {
                                        target: cell; property: "scale"; from: 1; to: 0; duration: 1000;
                                        easing.type: Easing.InOutQuad
                                    }
                                }
                            }
                        }
                    }
                }

                function updateScale(zoomDelta, x, y) {
                    var xx1 = background.mapFromItem(miningBg, x, y)
                    var previousScale = miningBg.scale
                    if (zoomDelta > 0 && miningBg.scale < miningBg._MAX_SCALE) {
                        if(miningBg.scale < miningBg._MAX_SCALE - 0.1)
                            miningBg.scale += 0.1;
                        else
                            miningBg.scale = miningBg._MAX_SCALE
                    } else if (zoomDelta < 0) {
                        if(miningBg.scale > miningBg._MIN_SCALE) {
                            miningBg.scale -= 0.1;
                        } else if (gotIt) {
                            gotIt = false
                            if(miningBg.subLevel == miningBg.maxSubLevel) {
                                bonus.good("lion")
                            } else {
                                miningBg.subLevel++
                                miningBg.scale = miningBg._MIN_SCALE
                                Activity.createLevel()
                            }
                        } else {
                            miningBg.anchors.horizontalCenterOffset = 0
                            miningBg.anchors.verticalCenterOffset = 0
                        }
                    }
                    if(previousScale != miningBg.scale) {
                        var xx2 = background.mapFromItem(miningBg, x, y)
                        miningBg.anchors.horizontalCenterOffset += xx1.x - xx2.x
                        miningBg.anchors.verticalCenterOffset += xx1.y - xx2.y
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    propagateComposedEvents: true
                    onWheel: miningBg.updateScale(wheel.angleDelta.y, wheel.x, wheel.y)
                }

                MultiPointTouchArea {
                    anchors.fill: parent
                    mouseEnabled: false
                    minimumTouchPoints: 2
                    maximumTouchPoints: 2
                    // To determine if we zoom or unzoom
                    property int prevDist: 0
                    // To avoid having too many updates or the zoom flickers
                     property date dateEvent: new Date()
                    touchPoints: [
                               TouchPoint { id: point1 },
                               TouchPoint { id: point2 }
                           ]
                    onReleased: prevDist = 0
                    onTouchUpdated: {
                        // Calc Distance
                        var dist = Math.floor(Math.sqrt(Math.pow(point1.x - point2.x, 2) +
                                                        Math.pow(point1.y - point2.y, 2)))
                        var newDateEvent = new Date()
                        if(prevDist != dist &&
                                newDateEvent.getTime() - dateEvent.getTime() > 50) {
                            miningBg.updateScale(dist - prevDist,
                                                 (point1.x + point2.x) / 2,
                                                 (point1.y + point2.y) / 2)
                            dateEvent = newDateEvent
                        }
                        prevDist = dist
                    }
                }
        }

        Image {
            id: carriage
            source: Activity.url + "gold_carriage.svg"
            sourceSize.height: 120 * ApplicationInfo.ratio
            anchors {
                right: parent.right
                bottom: parent.bottom
            }

            GCText {
                id: score
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    horizontalCenterOffset: parent.width / 10
                }
                text: miningBg.subLevel + "/" + miningBg.maxSubLevel
                color: "white"
                font.bold: true
                style: Text.Outline
                styleColor: "black"
                font.pointSize: 22
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

            onLevelChanged: {
                miningBg.subLevel = 1
                miningBg.anchors.horizontalCenterOffset = 0
                miningBg.anchors.verticalCenterOffset = 0
                miningBg.scale = miningBg._MIN_SCALE

                switch(bar.level) {
                case 1:
                    miningBg.maxSubLevel = 2
                    break
                case 2:
                    miningBg.maxSubLevel = 4
                    break
                case 3:
                    miningBg.maxSubLevel = 10
                    break
                }

            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

    }

}
