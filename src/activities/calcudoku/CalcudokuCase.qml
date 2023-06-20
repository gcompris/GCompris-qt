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
    border.color: "#808080"
    border.width: ApplicationInfo.ratio
    property string text
    property bool isInitial
    property string operator
    property string result
    property int gridIndex

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
