/* GCompris - SearchItem.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 * 
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0
import "superbrain.js" as Activity
import "../../core"

Item {
    id: root
    property int searchItemIndex: 0
    property alias border: color.border
    property bool highlightSymbol: false

    Image {
        id: symbol
        visible: items.mode === "symbol"
        fillMode: Image.PreserveAspectFit
        source: Activity.symbols[root.searchItemIndex]
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: width
        sourceSize.width: width
        sourceSize.height: height
    }
    Rectangle {
        id: symbolHighlighter
        visible: (items.mode === "symbol") && root.highlightSymbol
        anchors.fill: parent
        width: parent.width
        height: parent.height
        border.width: GCStyle.thinBorder
        border.color: GCStyle.whiteBorder
        color: "transparent"
    }

    Rectangle {
        id: color
        visible: items.mode === "color"
        color: Activity.colors[root.searchItemIndex]
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: width
        radius: width * 0.5
    }
}
