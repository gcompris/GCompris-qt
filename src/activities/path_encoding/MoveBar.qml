/* GCompris - MoveBar.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0
import QtQml.Models 2.12

import "../../core"
import "path.js" as Activity

Rectangle {
    id: moveBar
    color: "#55000000"
    border.color: GCStyle.whiteBorder
    border.width: GCStyle.thinBorder
    radius: GCStyle.halfMargins

    property int buttonWidth: Math.min(GCStyle.bigButtonHeight, movesGridView.height, movesGridView.width / 9)
    property int spacing: GCStyle.halfMargins
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
                width: moveBar.buttonWidth
                height: width
                anchors.horizontalCenter: box.horizontalCenter
                anchors.verticalCenter: box.verticalCenter
                // orange, gray, blue
                color: (active) ? "#E99E33" : (faded) ? "#B4B4B4" : "#1DB2E3"
                border.color: GCStyle.lightBorder
                border.width: active ? GCStyle.thickBorder: GCStyle.thinBorder
                radius: width * 0.5

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
        anchors.margins: GCStyle.halfMargins
        model: movesDelegateModel
        clip: true
        cellWidth: moveBar.buttonWidth + moveBar.spacing
        cellHeight: cellWidth
    }
}
