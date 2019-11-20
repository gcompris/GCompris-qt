/* GCompris - tutorial1.qml
 *
 * Copyright (C) 2018 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.13
import GCompris 1.0 

import "../../../core"
import "../../../activities"

Item {
    id: tutorial1

    property bool animationIsRunning: animationIsRunning
    property int unitClassDragButtonOrigX
    property int unitClassDragButtonOrigY
    property int thousandClassDragButtonOrigX
    property int thousandClassDragButtonOrigY

    Component.onCompleted: {
        console.log("tutorial1_screen_loaded")
        animUnitClassX.running = true
        animUnitClassY.running = true
    }

    NumberAnimation{
        id: animUnitClassX

        target: numberClassDragElements.itemAt(0)
        property: "x";
        to: background.width * 2/3
        duration: 3000
        onStarted: {
            unitClassDragButtonOrigX = numberClassDragElements.itemAt(0).x
            unitClassDragButtonOrigY = numberClassDragElements.itemAt(0).y
            animationIsRunning = true
            numberClassDragElements.itemAt(0).animationIsRunning = animationIsRunning
            console.log("onStarted")
        }
        onFinished: {
            numberClassDragElements.itemAt(0).Drag.drop()
            console.log("Sent Drag drop")
            animationIsRunning = false
            numberClassDragElements.itemAt(0).x = unitClassDragButtonOrigX

            numberClassDragElements.itemAt(0).z = 1000
            animThousandClassX.running = true
            animThousandClassY.running = true
        }
    }

    NumberAnimation{
        id: animUnitClassY

        target: numberClassDragElements.itemAt(0)
        property: "y";
        to: background.height * 1/3
        duration: 3000

        onFinished: {
            numberClassDragElements.itemAt(0).y = unitClassDragButtonOrigY
        }

    }

    NumberAnimation{
        id: animThousandClassX

        target: numberClassDragElements.itemAt(1)
        property: "x";
        to: background.width * 1/3
        duration: 3000
        onStarted: {
            thousandClassDragButtonOrigX = numberClassDragElements.itemAt(1).x
            thousandClassDragButtonOrigY = numberClassDragElements.itemAt(1).y
            animationIsRunning = true
            numberClassDragElements.itemAt(1).animationIsRunning = animationIsRunning
            console.log("onStarted")
        }
        onFinished: {
            numberClassDragElements.itemAt(1).Drag.drop()
            console.log("Sent Drag drop")
            animationIsRunning = false
            numberClassDragElements.itemAt(1).x = thousandClassDragButtonOrigX
            numberClassDragElements.itemAt(1).z = 1000
        }
    }

    NumberAnimation{
        id: animThousandClassY

        target: numberClassDragElements.itemAt(1)
        property: "y";
        to: background.height * 1/3
        duration: 3000

        onFinished: {
            numberClassDragElements.itemAt(1).y = thousandClassDragButtonOrigY
        }

    }


}
