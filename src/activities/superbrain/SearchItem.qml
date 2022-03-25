/* GCompris - SearchItem.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 * 
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0
//import QtGraphicalEffects 1.0
import "superbrain.js" as Activity

Item {
    id: root
    property int searchItemIndex: 0
    property alias border: color.border
    property alias radius: color.radius
    property bool highlightSymbol: false

    Image {
        id: symbol
        visible: items.mode === "symbol"
        fillMode: Image.PreserveAspectFit
        source: Activity.symbols[root.searchItemIndex]
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 3
        width: parent.width - 6
        height: parent.height - 6
    }
    Rectangle {
        id: symbolHighlighter
        visible: (items.mode === "symbol") && root.highlightSymbol
        anchors.fill: parent
        width: parent.width
        height: parent.height
        border.width: 3
        border.color: "white"
        color: "transparent"
    }

    Rectangle {
        id: color
        visible: items.mode === "color"
        color: Activity.colors[root.searchItemIndex]
        anchors.fill: parent
        width: parent.width
        height: parent.height
        radius: width / 2
    }
}
