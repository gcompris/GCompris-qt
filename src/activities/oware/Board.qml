/* GCompris - Board.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Timothée Giet <animtim@gmail.com> (redesign)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "oware.js" as Activity

Rectangle {
    id: board
    color: "#80FFFFFF"
    radius: pitWidth / 2
    height: topSideBg.height * 3
    opacity: 1

    property double margin: 15 * ApplicationInfo.ratio
    property double pitWidth: (width - 7 * margin) / numberOfPitsInOneRow
    property alias pitRepeater1: pitRepeater1
    property alias pitRepeater2: pitRepeater2

    readonly property int numberOfPitsInOneRow: 6

    signal init
    onInit: {
        for(var i = 0; i < numberOfPitsInOneRow; ++i) {
            pitRepeater1.itemAt(i).seeds = 4
            pitRepeater2.itemAt(i).seeds = 4
            pitRepeater1.itemAt(i).index = pitRepeater2.itemAt(i).index = i
        }
    }

    Image {
        id: topSideBg
        source: Activity.url + "boardSide.svg"
        width: parent.width
        height: rowPlayer1.height * 1.5
        sourceSize.width: width
        sourceSize.height: height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.verticalCenter
    }

    Image {
        id: bottomSideBg
        source: Activity.url + "boardSide.svg"
        width: parent.width
        height: topSideBg.height
        sourceSize.width: width
        sourceSize.height: height
        rotation: 180
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
    }

    Row {
        id: rowPlayer1
        anchors{
            verticalCenter: topSideBg.verticalCenter
            left: parent.left
            leftMargin: margin
        }
        spacing: margin
        Repeater {
            id: pitRepeater1
            model: numberOfPitsInOneRow
            delegate: Pit {
                player: 1
                width: pitWidth
            }
        }
    }

    Row {
        id: rowPlayer2
        anchors{
            verticalCenter: bottomSideBg.verticalCenter
            left: parent.left
            leftMargin: margin
        }
        spacing: margin
        Repeater {
            id: pitRepeater2
            model: numberOfPitsInOneRow
            delegate: Pit {
                player: 2
                width: pitWidth
            }
        }
    }
}
