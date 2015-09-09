/* GCompris - melody.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Jose JORGE <jjorge@free.fr> (GTK+ version)
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
import "melody.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + 'xylofon_background.svg'
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop

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
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
            id: xylofon
            anchors {
                fill: parent
                margins: 10 * ApplicationInfo.ratio
            }
            source: Activity.url + 'xylofon.svg'
            sourceSize.width: parent.width * 0.7
            fillMode: Image.PreserveAspectFit
        }

        Repeater {
            model: 4
            Image {
                id: part
                parent: xylofon
                source: Activity.url + 'xylofon_part' + (index + 1) + '.svg'
                rotation: - 80
                anchors.horizontalCenter: xylofon.horizontalCenter
                anchors.horizontalCenterOffset: (- xylofon.paintedWidth) * 0.3 + xylofon.paintedWidth * index * 0.22
                anchors.verticalCenter: xylofon.verticalCenter
                anchors.verticalCenterOffset: - xylofon.paintedHeight * 0.1
                sourceSize.width: xylofon.paintedWidth * 0.5
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log(index)
                        activity.audioEffects.play(Activity.url +
                                                   'xylofon_son' + (index + 1) + '.ogg')
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
