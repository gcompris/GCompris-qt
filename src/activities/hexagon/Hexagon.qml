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
pragma ComponentBehavior: Bound

import QtQuick 2.12
import QtQuick.Shapes 1.5
import core 1.0

import "../../core"
import "hexagon.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true

    pageComponent: Image {
        id: activityBackground
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias hexagonModel: hexagonModel
            property alias winSound: winSound
            property alias shapeData: cellFill.data
            property bool inputLocked: true
        }

        onStart: Activity.start(activity, items)
        onStop: Activity.stop()

        function checkTouchPoint(touchPoints) {
            if(items.inputLocked) {
                return
            }
            for(var i in touchPoints) {
                var touch = touchPoints[i]
                var block = rootItem.childAt(touch.x, touch.y)
                if(block)
                    (block as HexagonItem).touched()
            }
        }

        GCSoundEffect {
            id: winSound
            source: "qrc:/gcompris/src/core/resource/sounds/win.wav"
        }

        MultiPointTouchArea {
            anchors.fill: parent
            onPressed: (touchPoints) => activityBackground.checkTouchPoint(touchPoints)
        }

        Shape {
            id: cellFill
            anchors.fill: parent
            asynchronous: true
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
                required property int m_ix
                required property int m_iy
                required property int m_nbx
                required property int m_nby
                required property bool m_hasStrawberry

                ix: m_ix
                iy: m_iy
                nbx: m_nbx
                nby: m_nby
                hasStrawberry: m_hasStrawberry
                color: "#0099FF"
                winSound: winSound
                Component.onCompleted: cellFill.data.push(cellColor)

                onStrawberryFound: {
                    items.inputLocked = true
                    bonus.good("flower")
                }
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                activity.displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            interval: 2000
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
