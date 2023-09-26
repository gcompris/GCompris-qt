/* GCompris - Hexagon.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "hexagon.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/menu/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
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
            property int currentLevel: activity.currentLevel
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
            level: items.currentLevel + 1
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
            interval: 2000
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
