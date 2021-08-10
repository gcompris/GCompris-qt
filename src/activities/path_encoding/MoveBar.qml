/* GCompris - MoveBar.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0
import QtQml.Models 2.1

import "../../core" as Core
import "path.js" as Activity

Rectangle {
    id: moveBar
    color: "lightblue"
    border.color: "white"
    border.width: 0.01 * width
    radius: ApplicationInfo.ratio * 10

    property double buttonWidth: Math.min(ApplicationInfo.ratio * 50, width / 4.5)
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
                color: (active) ? "green" : (faded) ? "gray" : "pink"
                border.color: "black"
                border.width: 2
                radius: width / 2

                Image {
                    source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                    width: 0.6 * parent.width
                    sourceSize.width: width
                    height: width
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
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
