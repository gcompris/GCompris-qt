/* GCompris - Block.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

import "../../core"

Item {
    id: block
    property int index
    height: width

    Rectangle {
        id: baseSquare
        anchors.fill: parent
        anchors.margins: -GCStyle.thinnestBorder * 0.5
        color: path ? "#D1C8BE" : "transparent"
        border.color: GCStyle.darkBorder
        border.width: GCStyle.thinnestBorder
        visible: invisible ? 0 : 1
    }

    Image {
        width: parent.width
        height: parent.height
        sourceSize.width: width
        anchors.centerIn: parent
        source:
            (rock) ? "qrc:/gcompris/src/activities/path_encoding/resource/rock.svg" :
            (tree) ? "qrc:/gcompris/src/activities/path_encoding/resource/tree.svg" :
            (bush) ? "qrc:/gcompris/src/activities/path_encoding/resource/bush.svg" :
            (grass) ? "qrc:/gcompris/src/activities/path_encoding/resource/grass.svg" :
            (water) ? "qrc:/gcompris/src/activities/path_encoding/resource/water.svg" :
            (flag) ? "qrc:/gcompris/src/activities/path_encoding/resource/flag.svg" :
            ""
        fillMode: Image.PreserveAspectFit
    }
}
