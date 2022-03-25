/* GCompris - MoveButtons.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "path.js" as Activity

Item {
    id: moveButtons

    property double spacing: size / 3
    property double size: Math.min(width / 5, height)

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
            Rectangle {
                anchors.fill: parent
                radius: width * 0.5
                color: "#00FFFFFF"
                border.color: "#F2F2F2"
                border.width: 4
            }
        }

        BarButton {
            id: downButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
            rotation: 90
            sourceSize.width: size
            onClicked: Activity.moveTowards(Activity.Directions.DOWN)
            Rectangle {
                anchors.fill: parent
                radius: width * 0.5
                color: "#00FFFFFF"
                border.color: "#F2F2F2"
                border.width: 4
            }
        }

        BarButton {
            id: leftButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
            rotation: -180
            sourceSize.width: size
            onClicked: Activity.moveTowards(Activity.Directions.LEFT)
            Rectangle {
                anchors.fill: parent
                radius: width * 0.5
                color: "#00FFFFFF"
                border.color: "#F2F2F2"
                border.width: 4
            }
        }

        BarButton {
            id: rightButton
            source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
            rotation: 0
            sourceSize.width: size
            onClicked: Activity.moveTowards(Activity.Directions.RIGHT)
            Rectangle {
                anchors.fill: parent
                radius: width * 0.5
                color: "#00FFFFFF"
                border.color: "#F2F2F2"
                border.width: 4
            }
        }
    }
}
