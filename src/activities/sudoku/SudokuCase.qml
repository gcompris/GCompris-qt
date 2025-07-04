/* gcompris - SudokuCase.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick
import "sudoku.js" as Activity
import core 1.0
import "../../core"

Rectangle {
    id: mCase
    property string text
    property bool isInitial
    property int gridIndex

    property int gridLineSize: GCStyle.thinBorder

    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        restoreColorTimer.stop();
    }

    Rectangle {
        id: topWall
        color: "#909090"
        height: gridLineSize
        width: parent.width + gridLineSize
        anchors.verticalCenter: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle {
        id: leftWall
        color: "#909090"
        width: gridLineSize
        height: parent.height + gridLineSize
        anchors.horizontalCenter: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle {
        id: rightWall
        color: "#909090"
        width: gridLineSize
        height: parent.height + gridLineSize
        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle {
        id: bottomWall
        color: "#909090"
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
                mCase {
                    color: "#D6F2FC"
                }
            }
        },
        State {
            name: "error"
            PropertyChanges {
                mCase {
                    color: "#EB7878"
                }
            }
            PropertyChanges {
                restoreColorTimer {
                    running: true
                }
           }
        },
        State {
            name: "hovered"
            PropertyChanges {
                mCase {
                    color: "#78B4EB"
                }
            }
        },
        State {
            name: "initial"
            PropertyChanges {
                mCase {
                    color: "#EAD9F2"
                }
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
