/* GCompris - Scalesboard.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   miguel DE IZARRA <miguel2i@free.fr> (GTK+ version)
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

import "../../core"
import "scalesboard.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop

        property int scaleHeight: items.masseAreaLeft.weight == items.masseAreaRight.weight ? 0 :
                                 items.masseAreaLeft.weight > items.masseAreaRight.weight ? 20 : -20

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
            property alias masseAreaCenter: masseAreaCenter
            property alias masseAreaLeft: masseAreaLeft
            property alias masseAreaRight: masseAreaRight
            property alias masseCenterModel: masseAreaCenter.masseModel
            property alias masseRightModel: masseAreaRight.masseModel
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        onScaleHeightChanged: Activity.initCompleted && scaleHeight == 0 ? bonus.good("flower") : null

        Image {
            id: scale
            source: Activity.url + "scale.svg"
            sourceSize.width: parent.width * 0.8
            anchors.centerIn: parent
        }

        Image {
            id: needle
            parent: scale
            source: Activity.url + "needle.svg"
            sourceSize.width: parent.width * 0.75
            z: -10
            property int angle: - background.scaleHeight * 0.35
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.15
            }
            transform: Rotation {
                origin.x: needle.width / 2
                origin.y: needle.height * 0.9
                angle: needle.angle
            }
            Behavior on angle {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // === The Left plate ===
        Image {
            id: plateLeft
            parent: scale
            source: Activity.url + "plate.svg"
            sourceSize.width: parent.width * 0.35
            z: -1

            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: - parent.paintedWidth * 0.3
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.03 + background.scaleHeight
            }
            Behavior on anchors.verticalCenterOffset {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            // The Left Drop Area
            MasseArea {
                id: masseAreaLeft
                parent: scale
                height: itemHeight
                width: plateLeft.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: - parent.paintedWidth * 0.3
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: - parent.paintedHeight * 0.4 + background.scaleHeight
                }
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                nbColumns: 4

                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // === The Right plate ===
        Image {
            id: plateRight
            parent: scale
            source: Activity.url + "plate.svg"
            sourceSize.width: parent.width * 0.35
            z: -1
            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: parent.paintedWidth * 0.3
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.03 - background.scaleHeight
            }
            Behavior on anchors.verticalCenterOffset {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            // The Right Drop Area
            MasseArea {
                id: masseAreaRight
                parent: scale
                height: itemHeight
                width: plateRight.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.paintedWidth * 0.3
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: - parent.paintedHeight * 0.4 - background.scaleHeight
                }
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                nbColumns: 4

                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // === The Initial Masses List ===
        MasseArea {
            id: masseAreaCenter
            parent: scale
            x: parent.width * 0.05
            y: parent.height * 0.86 - height
            width: parent.width
            masseAreaCenter: masseAreaCenter
            masseAreaLeft: masseAreaLeft
            masseAreaRight: masseAreaRight
            nbColumns: masseModel.count / nbLines
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
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }

}
