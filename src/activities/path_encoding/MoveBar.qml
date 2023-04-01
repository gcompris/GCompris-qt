/* GCompris - MoveBar.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0
import QtQml.Models 2.12

import "path.js" as Activity

Rectangle {
    id: moveBar
    color: "#55000000"
    border.color: "white"
    border.width: 4
    radius: ApplicationInfo.ratio * 10

    property double buttonWidth: Math.min(height * 0.9, width / 9)
    property int spacing: 0.15 * buttonWidth

    property alias movesGridView: movesGridView

    DelegateModel {
        id: movesDelegateModel
        model: movesListModel
        delegate:
        Item {
            id: box
            width: movesGridView.cellWidth
            height: movesGridView.cellHeight
            Rectangle {
                width: buttonWidth
                height: width
                anchors.horizontalCenter: box.horizontalCenter
                anchors.verticalCenter: box.verticalCenter
                // orange, gray, blue
                color: (active) ? "#E99E33" : (faded) ? "#B4B4B4" : "#1DB2E3"
                border.color: "#F2F2F2"
                border.width: (active) ? 8 : 4
                radius: width / 2

                Image {
                    source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                    anchors.fill: parent
                    sourceSize.width: width
                    height: width
                    rotation: [Activity.Directions.RIGHT, Activity.Directions.DOWN, Activity.Directions.LEFT, Activity.Directions.UP].indexOf(direction) * 90
                }
            }
        }
    }

    GridView {
        id: movesGridView
        anchors.fill: parent
        anchors.margins: moveBar.border.width
        model: movesDelegateModel
        clip: true
        cellWidth: buttonWidth + spacing
        cellHeight: cellWidth
    }
}
