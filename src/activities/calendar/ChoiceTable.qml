/* GCompris - ChoiceTable.qml
 *
 * SPDX-FileCopyrightText: 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Amit Sagtani <asagtani06@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

// Creates a active button for making a table of days of weeks.
// Set different behaviours and animations on selecting a day from day table here.

import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "calendar.js" as Activity

Rectangle {
    id: choiceBox
    property alias choices: choices
    color: "#AAFFFFFF"
    radius: 10
    anchors.margins: 30
    border.color: "#373737"
    border.width: 2

    function select() {
        if(Activity.dayOfWeekSelected === Activity.correctAnswer["dayOfWeek"]) {
            particles.burst(40)
            animWin.start()
            Activity.checkAnswer()
        }
        else {
            crossAnim.start()
        }
    }

    Image {
        id: cross
        z: 10
        source: "qrc:/gcompris/src/core/resource/cancel.svg"
        sourceSize.width: choiceBox.height
        sourceSize.height: choiceBox.height
        anchors.centerIn: parent
        height: 0
        width: cross.height
        opacity: 1
        property int size: parent.height
    }

    SequentialAnimation {
        id: crossAnim
        ParallelAnimation {
            PropertyAnimation {
                target: cross
                property: "height"
                duration: 300
                from: 0
                to: choiceBox.height
                easing.type: Easing.InOutQuad
            }
        }
        PauseAnimation { duration: 800 }
        ParallelAnimation {
            PropertyAnimation {
                target: cross
                property: "height"
                duration: 300
                from: choiceBox.height
                to: 0
                easing.type: Easing.InOutQuad
            }
        }
    }

    ParticleSystemStarLoader {
        id: particles
        clip: false
    }

    GCText {
        id: choices
        anchors.fill: parent
        anchors.leftMargin: choiceBox.border.width
        anchors.rightMargin: choiceBox.border.width
        fontSizeMode: Text.Fit
        font.bold: true
        color: "#373737"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if(!questionDelay.running) {
                Activity.dayOfWeekSelected = dayIndex
                select()
                choiceBox.scale = 1
            }
        }
        hoverEnabled: true
        enabled: !crossAnim.running && !animWin.running
        onEntered: choiceBox.scale = 1.1
        onExited: choiceBox.scale = 1
    }

    SequentialAnimation {
        id: animWin
        running: false
        loops: 1
        NumberAnimation {
            target: choiceBox
            property: "rotation"
            from: 0; to: 360
            duration: 600
            easing.type: Easing.InOutQuad
        }
    }
}
