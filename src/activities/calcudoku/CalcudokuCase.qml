/* GCompris - CalcudokuCase.qml
 *
 * SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "calcudoku.js" as Activity
import GCompris 1.0
import "../../core"


Rectangle {
    id: mCase
    border.width: 4
    border.color: "#2a2a2a"

    property string text
    property bool isInitial
    property string operator
    property string result
    property int gridIndex
    property bool topWallVisible
    property bool leftWallVisible
    property bool rightWallVisible
    property bool bottomWallVisible

    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        restoreColorTimer.stop();
    }

    Image {
        id: imageId
        source: Activity.dataToImageSource(mCase.text)
        sourceSize.height: parent.height
        width: 3 * parent.width / 4
        height: width
        anchors.centerIn: parent
    }
    GCText {
        id: resultOperator
        text: mCase.result + " " + mCase.operator
        width: parent.width / 3
        height: width
        fontSizeMode: Text.Fit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }
    Rectangle {
        id: topWall
        visible: topWallVisible
        border.color: "white"
        border.width: height
        height: 5
        width: parent.width-2*height
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5
    }
    Rectangle {
        id: leftWall
        visible: leftWallVisible
        border.color: "white"
        border.width: width
        width: 5
        height: parent.height-2*width
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 5
    }
    Rectangle {
        id: rightWall
        visible: rightWallVisible
        border.color: "white"
        border.width: width
        width: 5
        height: parent.height-2*width
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 5
    }
    Rectangle {
        id: bottomWall
        visible: bottomWallVisible
        border.color: "white"
        border.width: height
        height: 5
        width: parent.width-2*height
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 5
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
