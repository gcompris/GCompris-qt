/* gcompris - SudokuCase.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.9
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
