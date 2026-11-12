/* GCompris - MoveButtons.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

import "../../core"
import "path.js" as Activity

Item {
    id: moveButtons
    property int buttonSize: Math.min(GCStyle.bigButtonHeight, width * 0.25 - GCStyle.baseMargins, height)
    enabled: !items.buttonsBlocked

    property alias upButton: upButton
    property alias downButton: downButton
    property alias leftButton: leftButton
    property alias rightButton: rightButton

    Flow {
        id: flow
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        Item {
            id: upButtonContainer
            width: moveButtons.width * 0.25
            height: moveButtons.height

            BarButton {
                id: upButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                rotation: -90
                width: moveButtons.buttonSize
                anchors.centerIn: parent
                onClicked: {
                    Activity.moveTowards(Activity.Directions.UP, upButtonContainer);
                }
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
            id: downButtonContainer
            width: upButtonContainer.width
            height: moveButtons.height

            BarButton {
                id: downButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                rotation: 90
                width: moveButtons.buttonSize
                anchors.centerIn: parent
                onClicked: {
                    Activity.moveTowards(Activity.Directions.DOWN, downButtonContainer);
                }
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
            id: leftButtonContainer
            width: upButtonContainer.width
            height: moveButtons.height

            BarButton {
                id: leftButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                rotation: -180
                width: moveButtons.buttonSize
                anchors.centerIn: parent
                onClicked: {
                    Activity.moveTowards(Activity.Directions.LEFT, leftButtonContainer);
                }
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
            id: rightButtonContainer
            width: upButtonContainer.width
            height: moveButtons.height

            BarButton {
                id: rightButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                rotation: 0
                width: moveButtons.buttonSize
                anchors.centerIn: parent
                onClicked: {
                    Activity.moveTowards(Activity.Directions.RIGHT, rightButtonContainer);
                }
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
