/* gcompris - SudokuCase.qml

 Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import "sudoku.js" as Activity
import GCompris 1.0


Rectangle {
    id: mCase
    border.width: 2
    border.color: "#2a2a2a"

    property string text
    property bool isInitial
    property int gridIndex

    Image {
        id: imageId
        source: Activity.dataToImageSource(mCase.text)
        sourceSize.height: parent.height
        width: 3 * parent.width / 4
        height: width
        anchors.centerIn: parent
    }

    states: [
        State {
            name: "default"
            PropertyChanges {
                target: mCase
                color: "#33333333"
            }
        },
        State {
            name: "error"
            PropertyChanges {
                target: mCase
                color: "#AAEE1111"
            }
            PropertyChanges {
                target: restoreColorTimer
                running: true
           }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: mCase
                color: "#EE1111EE"
            }
        },
        State {
            name: "initial"
            PropertyChanges {
                target: mCase
                color: "#AA996699"
            }
        }
    ]

    Timer {
        id: restoreColorTimer
        interval: 1500
        repeat: false
        onTriggered: {
            Activity.restoreState(mCase)
        }
    }
}
