/* GCompris - ascending_order.qml
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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
import QtQuick.Window 2.0

import "../../core"
import "ascending_order.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}


    pageComponent: Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "resource/background.svg"
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
            property alias grids: grids
            property alias boxes: boxes
            property alias ansText: ansText
            property alias ok: ok
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            id: ansText
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            text: ""
            font.pixelSize: 40
        }

        Grid {
            id: grids
            spacing: 12
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            Repeater {
                id: boxes
                model: 4
                property int scale_factor: Screen.pixelDensity/default_pix_density
                Rectangle {
                    property int imageX: 0
                    width: 360/4 * ApplicationInfo.ratio
                    height: 360/4 * ApplicationInfo.ratio
                    radius: 20
                    property int clicked:0

                    MouseArea {
                        anchors.fill: parent
                        onClicked :{
                            Activity.check(numText.text)
                        }
                    }

                    GCText {
                        id: numText
                        anchors.centerIn: parent
                        text: imageX.toString()
                    }
                }
            }
        }



        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BarButton {
          id: ok
          source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
          sourceSize.width: 75 * ApplicationInfo.ratio
          visible: false
          anchors {
              right: parent.right
              bottom: parent.bottom
              bottomMargin: 10 * ApplicationInfo.ratio
              rightMargin: 10 * ApplicationInfo.ratio
          }
          onClicked: Activity.retry()
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
