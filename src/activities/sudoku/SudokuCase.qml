/* gcompris - SudokuCase.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import "sudoku.js" as Activity
import GCompris 1.0


Rectangle {
    id: mCase
    property string text
    property bool isInitial
    property int gridIndex

    property int gridLineSize: Math.round(2 * ApplicationInfo.ratio)

    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        restoreColorTimer.stop();
    }

    Rectangle {
        id: topWall
        color: "#808080"
        height: gridLineSize
        width: parent.width + gridLineSize
        anchors.verticalCenter: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle {
        id: leftWall
        color: "#808080"
        width: gridLineSize
        height: parent.height + gridLineSize
        anchors.horizontalCenter: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle {
        id: rightWall
        color: "#808080"
        width: gridLineSize
        height: parent.height + gridLineSize
        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle {
        id: bottomWall
        color: "#808080"
        height: gridLineSize
        width: parent.width + gridLineSize
        anchors.verticalCenter: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: imageId
        source: Activity.dataToImageSource(mCase.text)
        width: parent.width * 0.75
        height: width
        sourceSize.height: width
        sourceSize.width: width
        anchors.centerIn: parent
    }

    states: [
        State {
            name: "default"
            PropertyChanges {
                target: mCase
                color: "#D6F2FC"
            }
        },
        State {
            name: "error"
            PropertyChanges {
                target: mCase
                color: "#EB7878"
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
                color: "#78B4EB"
            }
        },
        State {
            name: "initial"
            PropertyChanges {
                target: mCase
                color: "#EAD9F2"
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
