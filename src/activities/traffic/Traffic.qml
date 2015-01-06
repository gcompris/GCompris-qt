/* GCompris - Traffic.qml
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
import "traffic.js" as Activity

ActivityBase {
    id: activity

    property string mode: "IMAGE" // allow to choose between "COLOR" and "IMAGE"
                                  // mode, candidate for a config dialog
    
    onStart: focus = true
    onStop: {}
    
    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/traffic/resource/traffic_bg.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop
        
        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias jamBox: jamBox
            property alias jamGrid: jamGrid
        }

        onStart: { Activity.start(items, mode) }
        onStop: { Activity.stop() }
        
        Image {
            id: jamBox
            source: "qrc:/gcompris/src/activities/traffic/resource/traffic_box.svg"

            anchors.centerIn: parent
            sourceSize.width: Math.max(400, background.width * 0.4175 * ApplicationInfo.ratio) //334
            sourceSize.height: Math.max(400, background.height * 0.636538462 * ApplicationInfo.ratio) //331
            fillMode: Image.PreserveAspectFit
            property double scaleFactor: Math.min(background.width / background.sourceSize.width,
                    background.height / background.sourceSize.height)
            
            Grid {
                id: jamGrid
                anchors.centerIn: parent
                width: parent.width - 86 * jamBox.scaleFactor * ApplicationInfo.ratio
                height: parent.height - 86 * jamBox.scaleFactor * ApplicationInfo.ratio
                columns: 6
                rows: 6
                spacing: 0
                
                Repeater {
                    id: gridRepeater
                    model: jamGrid.columns * jamGrid.rows
                    
                    delegate: Rectangle {
                        id: gridDelegate
                        height: jamGrid.height/ jamGrid.rows
                        width: height
                        border.width: 1
                        border.color: "white"
                        color: "#444444"
                    }
                }
            }
        }
        
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }
        
        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel();
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
        
        Score {
            id: score

            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
        }
        
    }
}
