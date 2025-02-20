/* GCompris - CalcudokuCase.qml
 *
 * SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "calcudoku.js" as Activity
import core 1.0
import "../../core"


Rectangle {
    id: mCase
    border.color: GCStyle.grayBorder
    border.width: GCStyle.thinnestBorder
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

    Rectangle {
        id: resultOperatorBG
        visible: mCase.result != ""
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.05
        width: height * 3
        height: parent.height * 0.2
        color: "transparent"
        border.color: GCStyle.darkBorder
        border.width: GCStyle.thinnestBorder
        radius: height * 0.5
        GCText {
            id: resultOperator
            text: mCase.result + mCase.operator
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: GCStyle.darkText
        }
    }

    Image {
        id: imageId
        source: Activity.dataToImageSource(mCase.text)
        height: parent.height * 0.7
        width: height
        sourceSize.height: height
        sourceSize.width: width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0.05 * parent.height
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
