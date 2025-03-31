/* GCompris - MoveButtons.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

import "../../core"
import "path.js" as Activity

Item {
    id: moveButtons
    property int buttonSize: Math.min(GCStyle.bigButtonHeight, width * 0.25 - GCStyle.baseMargins, height)

    Flow {
        id: flow
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        spacing: moveButtons.spacing

        Item {
            id: buttonContainer
            width: moveButtons.width * 0.25
            height: moveButtons.height

            BarButton {
                id: upButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                rotation: -90
                width: moveButtons.buttonSize
                anchors.centerIn: parent
                onClicked: Activity.moveTowards(Activity.Directions.UP)
                Rectangle {
                    anchors.fill: parent
                    radius: width * 0.5
                    color: "#00FFFFFF"
                    border.color: GCStyle.lightBorder
                    border.width: GCStyle.thinBorder
                }
            }
        }

        Item {
            width: buttonContainer.width
            height: moveButtons.height

            BarButton {
                id: downButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                rotation: 90
                width: moveButtons.buttonSize
                anchors.centerIn: parent
                onClicked: Activity.moveTowards(Activity.Directions.DOWN)
                Rectangle {
                    anchors.fill: parent
                    radius: width * 0.5
                    color: "#00FFFFFF"
                    border.color: GCStyle.lightBorder
                    border.width: GCStyle.thinBorder
                }
            }
        }

        Item {
            width: buttonContainer.width
            height: moveButtons.height

            BarButton {
                id: leftButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                rotation: -180
                width: moveButtons.buttonSize
                anchors.centerIn: parent
                onClicked: Activity.moveTowards(Activity.Directions.LEFT)
                Rectangle {
                    anchors.fill: parent
                    radius: width * 0.5
                    color: "#00FFFFFF"
                    border.color: GCStyle.lightBorder
                    border.width: GCStyle.thinBorder
                }
            }
        }

        Item {
            width: buttonContainer.width
            height: moveButtons.height

            BarButton {
                id: rightButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                rotation: 0
                width: moveButtons.buttonSize
                anchors.centerIn: parent
                onClicked: Activity.moveTowards(Activity.Directions.RIGHT)
                Rectangle {
                    anchors.fill: parent
                    radius: width * 0.5
                    color: "#00FFFFFF"
                    border.color: GCStyle.lightBorder
                    border.width: GCStyle.thinBorder
                }
            }
        }
    }
}
