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
            property alias bar: bar
            property alias bonus: bonus
            property alias mineModel: mineObjects.model
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
                id: miningBg
                source: Activity.url + "rockwall.svg"
                anchors.fill: parent
                sourceSize.width: parent.width * 3
//                width: parent.width * 3
//                height: parent.height * 3
                scale: _MIN_SCALE

                property real _MAX_SCALE: 3
                property real _MIN_SCALE: 1

                property int level
                property int maxLevel

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
                                    audio.source = Activity.url + "pickaxe.ogg"
                                    audio.play()
                                    background.gotIt = true
                                }
                            }

                            Behavior on opacity { PropertyAnimation { duration: 1000 } }
                        }
                        Image {
                            id: cell
                            source: modelData.source
//                            sourceSize.width: mineObjects.cellWidth * modelData.widthFactor
                            sourceSize.width: mineObjects.cellWidth * 3
                            width: mineObjects.cellWidth * modelData.widthFactor
                            height: mineObjects.cellHeight * modelData.widthFactor
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            rotation: modelData.rotation
                            opacity: !modelData.isTarget ? 1 : (background.gotIt ? 0 : 1)

                            Component.onCompleted: {
                                audio.source = Activity.url + "realrainbow.ogg"
                                audio.play()
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

                    console.log(zoomDelta, miningBg.scale)
                    if (zoomDelta > 0 && miningBg.scale < miningBg._MAX_SCALE) {
                        if(miningBg.scale < miningBg._MAX_SCALE) {
//                            if(x <= miningBg.width / 3) {
//                                miningBg.anchors.left = background.left
//                                miningBg.anchors.right = undefined
//                                miningBg.anchors.horizontalCenter = undefined
//                            } else if(zoomDelta > parent.width * 2 / 3) {
//                                miningBg.anchors.left = undefined
//                                miningBg.anchors.right = background.right
//                                miningBg.anchors.horizontalCenter = undefined
//                            } else {
//                                miningBg.anchors.left = undefined
//                                miningBg.anchors.right = undefined
//                                miningBg.anchors.horizontalCenter = background.horizontalCenter
//                            }


//                            if(y <= miningBg.height / 3) {
//                                miningBg.anchors.top = background.top
//                                miningBg.anchors.bottom = undefined
//                                miningBg.anchors.verticalCenter = undefined
//                            } else if(y > miningBg.height * 2 / 3) {
//                                miningBg.anchors.top = undefined
//                                miningBg.anchors.bottom = background.bottom
//                                miningBg.anchors.verticalCenter = undefined
//                            } else {
//                                miningBg.anchors.top = undefined
//                                miningBg.anchors.bottom = undefined
//                                miningBg.anchors.verticalCenter = background.verticalCenter
//                            }

                        }
                        if(miningBg.scale < miningBg._MAX_SCALE - 0.1)
                            miningBg.scale += 0.1;
                        else
                            miningBg.scale = miningBg._MAX_SCALE
                    } else if (zoomDelta < 0) {
                        if(miningBg.scale > miningBg._MIN_SCALE) {
                            miningBg.scale -= 0.1;
                        } else if (gotIt) {
                            gotIt = false
                            if(miningBg.level == miningBg.maxLevel)
                                bonus.good("lion")
                            else {
                                miningBg.level++
                                miningBg.scale = miningBg._MIN_SCALE
                                Activity.createLevel()
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: !ApplicationInfo.isMobile
                    propagateComposedEvents: true

                    onWheel: miningBg.updateScale(wheel.angleDelta.y, wheel.x, wheel.y)
                }

//                PinchArea {
//                    id: pinchy
//                    property int xpoint
//                    property int ypoint
//                    property int pinchscale
//                    enabled: true
//                    anchors.fill: parent
//                    pinch.dragAxis: Pinch.XandYAxis
//                    pinch.minimumX: - parent.width / 2
//                    pinch.maximumX: parent.width / 2
//                    pinch.minimumY: - parent.height / 2
//                    pinch.maximumY: parent.height / 2
//                    onPinchUpdated: {
//                        xpoint = pinch.center.x;
//                        ypoint = pinch.center.y;
//                        pinchscale = pinch.scale
//                        miningBg.scale = pinchscale + 1
//                        console.log(xpoint, ypoint, pinchscale)
//                    }
//                }

                MultiPointTouchArea {
                    anchors.fill: parent
                    enabled: ApplicationInfo.isMobile
                    mouseEnabled: false
                    minimumTouchPoints: 2
                    maximumTouchPoints: 2
                    property int prevDist: -1
                    touchPoints: [
                               TouchPoint { id: point1 },
                               TouchPoint { id: point2 }
                           ]
                    onTouchUpdated: {
                        // Calc Distance
                        var dist = Math.floor(Math.sqrt(Math.pow(point1.x - point2.x, 2),
                                                        Math.pow(point1.y - point1.y, 2)) / 50)
                        console.log("dist=", dist)

                        if(prevDist > -1 && prevDist != dist)
                            miningBg.updateScale(dist - prevDist,
                                                 point1.x, point1.y)
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

            Text {
                id: score
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    horizontalCenterOffset: parent.width / 10
                }
                text: miningBg.level + "/" + miningBg.maxLevel
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
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()

            onLevelChanged: {
                miningBg.scale = miningBg._MIN_SCALE
                miningBg.level = 1
                switch(bar.level) {
                case 1:
                    miningBg.maxLevel = 2
                    break
                case 2:
                    miningBg.maxLevel = 4
                    break
                case 3:
                    miningBg.maxLevel = 10
                    break
                }

            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        GCAudio {
            id: audio
        }
    }

}
