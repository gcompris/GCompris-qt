/* gcompris - SudokuCase.qml

 Copyright (C)
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
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.1
import "sudoku.js" as Activity
import GCompris 1.0


Rectangle {
    id: mCase
    color: isInitial ? "lightblue" : "blue"
    border.width: 3
    border.color: "black"

    property string text
    property bool isError
    property bool isInitial

    property int index

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
            name: "error"
            PropertyChanges {
                target: mCase
                color: "red"
            }
            PropertyChanges {
                target: colorTimer
                running: true
            }

        },
        State {
            name: "crossed"
            PropertyChanges {
                target: mCase
                opacity: 1.0
            }
        }
    ]

    Timer {
        id: colorTimer
        interval: 1500
        repeat: false
        onTriggered: { mCase.color = "blue"}
    }
}
