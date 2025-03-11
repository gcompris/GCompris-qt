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
import core 1.0

import "../../core"
import "graph-coloring.js" as Activity

Item {
    id: root
    required property int index
    required property int colorIndex
    required property bool isError
    required property double posX
    required property double posY
    property alias border: color.border
    property bool highlightSymbol: false

    height: width

    Image {
        id: symbol
        visible: items.mode === "symbol"
        fillMode: Image.PreserveAspectFit
        source: root.colorIndex == -1 ? "qrc:/gcompris/src/core/resource/empty.svg" : Activity.symbols[root.colorIndex]
        anchors.fill: parent
        anchors.margins: GCStyle.halfMargins

        SequentialAnimation {
            id: anim
            running: root.isError
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
            running: !root.isError
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
        border.width: GCStyle.thinnestBorder
        border.color: GCStyle.darkBorder
        color: "transparent"
    }

    Rectangle {
        id: color
        visible: items.mode === "color" || root.colorIndex == -1
        color: root.colorIndex == -1 ? GCStyle.lightBg : Activity.colors[root.colorIndex]
        anchors.fill: parent
        anchors.margins: GCStyle.halfMargins
        radius: width * 0.5
    }
}
