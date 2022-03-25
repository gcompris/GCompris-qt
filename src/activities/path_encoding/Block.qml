/* GCompris - Block.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "path.js" as Activity

Item {
    id: block
    property int index

    Rectangle {
        id: baseSquare
        anchors.fill: parent
        color: path ? "#D1C8BE" : background.color
        border.color: "#A0000000"
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
