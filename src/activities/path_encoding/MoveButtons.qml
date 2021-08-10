/* GCompris - MoveButtons.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0

import "../../core"
import "path.js" as Activity

Item {
    id: moveButtons

    property double spacing: Math.min(0.05 * width, 15 * ApplicationInfo.ratio)
    property double size: Math.min((width - 3 * spacing)/4, 55 * ApplicationInfo.ratio)

    Flow {
        id: flow
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        spacing: moveButtons.spacing

        BarButton {
            id: upButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
            rotation: -90
            sourceSize.width: size
            onClicked: Activity.moveTowards(Activity.Directions.UP)
        }

        BarButton {
            id: downButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
            rotation: 90
            sourceSize.width: size
            onClicked: Activity.moveTowards(Activity.Directions.DOWN)
        }

        BarButton {
            id: leftButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
            rotation: -180
            sourceSize.width: size
            onClicked: Activity.moveTowards(Activity.Directions.LEFT)
        }

        BarButton {
            id: rightButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
            rotation: 0
            sourceSize.width: size
            onClicked: Activity.moveTowards(Activity.Directions.RIGHT)
        }
    }
}
