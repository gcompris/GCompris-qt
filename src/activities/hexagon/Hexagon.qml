/* GCompris - Hexagon.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
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

import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import GCompris 1.0

import "../../core"
import "hexagon.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/menu/resource/background.svgz"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop
        focus: true

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias hexagonModel: hexagonModel
        }

        onStart: Activity.start(main, items)
        onStop: Activity.stop()

        function checkTouchPoint(touchPoints) {
            for(var i in touchPoints) {
                var touch = touchPoints[i]
                var block = rootItem.childAt(touch.x, touch.y)
                if(block)
                    block.touched()
            }
        }

        MultiPointTouchArea {
            anchors.fill: parent
            onPressed: checkTouchPoint(touchPoints)
            onTouchUpdated: checkTouchPoint(touchPoints)
        }

        Item {
            id: rootItem
            anchors.fill: parent
        }

        ListModel {
            id: hexagonModel
        }

        Repeater {
            model: hexagonModel
            parent: rootItem

            HexagonItem {
                audioEffects: activity.audioEffects
                ix: m_ix
                iy: m_iy
                nbx: m_nbx
                nby: m_nby
                hasStrawberry: m_hasStrawberry
                color: "#0099FF"
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
