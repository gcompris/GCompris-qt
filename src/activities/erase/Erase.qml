/* GCompris - Erase.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import GCompris 1.0

import "../../core"
import "erase.js" as Activity

ActivityBase {
    id: activity
    focus: true
    property string type: "erase"

    onStart: {}
    onStop: {}

    pageComponent: Image {
        id: background
        signal start
        signal stop
        focus: true
        fillMode: Image.PreserveAspectCrop
        source: Activity.url + Activity.getFirstImage()
        sourceSize.width: parent.width

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property alias background: background
            property alias blocks: blocks
            property alias bar: bar
            property alias bonus: bonus
        }
        onStart: Activity.start(main, items, type)

        onStop: { Activity.stop() }

        MultiPointTouchArea {
            anchors.fill: parent
            onTouchUpdated: {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]

                    var newBlock = rootItem.childAt(touch.x, touch.y)
                    if(newBlock)
                        newBlock.enter()

                    var previousBlock = rootItem.childAt(touch.previousX, touch.previousY)
                    if(previousBlock !== newBlock && previousBlock != repeater)
                        previousBlock.leave()
                }
            }
        }

        Item {
            id: rootItem
        }

        ListModel {
            id: blocks
        }
        Repeater {
            id: repeater
            model: blocks
            parent: rootItem
            Block {
                id: modelData
                nbx: nx
                nby: ny
                ix: a
                iy: b
                opacity: op
                source: img
                type: activity.type
                main: MAIN
                bar: BAR
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }
}
