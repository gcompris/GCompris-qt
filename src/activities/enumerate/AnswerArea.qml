/* GCompris - AnswerArea.qml
*
* SPDX-FileCopyrightText: 2014 Thib ROMAIN <thibrom@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0
import "enumerate.js" as Activity

import "../../core"

Rectangle {
    id: answerBackground
    width: activityBackground.answersWidth
    height: width * 0.5
    radius: GCStyle.halfMargins
    property bool isSelected: false
    property alias itemText: userEntry.text
    property int itemIndex: 0

    border {
        width: isSelected && state === "default" ?  GCStyle.midBorder : GCStyle.thinnestBorder
    }

    states: [
        State {
            name: "badAnswer"
            PropertyChanges {
                answerBackground {
                    color: GCStyle.badAnswer  //red
                    border.color: GCStyle.darkBorder
                }
            }
        },
        State {
            name: "goodAnswer"
            PropertyChanges {
                answerBackground {
                    color: "#54ea54" //green
                    border.color: GCStyle.whiteBorder
                }
            }
        },
        State {
            name: "default"
            PropertyChanges {
                answerBackground {
                    color: isSelected ? GCStyle.highlightColor : GCStyle.paperWhite //lightblue, white
                    border.color: GCStyle.darkBorder
                }
            }
        }
    ]

    GCSoundEffect {
        id: winSound
        source: "qrc:/gcompris/src/core/resource/sounds/win.wav"
    }

    property string imgPath

    // True when the value is entered correctly
    property bool valid: false

    onValidChanged: valid ? winSound.play() : null

    // A top gradient
    Rectangle {
        anchors.fill: parent
        anchors.margins: parent.border.width
        radius: parent.radius - parent.border.width
        visible: answerBackground.state === "default"
        gradient: Gradient {
                GradientStop { position: 0.0; color: valid ? "#54ea54" : "#CCFFFFFF" }
                GradientStop { position: 0.2; color: valid ? "#54ea54" : "#80FFFFFF" }
                GradientStop { position: 0.8; color: valid ? "#54ea54" : "#80FFFFFF" }
                GradientStop { position: 1.0; color: valid ? "#54ea54" : "#00000000" }
        }
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !items.buttonsBlocked
        onClicked: {
            Activity.selectItem(answerBackground.itemIndex)
            Activity.resetAnswerAreaColor();
        }
    }

    Image {
        id: img
        anchors {
            left: parent.left
            leftMargin: GCStyle.baseMargins
            verticalCenter: parent.verticalCenter
        }
        height: parent.height - GCStyle.baseMargins
        width: height
        source: imgPath
        fillMode: Image.PreserveAspectFit
    }

    GCText {
        id: userEntry
        anchors {
            left: img.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: GCStyle.baseMargins
        }
        text: "?"
        color: GCStyle.darkText
        fontSize: 28
        fontSizeMode: Text.Fit
        style: Text.Outline
        styleColor: GCStyle.whiteText
    }

}
