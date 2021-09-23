/* GCompris - Board.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0

import "../../core"

Rectangle {
    id: board
    color: '#F6E1E1'
    radius: pitWidth / 2
    height: rowPlayer1.height + rowPlayer2.height + 3 * margin
    opacity: 0.85

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

    Row {
        id: rowPlayer1
        anchors{
            top: parent.top
            topMargin: margin
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
            bottom: parent.bottom
            bottomMargin: margin
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
