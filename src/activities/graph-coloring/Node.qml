/* GCompris - SearchItem.qml
 *
 * Copyright (C) Holger Kaelberer <holger.k@elberer.de>
 * 
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0
import "graph-coloring.js" as Activity

Item {
    id: root
    property int searchItemIndex: -1
    property alias border: color.border
    property alias radius: color.radius
    property bool highlightSymbol: false
    property bool symbolRotation: false

    Image {
        id: symbol
        visible: items.mode === "symbol"
        fillMode: Image.PreserveAspectFit
        source: searchItemIndex == -1 ? Activity.url + "shapes/" + "circle_node.svg" : Activity.symbols[root.searchItemIndex]
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 3
        width: parent.width - 6
        height: parent.height - 6
        SequentialAnimation {
            id: anim
            running: root.symbolRotation
            loops: Animation.Infinite
            NumberAnimation {
                target: symbol
                property: "rotation"
                from: -10; to: 10
                duration: 500
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: symbol
                property: "rotation"
                from: 10; to: -10
                duration: 500
                easing.type: Easing.InOutQuad }
        }
        NumberAnimation {
            id: rotationStop
            running: !root.symbolRotation
            target: symbol
            property: "rotation"
            to: 0
            duration: 500
            easing.type: Easing.InOutQuad
        }
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
        color: root.searchItemIndex == -1 ? "white" : Activity.colors[root.searchItemIndex]
        anchors.fill: parent
        width: parent.width
        height: parent.height
        radius: width / 2
    }
}
